Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43236 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbeLEEsb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 23:48:31 -0500
Subject: Re: [PATCH] xfsdump: don't fail installation if /sbin is symlink of
 /usr/sbin
References: <20181101104732.19322-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1a662234-f71a-7208-76f9-9f2f89aa8255@sandeen.net>
Date: Tue, 4 Dec 2018 22:48:30 -0600
MIME-Version: 1.0
In-Reply-To: <20181101104732.19322-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 11/1/18 5:47 AM, Jan Tulak wrote:
> Some distributions, like Fedora, have /bin and /sbin as symlinks
> pointing to /usr/* and this patch adds compatibility for these cases.

xfsdump builds fine on Fedora, but only because somebody (me) was
bad long long ago, in the spec file:

# Bit of a hack to move files from /sbin to /usr/sbin
(cd $RPM_BUILD_ROOT/%{_sbindir}; rm xfsdump xfsrestore)
(cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsdump .)
(cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsrestore .)

I ... don't know why that was done.  Seems like dump/restore /should/
just live in /sbin, no?  I'm not sure what the symlink is/was for
in the first place...

but I guess Debian does package it up that way:

# dpkg-query -L xfsdump | grep xfsrestore | xargs ls -l
-rwxr-xr-x 1 root root 246088 Aug  1  2014 /sbin/xfsrestore
lrwxrwxrwx 1 root root     16 Aug  1  2014 /usr/sbin/xfsrestore -> /sbin/xfsrestore

so, um, I guess this seems ok to handle the /sbin == /usr/sbin case.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  dump/Makefile    | 4 +++-
>  restore/Makefile | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/dump/Makefile b/dump/Makefile
> index 97879fa..66f00d3 100644
> --- a/dump/Makefile
> +++ b/dump/Makefile
> @@ -100,7 +100,9 @@ install: default
>  	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
>  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> -	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
> +	# skip symlink when /sbin is alread symlinked to /usr/sbin, like on Fedora
> +	test $(PKG_ROOT_SBIN_DIR) -ef $(PKG_SBIN_DIR) || \
> +		$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
>  install-dev:
>  
>  .dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
> diff --git a/restore/Makefile b/restore/Makefile
> index c6f3f25..20c870a 100644
> --- a/restore/Makefile
> +++ b/restore/Makefile
> @@ -110,7 +110,9 @@ install: default
>  	$(INSTALL) -m 755 -d $(PKG_ROOT_SBIN_DIR)
>  	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_ROOT_SBIN_DIR)
>  	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
> -	$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
> +	# skip symlink when /sbin is alread symlinked to /usr/sbin, like on Fedora
> +	test $(PKG_ROOT_SBIN_DIR) -ef $(PKG_SBIN_DIR) || \
> +		$(INSTALL) -S $(PKG_ROOT_SBIN_DIR)/$(LTCOMMAND) $(PKG_SBIN_DIR)/$(LTCOMMAND)
>  install-dev:
>  
>  .dep: $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
> 
