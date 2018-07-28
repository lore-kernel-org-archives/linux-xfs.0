Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40194 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbeG1JJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jul 2018 05:09:46 -0400
Date: Sat, 28 Jul 2018 00:44:06 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: add debian initramfs hook to package
Message-ID: <20180728074406.GQ30972@magnolia>
References: <20180726215154.GI30972@magnolia>
 <f2b317ec-3541-4441-cf11-58602eb8de4f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b317ec-3541-4441-cf11-58602eb8de4f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Fri, Jul 27, 2018 at 05:13:42PM -0700, Eric Sandeen wrote:
> 
> 
> On 7/26/18 2:51 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In Debian bug 904086, the reporter complained that xfs_repair wasn't
> > present in the initramfs, which prevented him from using shutdown -F to
> > force a filesystem fsck after a reboot.  Add a hook to put the xfs
> > utilities in the initramfs if xfs is the root filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  debian/local/initramfs.hook |   47 +++++++++++++++++++++++++++++++++++++++++++
> >  debian/rules                |    1 +
> >  2 files changed, 48 insertions(+)
> >  create mode 100644 debian/local/initramfs.hook
> > 
> > diff --git a/debian/local/initramfs.hook b/debian/local/initramfs.hook
> > new file mode 100644
> > index 00000000..20df5d69
> > --- /dev/null
> > +++ b/debian/local/initramfs.hook
> > @@ -0,0 +1,47 @@
> > +#!/bin/sh
> > +
> > +# Put XFS utilities in initramfs if the root fs is XFS.
> > +
> > +PREREQ=""
> > +
> > +prereqs()
> > +{
> > +	echo "$PREREQ"
> > +}
> > +
> > +case $1 in
> > +prereqs)
> > +	prereqs
> > +	exit 0
> > +	;;
> > +esac
> > +
> > +fstab_files()
> > +{
> > +	echo /etc/fstab
> > +	if [ -d /etc/fstab.d ]; then
> > +		ls -1 /etc/fstab.d | grep '\.fstab$' | sed -e 's;^;/etc/fstab.d/;'
> 
> Is this just a fancy 
> 
> ls -1 /etc/fstab.d/*.fstab 2>/dev/null
> 
> ?  *shrug* ok :)

Yeah, it's ... bizarre, but it matches the debian initramfs scripts for
shoving fsck and fsck.$FSTYP into the initramfs.

> > +	fi
> > +}
> > +
> > +rootfs_type() {
> > +	fstab_files | while read file; do
> > +		test ! -f "$file" && continue
> > +
> > +		while read MNT_FSNAME MNT_DIR MNT_TYPE MNT_OPTS MNT_FREQ MNT_PASS MNT_JUNK; do
> > +			test "$MNT_DIR" != "/" && continue
> > +			echo "$MNT_TYPE"
> > +			break;
> > +		done < "$file"
> > +	done
> > +}
> 
> ok, I was scheming up something, uh, more obtuse,
> 
> awk '$2 == "/" {print $3}' $(fstab_files)
> 
> but *shrug* :)

Yeah, that fugly mess is also cribbed from the Debian initramfs scripts.

> Actually... this sort of fstqab poses a problem for your function and mine:
> 
> #/dev/mapper/vg-lv_root /                      xfs    defaults        1 1
> /dev/mapper/vg-lv_root /                       ext4    defaults        1 1
> 
> because it'll happily pick xfs.  Need to exclude comment lines, so exclude
> MNT_FSNAME starting with # - 
> 
> test ${MNT_FSNAME::1} == "#" && continue
> 
> or in my fancy world could do:
> 
> awk '(!/^#/) && ($2 == "/") {print $3}' $(fstab_files)
> 
> tho I guess mine assumes only one matching line... | head -n 1 ;)

Might have to add awk as a Depends: dependency in debian/control if you
do that.  I think it's cleaner....

> 
> > +. /usr/share/initramfs-tools/scripts/functions
> > +. /usr/share/initramfs-tools/hook-functions
> > +
> > +if [ "$(rootfs_type)" = "xfs" ]; then
> > +	copy_exec /sbin/xfs_repair
> > +	copy_exec /usr/sbin/xfs_db
> > +	copy_exec /usr/sbin/xfs_metadump
> 
> Just to be sure, it gets fsck.xfs already?  or does it need to?

fsck.xfs will be put in the initramfs by
/usr/share/initramfs-tools/hooks/fsck if /etc/fstab says the rootfs is
pass 1 or greater.  I find it weird that the bug reporter has pass == 0
and complains that xfs_repair isn't present even though neither fsck nor
fsck.xfs are in his initramfs either!

Buuuut, it would be nice to have the xfs tools show up in the initramfs
in case the rootfs is corrupt and the admin boots with 'break=premount'
to get a shell to fix the root fs.

--D

> -Eric
> 
> > +fi
> > +exit 0
> > diff --git a/debian/rules b/debian/rules
> > index cb4fa22c..4c50654c 100755
> > --- a/debian/rules
> > +++ b/debian/rules
> > @@ -77,6 +77,7 @@ binary-arch: checkroot built
> >  	$(pkgdev) $(MAKE) -C . install-dev
> >  	$(pkgdi)  $(MAKE) -C debian install-d-i
> >  	$(pkgme)  $(MAKE) dist
> > +	install -D -m 0755 debian/local/initramfs.hook debian/xfsprogs/usr/share/initramfs-tools/hooks/xfs
> >  	rmdir debian/xfslibs-dev/usr/share/doc/xfsprogs
> >  	rm -f debian/xfslibs-dev/lib/libhandle.la
> >  	rm -fr debian/xfslibs-dev/usr/lib
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
