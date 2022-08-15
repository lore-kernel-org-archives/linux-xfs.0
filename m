Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24051C25B0E
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Aug 2022 09:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbiHOJm6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Aug 2022 05:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiHOJm5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Aug 2022 05:42:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E70381CB3A
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 02:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660556575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wD7uXfxEAZaYnpIAi/OCpwE477Qq7e7myktWuGmAh0c=;
        b=in7ghO9VoL7CWuw8T8ZSBqsD2gtvHOghsKwqr2yiW1KoXr/pTFdfOIB93TmYfzAZ24XIvI
        LfTSgTFR1tTkZHqr5DwhIhgUlniqQ5E+PVSS7JpkUkNqhwfjq+URiLNLSJas0ANOuBfD5Y
        wi7WJS/snfLYIa5hi1SgfCDuReVge3o=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-73-KGCHD4uvNmKdkIWwhKcHvQ-1; Mon, 15 Aug 2022 05:42:53 -0400
X-MC-Unique: KGCHD4uvNmKdkIWwhKcHvQ-1
Received: by mail-qk1-f198.google.com with SMTP id i15-20020a05620a404f00b006b55998179bso6526106qko.4
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 02:42:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wD7uXfxEAZaYnpIAi/OCpwE477Qq7e7myktWuGmAh0c=;
        b=YBoNl4z8GZMun7FFQqcJpmW00Gx+mNTneNrMza80IYC4OT5F4xoB7c2p80PF+NzVNB
         M3lAXiGNTR0R6Ec7NK2wNoIS9wyMnZct+8vVzLyL/zciKqy01dr+nxb2YQv9YPJI7FJP
         BarsXGhlNrN4yWHWHJxKRI+auLIq47aiisBhbMO3lNO7qzoVDO3uKQgR7VR0eGqHyiRl
         kc40LsaWB4Lcn0966NCItvft9CxJdIX0RyXN/84Rcp2VSr01TGrPja+ttnGKBXmofkHW
         hcLFN2Rl7awLBFScMq6LeFEfW0NTOhDxUvrIFLYVf7cVPp9DG6OH3gPNsoNd7G1nDFsn
         xFog==
X-Gm-Message-State: ACgBeo1JI/Uk1KmXZJvbF3X6p189xWZ27ESBXBwY/XNZtzZj22lZN6NX
        E+X+bQmYoF3axCb8zxkaHqAhWzlGj4Xqi30u3RcjVoZ+oKbT+1s0OhW55tjpGORUiqvNuDLtJVM
        PyNUGqfANlDVz0bGZzprp
X-Received: by 2002:a37:bb05:0:b0:6b9:629e:f46b with SMTP id l5-20020a37bb05000000b006b9629ef46bmr817258qkf.521.1660556572790;
        Mon, 15 Aug 2022 02:42:52 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6jZ/ipfqjSf++weXOKG90EWZOsfAK7/XOngbLXBfXsUj3YKX3JhhCBsbFcL8J+0m6YJ61klg==
X-Received: by 2002:a37:bb05:0:b0:6b9:629e:f46b with SMTP id l5-20020a37bb05000000b006b9629ef46bmr817242qkf.521.1660556572471;
        Mon, 15 Aug 2022 02:42:52 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x16-20020a05620a259000b006b9a89d408csm8457916qko.100.2022.08.15.02.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 02:42:52 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:42:46 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] common: disable infinite IO error retry for EIO
 shutdown tests
Message-ID: <20220815094246.iqrbfdkwzvrjbjb3@zlang-mailbox>
References: <165950054404.199222.5615656337332007333.stgit@magnolia>
 <165950055523.199222.9175019533516343488.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950055523.199222.9175019533516343488.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 02, 2022 at 09:22:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This patch fixes a rather hard to hit livelock in the tests that test
> how xfs handles shutdown behavior when the device suddenly dies and
> starts returing EIO all the time.  The livelock happens if the AIL is
> stuck retrying failed metadata updates forever, the log itself is not
> being written, and there is no more log grant space, which prevents the
> frontend from shutting down the log due to EIO errors during
> transactions.
> 
> While most users probably want the default retry-forever behavior
> because EIO can be transient, the circumstances are different here.  The
> tests are designed to flip the device back to working status only after
> the unmount succeeds, so we know there's no point in the filesystem
> retrying writes until after the unmount.
> 
> This fixes some of the periodic hangs in generic/019 and generic/475.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/dmerror           |    4 ++++
>  common/fail_make_request |    1 +
>  common/rc                |   31 +++++++++++++++++++++++++++----
>  common/xfs               |   29 +++++++++++++++++++++++++++++
>  4 files changed, 61 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/common/dmerror b/common/dmerror
> index 0934d220..54122b12 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -138,6 +138,10 @@ _dmerror_load_error_table()
>  		suspend_opt="$*"
>  	fi
>  
> +	# If the full environment is set up, configure ourselves for shutdown
> +	type _prepare_for_eio_shutdown &>/dev/null && \

