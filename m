Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NF1OsC010477 for <xfs@oss.sgi.com>; Sat, 23 May 2009 10:01:25 -0500
Received: from smtprelay08.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 253BD12FB5D4
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 08:07:09 -0700 (PDT)
Received: from smtprelay08.ispgateway.de (smtprelay08.ispgateway.de
	[80.67.31.42]) by cuda.sgi.com with ESMTP id SrFd8Ievhhqpbc0T
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 08:07:09 -0700 (PDT)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay08.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <Richard.Ems@cape-horn-eng.com>)
	id 1M7sj8-0003b9-6k
	for xfs@oss.sgi.com; Sat, 23 May 2009 17:01:34 +0200
Message-ID: <4A180FCD.9080905@cape-horn-eng.com>
Date: Sat, 23 May 2009 17:01:33 +0200
From: Richard Ems <Richard.Ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi list,

I'm getting the error "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
Invalid argument" while trying to grow an XFS partition.

This is on openSUSE 11.1 64 bit, with xfsprogs-2.10.2-3.1 from
http://download.opensuse.org/repositories/filesystems/openSUSE_11.1/x86_64/=
xfsprogs-2.10.2-3.1.x86_64.rpm
.

This error is the same or looks similar to the one reported some months
ago at http://oss.sgi.com/archives/xfs/2009-02/msg00028.html .

There is apparently a fix for it, see
http://oss.sgi.com/archives/xfs/2008-12/msg01794.html :

*********************************************************
commit 471d59103167c84f17b9bcfee22ed10b44ff206e
Author: sandeen@xxxxxxxxxxx <sandeen@xxxxxxxxxxx>
Date:   Tue Nov 25 21:20:10 2008 -0600

    [XFS] Add compat handlers for data & rt growfs ioctls

    The args for XFS_IOC_FSGROWFSDATA and XFS_IOC_FSGROWFSRTA
    have padding on the end on intel, so add arg copyin functions,
    and then just call the growfs ioctl helpers.

    Signed-off-by: Eric Sandeen <sandeen@xxxxxxxxxxx>
    Reviewed-by: Christoph Hellwig <hch@xxxxxx>
    Signed-off-by: Lachlan McIlroy <lachlan@xxxxxxx>
*********************************************************

I tried different 2.6.27 versions, one 2.6.29 and one 2.6.30-rc6
version, all gave the same error, check
https://bugzilla.novell.com/show_bug.cgi?id=3D506361 for the different
kernel versions and errors.

Is this fix still not included in Linus / openSUSE trees?

Or am I hitting another error?

Thanks, Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
