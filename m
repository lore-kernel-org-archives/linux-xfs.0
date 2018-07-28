Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48558 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388527AbeG1BiD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jul 2018 21:38:03 -0400
Subject: Re: [PATCH] xfs: add debian initramfs hook to package
References: <20180726215154.GI30972@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f2b317ec-3541-4441-cf11-58602eb8de4f@sandeen.net>
Date: Fri, 27 Jul 2018 17:13:42 -0700
MIME-Version: 1.0
In-Reply-To: <20180726215154.GI30972@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>



On 7/26/18 2:51 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In Debian bug 904086, the reporter complained that xfs_repair wasn't
> present in the initramfs, which prevented him from using shutdown -F to
> force a filesystem fsck after a reboot.  Add a hook to put the xfs
> utilities in the initramfs if xfs is the root filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debian/local/initramfs.hook |   47 +++++++++++++++++++++++++++++++++++++++++++
>  debian/rules                |    1 +
>  2 files changed, 48 insertions(+)
>  create mode 100644 debian/local/initramfs.hook
> 
> diff --git a/debian/local/initramfs.hook b/debian/local/initramfs.hook
> new file mode 100644
> index 00000000..20df5d69
> --- /dev/null
> +++ b/debian/local/initramfs.hook
> @@ -0,0 +1,47 @@
> +#!/bin/sh
> +
> +# Put XFS utilities in initramfs if the root fs is XFS.
> +
> +PREREQ=""
> +
> +prereqs()
> +{
> +	echo "$PREREQ"
> +}
> +
> +case $1 in
> +prereqs)
> +	prereqs
> +	exit 0
> +	;;
> +esac
> +
> +fstab_files()
> +{
> +	echo /etc/fstab
> +	if [ -d /etc/fstab.d ]; then
> +		ls -1 /etc/fstab.d | grep '\.fstab$' | sed -e 's;^;/etc/fstab.d/;'

Is this just a fancy 

ls -1 /etc/fstab.d/*.fstab 2>/dev/null

?  *shrug* ok :)

> +	fi
> +}
> +
> +rootfs_type() {
> +	fstab_files | while read file; do
> +		test ! -f "$file" && continue
> +
> +		while read MNT_FSNAME MNT_DIR MNT_TYPE MNT_OPTS MNT_FREQ MNT_PASS MNT_JUNK; do
> +			test "$MNT_DIR" != "/" && continue
> +			echo "$MNT_TYPE"
> +			break;
> +		done < "$file"
> +	done
> +}

ok, I was scheming up something, uh, more obtuse,

awk '$2 == "/" {print $3}' $(fstab_files)

but *shrug* :)

Actually... this sort of fstqab poses a problem for your function and mine:

#/dev/mapper/vg-lv_root /                      xfs    defaults        1 1
/dev/mapper/vg-lv_root /                       ext4    defaults        1 1

because it'll happily pick xfs.  Need to exclude comment lines, so exclude
MNT_FSNAME starting with # - 

test ${MNT_FSNAME::1} == "#" && continue

or in my fancy world could do:

awk '(!/^#/) && ($2 == "/") {print $3}' $(fstab_files)

tho I guess mine assumes only one matching line... | head -n 1 ;)


> +. /usr/share/initramfs-tools/scripts/functions
> +. /usr/share/initramfs-tools/hook-functions
> +
> +if [ "$(rootfs_type)" = "xfs" ]; then
> +	copy_exec /sbin/xfs_repair
> +	copy_exec /usr/sbin/xfs_db
> +	copy_exec /usr/sbin/xfs_metadump

Just to be sure, it gets fsck.xfs already?  or does it need to?

-Eric

> +fi
> +exit 0
> diff --git a/debian/rules b/debian/rules
> index cb4fa22c..4c50654c 100755
> --- a/debian/rules
> +++ b/debian/rules
> @@ -77,6 +77,7 @@ binary-arch: checkroot built
>  	$(pkgdev) $(MAKE) -C . install-dev
>  	$(pkgdi)  $(MAKE) -C debian install-d-i
>  	$(pkgme)  $(MAKE) dist
> +	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
>  	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
>  	rm -f debian/xfslibs-dev/lib/libhandle.la
>  	rm -fr debian/xfslibs-dev/usr/lib
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
