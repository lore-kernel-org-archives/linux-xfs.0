Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n451pBdu236381 for <xfs@oss.sgi.com>; Mon, 4 May 2009 20:51:11 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37C35147128E
	for <xfs@oss.sgi.com>; Mon,  4 May 2009 18:55:06 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id NC81LfIDsDCuNjcF for
	<xfs@oss.sgi.com>; Mon, 04 May 2009 18:55:06 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 05946AA60F5
	for <xfs@oss.sgi.com>; Mon,  4 May 2009 20:51:11 -0500 (CDT)
Message-ID: <49FF9B8E.7040607@sandeen.net>
Date: Mon, 04 May 2009 20:51:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: migration to selinux + xfs_fsr oddity....
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This came up in RH Bugzilla #498860, "xfs_fsr fails to complete"

The reporter had an existing xfs filesystem from another Linux OS, and
was using it under Fedora now.  He had some files for which xfs_fsr
bails out with EINVAL:

XFS_IOC_SWAPEXT failed: fragfile: Invalid argument

It's failing this check in xfs_swap_extents():

        /*
         * If the target has extended attributes, the tmp file
         * must also in order to ensure the correct data fork
         * format.
         */
        if ( XFS_IFORK_Q(ip) != XFS_IFORK_Q(tip) ) {
                error = XFS_ERROR(EINVAL);
                goto error0;
        }

because the original filesystem had no selinux xattrs, but the new/temp
file created during xfs_fsr got the selinux xattr, so failed this test.

It can be demonstrated like this on a machine w/ selinux:

# mkfs.xfs -dfile,name=fsfile,size=32m
# mkdir test
# mount -o loop,context="unconfined_u:object_r:user_tmp_t:s0" fsfile test
# for I in `seq 10 -1 0`; do  dd if=/dev/zero of=test/fragfile bs=4k count=1
seek=$I conv=notrunc oflag=sync; done
# umount test
# mount -o loop fsfile test
# xfs_fsr test/fragfile
XFS_IOC_SWAPEXT failed: fragfile: Invalid argument

I'm not sure if this is the sort of thing to maybe just caveat &
document, or try to work around ... somehow?  Maybe detect this case a
bit better and print something more helpful about what has gone wrong?

(As an aside ... looking at the above test and others related, and
thinking about a few random reports that xfs_fsr corrupted a file, I
can't help but think that maybe we are winding up with incompatible
formats for the original and donor inodes in some cases...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