I'm wondering why we need to check if _prepare_for_eio_shutdown() is defined
at here? This patch define this function, so if we merge this patch, this
function is exist, right?

> +		_prepare_for_eio_shutdown $DMERROR_DEV

Hmm... what about someone load error table, but not for testing fs shutdown?

> +
>  	# Suspend the scratch device before the log and realtime devices so
>  	# that the kernel can freeze and flush the filesystem if the caller
>  	# wanted a freeze.
> diff --git a/common/fail_make_request b/common/fail_make_request
> index 9f8ea500..b5370ba6 100644
> --- a/common/fail_make_request
> +++ b/common/fail_make_request
> @@ -44,6 +44,7 @@ _start_fail_scratch_dev()
>  {
>      echo "Force SCRATCH_DEV device failure"
>  
> +    _prepare_for_eio_shutdown $SCRATCH_DEV
>      _bdev_fail_make_request $SCRATCH_DEV 1
>      [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
>          _bdev_fail_make_request $SCRATCH_LOGDEV 1
> diff --git a/common/rc b/common/rc
> index 63bafb4b..119cc477 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4205,6 +4205,20 @@ _check_dmesg()
>  	fi
>  }
>  
> +# Make whatever configuration changes we need ahead of testing fs shutdowns due
> +# to unexpected IO errors while updating metadata.  The sole parameter should
> +# be the fs device, e.g.  $SCRATCH_DEV.
> +_prepare_for_eio_shutdown()
> +{
> +	local dev="$1"
> +
> +	case "$FSTYP" in
> +	"xfs")
> +		_xfs_prepare_for_eio_shutdown "$dev"
> +		;;
> +	esac
> +}
> +
>  # capture the kmemleak report
>  _capture_kmemleak()
>  {
> @@ -4467,7 +4481,7 @@ run_fsx()
>  #
>  # Usage example:
>  #   _require_fs_sysfs error/fail_at_unmount
> -_require_fs_sysfs()
> +_has_fs_sysfs()
>  {
>  	local attr=$1
>  	local dname
> @@ -4483,9 +4497,18 @@ _require_fs_sysfs()
>  		_fail "Usage: _require_fs_sysfs <sysfs_attr_path>"
>  	fi
>  
> -	if [ ! -e /sys/fs/${FSTYP}/${dname}/${attr} ];then
> -		_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
> -	fi
> +	test -e /sys/fs/${FSTYP}/${dname}/${attr}
> +}
> +
> +# Require the existence of a sysfs entry at /sys/fs/$FSTYP/DEV/$ATTR
> +_require_fs_sysfs()
> +{
> +	_has_fs_sysfs "$@" && return
> +
> +	local attr=$1
> +	local dname=$(_short_dev $TEST_DEV)
> +
> +	_notrun "This test requires /sys/fs/${FSTYP}/${dname}/${attr}"
>  }
>  
>  _require_statx()
> diff --git a/common/xfs b/common/xfs
> index 92c281c6..65234c8b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -823,6 +823,35 @@ _scratch_xfs_unmount_dirty()
>  	_scratch_unmount
>  }
>  
> +# Prepare a mounted filesystem for an IO error shutdown test by disabling retry
> +# for metadata writes.  This prevents a (rare) log livelock when:
> +#
> +# - The log has given out all available grant space, preventing any new
> +#   writers from tripping over IO errors (and shutting down the fs/log),
> +# - All log buffers were written to disk, and
> +# - The log tail is pinned because the AIL keeps hitting EIO trying to write
> +#   committed changes back into the filesystem.
> +#
> +# Real users might want the default behavior of the AIL retrying writes forever
> +# but for testing purposes we don't want to wait.
> +#
> +# The sole parameter should be the filesystem data device, e.g. $SCRATCH_DEV.
> +_xfs_prepare_for_eio_shutdown()
> +{
> +	local dev="$1"
> +	local ctlfile="error/fail_at_unmount"
> +
> +	# Don't retry any writes during the (presumably) post-shutdown unmount
> +	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1
> +
> +	# Disable retry of metadata writes that fail with EIO
> +	for ctl in max_retries retry_timeout_seconds; do
> +		ctlfile="error/metadata/EIO/$ctl"
> +
> +		_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 0
> +	done
> +}
> +
>  # Skip if we are running an older binary without the stricter input checks.
>  # Make multiple checks to be sure that there is no regression on the one
>  # selected feature check, which would skew the result.
> 

