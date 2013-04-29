Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2A64D7F37
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 06:44:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5717AC005
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 04:44:27 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ttN5Tpi7ZF3TtmoA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Apr 2013 04:44:26 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r3TBiODL003057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 11:44:25 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r3TBiOCb015861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 11:44:24 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r3TBiNLL000685 for <xfs@oss.sgi.com>; Mon, 29 Apr 2013 11:44:23 GMT
Message-ID: <517E5D12.5010809@oracle.com>
Date: Mon, 29 Apr 2013 19:44:18 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Don't keep silent if sunit/swidth can not be changed
	via mount
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

As per the mount man page, sunit and swidth can be changed via
mount options.  For XFS, on the face of it, those options seems
works if the specified alignments is properly, e.g.
# mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
# mount | grep sdb1
/dev/sdb1 on /mnt type xfs (rw,sunit=4096,swidth=8192)

However, neither sunit nor swidth is shown from the xfs_info output.
# xfs_info /mnt
meta-data=/dev/sdb1    isize=256    agcount=4, agsize=262144 blks
         =             sectsz=512   attr=2
data     =             bsize=4096   blocks=1048576, imaxpct=25
         =             sunit=0      swidth=0 blks
		       ^^^^^^^^^^^^^^^^^^^^^^^^^^
naming   =version 2    bsize=4096   ascii-ci=0
log      =internal     bsize=4096   blocks=2560, version=2
         =             sectsz=512   sunit=0 blks, lazy-count=1
realtime =none         extsz=4096   blocks=0, rtextents=0

The reason is that the alignment can only be changed if the relevant
super block is already configured with alignments, otherwise, the
given value will be silently ignored, so it's better to tell user
that the alignment-changing can not take affect in one way or another.

With this fix, the attempt to mount a storage without strip alignment
setup on super block will failed if XFS_MOUNT_RETERR is enabled, or
just ignore the given alignment and drop a warning to indicate the
cause in syslog.

# mount -o sunit=4096,swidth=8192 /dev/sdb1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg|tail
.......
XFS (sdb1): can not change alignment: no data alignment on superblock

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_mount.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3806088..bc7fdd4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -924,6 +924,13 @@ xfs_update_alignment(xfs_mount_t *mp)
 				sbp->sb_width = mp->m_swidth;
 				mp->m_update_flags |= XFS_SB_WIDTH;
 			}
+		} else {
+			xfs_warn(mp, "can not change alignment: "
+				"no data alignment on superblock");
+			if (mp->m_flags & XFS_MOUNT_RETERR)
+				return XFS_ERROR(EINVAL);
+			mp->m_dalign = 0;
+			mp->m_swidth = 0;
 		}
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
