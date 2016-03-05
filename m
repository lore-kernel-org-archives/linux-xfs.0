Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C1C777CA2
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 14:20:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51675AC001
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 12:20:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YukahjuN0avk6Vzr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 05 Mar 2016 12:20:51 -0800 (PST)
Date: Sat, 5 Mar 2016 12:20:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/12] xfs/030: fix output on newer filesystems
Message-ID: <20160305202050.GF10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305003756.28738.26362.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305003756.28738.26362.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Still fails for me:

--- tests/xfs/030.out	2016-03-03 07:55:58.556427678 +0000
+++ /root/xfstests/results//xfs/030.out.bad	2016-03-05 20:20:17.561433837 +0000
@@ -231,8 +231,6 @@
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
 bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
         - found root inode chunk
 Phase 3 - for each AG...
         - scan and clear agi unlinked lists...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
