Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 15:57:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBGNuvjN029167
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 15:57:00 -0800
Message-ID: <4765BB55.5040906@sgi.com>
Date: Mon, 17 Dec 2007 10:57:09 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 974747 - PATCH: Cleanup various fid related bits
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Cleanup various fid related bits:

 - merge xfs_fid2 into it's only caller xfs_dm_inode_to_fh.
 - remove xfs_vget and opencode it in the two callers, simplifying
   both of them by avoiding the awkward calling convetion.
 - assign directly to the dm_fid_t members in various places in the
   dmapi code instead of casting them to xfs_fid_t first (which
   is identical to dm_fid_t)


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Dec 17 10:54:18 AEDT 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs-patch-reviews
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30258a
fs/xfs/xfs_vnodeops.c - 1.727 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.727&r2=text&tr2=1.726&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits

fs/xfs/xfs_vfsops.c - 1.549 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.549&r2=text&tr2=1.548&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits

fs/xfs/linux-2.6/xfs_ksyms.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits

fs/xfs/linux-2.6/xfs_export.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits

fs/xfs/dmapi/xfs_dm.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits

fs/xfs/xfs_vnodeops.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits

fs/xfs/xfs_vfsops.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
        - pv 974747, author Christoph Hellwig <hch@lst.de>, rv vapo - 
Cleanup various fid related bits
