Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbdDKDZn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:25:43 -0400
Date: Tue, 11 Apr 2017 11:25:41 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH v3] repair: handle reading superblock from image on
 larger sector size filesystem
Message-ID: <20170411032541.GO21915@dhcp12-143.nay.redhat.com>
References: <1491480320-6511-1-git-send-email-zlang@redhat.com>
 <47d79267-118f-1b27-94e2-bbfcba98cd41@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47d79267-118f-1b27-94e2-bbfcba98cd41@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2017 at 12:16:41PM -0500, Eric Sandeen wrote:
> On 4/6/17 7:05 AM, Zorro Lang wrote:
> > Due to xfs_repair uses direct IO, sometimes it can't read superblock
> > from an image file has smaller sector size than host filesystem.
> > Especially that superblock doesn't align with host filesystem's
> > sector size.
> > 
> > Fortunately, xfsprogs already has code to do isa_file and geometry
> > check in xfs_repair.c, it turns off O_DIRECT after phase1() if the
> > sector size is less than the host filesystem's geometry. So move
> > the isa_file auto detection over up the phase1(), and try to do
> > once geometry check before phase1() if get_sb() return OK.
> 
> Zorro, can you do a quick test for me - does a filesystem which fails
> repair without this patch also fail xfs_copy if the source and/or
> destination of the copy is on this same filesystem/device as the image
> file in your xfs_repair test?

Sure, the xfs_copy has similar problem. I'm writting a xfstests case to
do xfs_repair and xfs_copy a file image likes this. Do you have any other
related suggestions which I can write them together?

About the xfs_copy, the test result likes below:
[root@ibm-x3850x5-03 test]# xfs_info .
meta-data=/dev/sdb               isize=512    agcount=4, agsize=960000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=3840000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@ibm-x3850x5-03 test]# mount -oloop 078.fs /mnt/tmp
[root@ibm-x3850x5-03 test]# xfs_info 078.fs
meta-data=/dev/sdb               isize=512    agcount=4, agsize=960000 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=3840000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[root@ibm-x3850x5-03 test]# umount /mnt/tmp
[root@ibm-x3850x5-03 test]# xfs_repair -f 078.fs
Phase 1 - find and verify superblock...
superblock read failed, offset 43014144, size 131072, ag 1, rval -1

