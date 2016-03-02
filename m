Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C1687CB2
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 15:21:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6C9288F8033
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 13:21:33 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RlRMG7xbEcNlEZwt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 13:21:31 -0800 (PST)
Date: Wed, 2 Mar 2016 13:21:01 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160302212101.GF27973@birch.djwong.org>
References: <20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
	<20160301204013.GA23128@infradead.org>
	<20160302052411.GB1902@birch.djwong.org>
	<20160302095932.GA9141@infradead.org>
	<20160302164102.GA20109@birch.djwong.org>
	<20160302165704.GA31438@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302165704.GA31438@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 08:57:04AM -0800, Christoph Hellwig wrote:
> On Wed, Mar 02, 2016 at 08:41:02AM -0800, Darrick J. Wong wrote:
> > Hmm, I'll give it a spin when I get in later.  Can you send me xfs_info
> > output so I can try to construct an equivalent reproducer setup?
> 
> root@vm:~/xfstests# xfs_info /mnt/scratch/
> meta-data=/dev/vdc               isize=512    agcount=320, agsize=8192 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=1
> data     =                       bsize=4096   blocks=2621440, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok.  I think the problem is that making changes to the refcount btree eats
up our entire reservation in certain cases.  Can you try the following bandaid?
This should give us enough room to handle splitting the btree at both ends
of a range that we're refcount-changing.

Come to think of it, this might not be enough -- if we want to change the
refcount of an n-block extent, can we end up changing n/i_refc_mnr[0] blocks?
I suspect yes, but I'll think about that some more.

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index cfd8a3c..54c5c22 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -86,7 +86,7 @@ xfs_allocfree_log_count(
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);
+		blocks += 2 * num_ops * (2 * mp->m_refc_maxlevels - 1);
 	return blocks;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
