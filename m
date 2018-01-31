Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49894 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbeAaUaY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jan 2018 15:30:24 -0500
Subject: Re: [PATCH v2 27/29] xfs_scrub: integrate services with systemd
References: <151736799098.32164.15446216987522359103.stgit@magnolia>
 <151736817316.32164.953271653758103738.stgit@magnolia>
 <20180131064100.GC4849@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a2d8f4f5-dc78-b350-bcc2-a4f00abca9ad@sandeen.net>
Date: Wed, 31 Jan 2018 14:30:22 -0600
MIME-Version: 1.0
In-Reply-To: <20180131064100.GC4849@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/31/18 12:41 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a systemd service unit so that we can run the online scrubber
> under systemd with (somewhat) appropriate containment.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix some of the debian packaging weirdness, kudos to Nathan Scott!

Er, hang on:

checking for SYSTEMD... configure: error: Package requirements (systemd) were not met:

now systemd is a /build/ requirement for xfsprogs?  nope nope. :)

This is only used for unit file install targets, right?  If systemd
is missing, surely those install targets should just be skipped.

Looks like the Makefile DTRT, but the stuff in m4/ should be non-fatal?

(I can't tell what makes this fatal ... I think its' fatal?

> checking for SYSTEMD... configure: error: Package requirements (systemd) were not met:
> 
> No package 'systemd' found
> 
> Consider adjusting the PKG_CONFIG_PATH environment variable if you
> installed software in a non-standard prefix.
> 
> Alternatively, you may set the environment variables SYSTEMD_CFLAGS
> and SYSTEMD_LIBS to avoid the need to call pkg-config.
> See the pkg-config man page for more details.
> 
> # echo $?
> 1

looks fatal.)

...


> diff --git a/scrub/Makefile b/scrub/Makefile
> index ca6dab0..0632794 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -15,6 +15,19 @@ LTCOMMAND = xfs_scrub
>  INSTALL_SCRUB = install-scrub
>  XFS_SCRUB_ALL_PROG = xfs_scrub_all
>  XFS_SCRUB_ARGS = -b -n
> +ifeq ($(HAVE_SYSTEMD),yes)
> +INSTALL_SCRUB += install-systemd
> +SYSTEMD_SERVICES = xfs_scrub@.service xfs_scrub_all.service xfs_scrub_all.timer xfs_scrub_fail@.service
> +OPTIONAL_TARGETS += $(SYSTEMD_SERVICES)
> +endif
> +ifeq ($(HAVE_CROND),yes)
> +INSTALL_SCRUB += install-crond
> +CRONTABS = xfs_scrub_all.cron
> +OPTIONAL_TARGETS += $(CRONTABS)
> +# Don't enable the crontab by default for now
> +CROND_DIR = $(PKG_LIB_DIR)/$(PKG_NAME)
> +endif

Wouldn't an else if arrangement make more sense?  Why would we install both?
I'd have expected "Install systemd if available, else install
crond if available, else don't install anything." 
... and then the cron job can stop checking for systemd too:

> diff --git a/scrub/xfs_scrub_all.cron.in b/scrub/xfs_scrub_all.cron.in
> new file mode 100644
> index 0000000..3dea929
> --- /dev/null
> +++ b/scrub/xfs_scrub_all.cron.in
> @@ -0,0 +1 @@
> +10 3 * * 0 root test -e /run/systemd/system || @sbindir@/xfs_scrub_all
> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in


unless I'm missing something?


Thanks,
-Eric