fatal error -- Invalid argument
[root@ibm-x3850x5-03 test]# xfs_copy 078.fs 078.fs.bk
xfs_copy: read failed: Invalid argument
xfs_copy: read failed: Invalid argument
[root@ibm-x3850x5-03 test]# xfs_copy 078.fs /tmp
xfs_copy: read failed: Invalid argument
xfs_copy: read failed: Invalid argument
[root@ibm-x3850x5-03 test]# strace xfs_copy 078.fs 078.fs.img
...
...
open("078.fs", O_RDONLY|O_DIRECT)       = 5
fstat(5, {st_mode=S_IFREG|0600, st_size=688231424, ...}) = 0
fstat(5, {st_mode=S_IFREG|0600, st_size=688231424, ...}) = 0
ioctl(5, _IOC(_IOC_READ, 0x58, 0x1e, 0x0c), 0x7ffd28252c80) = 0
chdir("/mnt/test")                      = 0
pread64(5, "XFSB\0\0\4\0\0\0\0\0\0\nA`\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 32768, 0) = 32768
pread64(5, 0x74c000, 512, 0)            = -1 EINVAL (Invalid argument)
write(2, "xfs_copy: read failed: Invalid a"..., 40xfs_copy: read failed: Invalid argument
) = 40
pread64(5, 0x74d000, 512, 688225792)    = -1 EINVAL (Invalid argument)
write(2, "xfs_copy: read failed: Invalid a"..., 40xfs_copy: read failed: Invalid argument
) = 40
exit_group(1)                           = ?
+++ exited with 1 +++

> 
> Thanks,
> -Eric
> 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > V2 did a stupid change, it tried to check superblock before get_sb(). So
> > V3 fix this problem by below changes:
> > 
> > 1) move the "if (!isa_file)" auto detection over up the phase1().
> > 2) try to get_sb() before phase1, and check the sector size. Turn
> >    off the O_DIRECT if the sector size is smaller than the underlying
> >    filesystem.
> > 3) The step#2 maybe fail, due to can't get a valid primary superblock.
> >    So keep the similar steps after phase1(), I didn't remove it.
> > 
> > Thanks,
> > Zorro
> > 
> >  repair/xfs_repair.c | 96 ++++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 54 insertions(+), 42 deletions(-)
> > 
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index b07567b..9df5719 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -627,6 +627,42 @@ is_multidisk_filesystem(
> >  	return true;
> >  }
> >  
> > +/*
> > + * if the sector size of the filesystem we are trying to repair is
> > + * smaller than that of the underlying filesystem (i.e. we are repairing
> > + * an image), the we have to turn off direct IO because we cannot do IO
> > + * smaller than the host filesystem's sector size.
> > + */
> > +static void
> > +check_geometry_sectsize(
> > +	struct xfs_sb	*sb)
> > +{
> > +	int	fd;
> > +	long	old_flags;
> > +	struct xfs_fsop_geom_v1 geom = { 0 };
> > +
> > +	if (isa_file) {
> > +		fd = libxfs_device_to_fd(x.ddev);
> > +
> > +		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> > +			do_log(_("Cannot get host filesystem geometry.\n"
> > +		"Repair may fail if there is a sector size mismatch between\n"
> > +		"the image and the host filesystem.\n"));
> > +			geom.sectsize = BBSIZE;
> > +		}
> > +
> > +		if (sb->sb_sectsize < geom.sectsize) {
> > +			old_flags = fcntl(fd, F_GETFL, 0);
> > +			if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
> > +				do_warn(_(
> > +		"Sector size on host filesystem larger than image sector size.\n"
> > +		"Cannot turn off direct IO, so exiting.\n"));
> > +				exit(1);
> > +			}
> > +		}
> > +	}
> > +}
> > +
> >  int
> >  main(int argc, char **argv)
> >  {
> > @@ -657,6 +693,23 @@ main(int argc, char **argv)
> >  	timestamp(PHASE_START, 0, NULL);
> >  	timestamp(PHASE_END, 0, NULL);
> >  
> > +	/* -f forces this, but let's be nice and autodetect it, as well. */
> > +	if (!isa_file) {
> > +		int		fd = libxfs_device_to_fd(x.ddev);
> > +		struct stat	statbuf;
> > +
> > +		if (fstat(fd, &statbuf) < 0)
> > +			do_warn(_("%s: couldn't stat \"%s\"\n"),
> > +				progname, fs_name);
> > +		else if (S_ISREG(statbuf.st_mode))
> > +			isa_file = 1;
> > +	}
> > +
> > +	rval = get_sb(&psb, 0, XFS_MAX_SECTORSIZE, 0);
> > +	if (rval == XR_OK) {
> > +		check_geometry_sectsize(&psb);
> > +	}
> > +
> >  	/* do phase1 to make sure we have a superblock */
> >  	phase1(temp_mp);
> >  	timestamp(PHASE_END, 1, NULL);
> > @@ -674,48 +727,7 @@ main(int argc, char **argv)
> >  			  "Exiting now.\n"));
> >  		exit(1);
> >  	}
> > -
> > -	/* -f forces this, but let's be nice and autodetect it, as well. */
> > -	if (!isa_file) {
> > -		int		fd = libxfs_device_to_fd(x.ddev);
> > -		struct stat	statbuf;
> > -
> > -		if (fstat(fd, &statbuf) < 0)
> > -			do_warn(_("%s: couldn't stat \"%s\"\n"),
> > -				progname, fs_name);
> > -		else if (S_ISREG(statbuf.st_mode))
> > -			isa_file = 1;
> > -	}
> > -
> > -	/*
> > -	 * if the sector size of the filesystem we are trying to repair is
> > -	 * smaller than that of the underlying filesystem (i.e. we are repairing
> > -	 * an image), the we have to turn off direct IO because we cannot do IO
> > -	 * smaller than the host filesystem's sector size.
> > -	 */
> > -	if (isa_file) {
> > -		int     fd = libxfs_device_to_fd(x.ddev);
> > -		struct xfs_fsop_geom_v1 geom = { 0 };
> > -
> > -		if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> > -			do_log(_("Cannot get host filesystem geometry.\n"
> > -		"Repair may fail if there is a sector size mismatch between\n"
> > -		"the image and the host filesystem.\n"));
> > -			geom.sectsize = BBSIZE;
> > -		}
> > -
> > -		if (psb.sb_sectsize < geom.sectsize) {
> > -			long	old_flags;
> > -
> > -			old_flags = fcntl(fd, F_GETFL, 0);
> > -			if (fcntl(fd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
> > -				do_warn(_(
> > -		"Sector size on host filesystem larger than image sector size.\n"
> > -		"Cannot turn off direct IO, so exiting.\n"));
> > -				exit(1);
> > -			}
> > -		}
> > -	}
> > +	check_geometry_sectsize(&psb);
> >  
> >  	/*
> >  	 * Prepare the mount structure. Point the log reference to our local
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
