Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E94027CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 10:57:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A97D58F8039
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 08:57:06 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id LzJIMQCKsyMPa7sN (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 08:57:04 -0800 (PST)
Date: Wed, 2 Mar 2016 08:57:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block allocations for the refcount btree
Message-ID: <20160302165704.GA31438@infradead.org>
References: <20160210093011.GA19147@infradead.org>
	<20160210095010.GC23904@birch.djwong.org>
	<20160210190738.GA13051@infradead.org>
	<20160210214058.GN14668@dastard>
	<20160212191046.GA28421@infradead.org>
	<20160301181809.GC27973@birch.djwong.org>
	<20160301204013.GA23128@infradead.org>
	<20160302052411.GB1902@birch.djwong.org>
	<20160302095932.GA9141@infradead.org>
	<20160302164102.GA20109@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160302164102.GA20109@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Mar 02, 2016 at 08:41:02AM -0800, Darrick J. Wong wrote:
> Hmm, I'll give it a spin when I get in later.  Can you send me xfs_info
> output so I can try to construct an equivalent reproducer setup?

root@vm:~/xfstests# xfs_info /mnt/scratch/
meta-data=/dev/vdc               isize=512    agcount=320, agsize=8192 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
