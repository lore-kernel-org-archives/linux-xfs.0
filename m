Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C42CE7F57
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 20:31:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C0C6AC003
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 18:31:23 -0800 (PST)
Received: from boogeyman.armory.com
	(adsl-76-230-21-225.dsl.pltn13.sbcglobal.net [76.230.21.225])
	by cuda.sgi.com with ESMTP id 71fY36iwpGcOVMq0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 18:31:21 -0800 (PST)
Date: Tue, 26 Nov 2013 18:31:19 -0800
From: Phil White <cerise-xfs@l.armory.com>
Subject: Problem with mkfs.xfs on a regular file
Message-ID: <20131127023119.GB13101@boogeyman>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Gents:

I was making an image for a VM using everyone's favorite fs with a line
that looked something like this:
-------------
dd if=/dev/zero of=~/image bs=1024 count=1048576 && ./mkfs/mkfs.xfs && mount -o loop ~/image /mnt/loop
-------------


mkfs.xfs gave me this output:
-------------
meta-data=/root/image            isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
existing superblock read failed: Invalid argument
mkfs.xfs: pwrite64 failed: Invalid argument
mkfs.xfs: read failed: Invalid argument
-------------

And, of course, it failed to mount.

Knowing that this was using a possibly old version of xfsprogs (3.1.10, it
turned out), I grabbed the git tree and tried that.  The same problem occurred.

The "existing superblock read" problem was from mkfs/xfs_mkfs.c @ 806 in
zero_old_xfs_structures():
-------------
        if (pread(xi->dfd, buf, new_sb->sb_sectsize, 0) != new_sb->sb_sectsize) {
                fprintf(stderr, _("existing superblock read failed: %s\n"),
                        strerror(errno));
                free(buf);
                return;
        }
-------------

The pwrite64 problem was from libxfs/rdwr.c @ 806 in __write_buf():
-------------
        sts = pwrite64(fd, buf, len, offset);
        if (sts < 0) {
                int error = errno;
                fprintf(stderr, _("%s: pwrite64 failed: %s\n"),
                        progname, strerror(error));
                if (flags & LIBXFS_B_EXIT)
                        exit(1);
                return error;
        } else if (sts != len) {
                fprintf(stderr, _("%s: error - pwrite64 only %d of %d bytes\n"),
                        progname, sts, len);
                if (flags & LIBXFS_B_EXIT)
                        exit(1);
                return EIO;
        }
-------------

While it occurred to me that the problem might just be line 806 of some files
in xfsprogs, I threw it under a debugger and took a closer look.  The file
descriptor value in xi->dfd pointed at ~/image.  errno was set to 22.  I
thought that might indicate a problem with lseek(), so I rewrote the pwrite64()
and pread() as lseek()s and read()/write()

As you may have guessed, this did me no good at all.

It's trying to read/write 512 bytes at the beginning of the file which seems
reasonably innocuous.  I double checked the man page which says that under
2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.  sbp comes
out with 4096 in blocksize and 512 in sectsize when zero_old_xfs_structures()
is called and the first error comes up, so I'm at a loss for what's going wrong.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
