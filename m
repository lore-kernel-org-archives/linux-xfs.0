Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE7907CAA
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 13:19:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B4BFAC002
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 11:18:59 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Ir5CCVrsmk6RU1Zg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2016 11:18:53 -0800 (PST)
Date: Wed, 10 Feb 2016 11:18:48 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [LFS/MM TOPIC] fs reflink issues, fs online scrub/check, etc
Message-ID: <20160210191848.GC6346@birch.djwong.org>
References: <20160210191715.GB6339@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210191715.GB6339@birch.djwong.org>
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
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs <xfs@oss.sgi.com>

[resend, email exploded, sorry...]

Hi,

I want to discuss a few FS related topics that I haven't already seen on
the mailing lists:

 * Shared pagecache pages for reflinked files (and by extension making dax
   work with reflink on xfs)

 * Providing a simple interface for scrubbing filesystem metadata in the
   background (the online check thing).  Ideally we'd make it easy to discover
   what kind of metadata there is to check and provide a simple interface to
   check the metadata, once discovered.  This is a tricky interface topic
   since FS design differs pretty widely.

 * Rudimentary online repair and rebuilding (xfs) from secondary metadata

 * Working out the variances in the btrfs/xfs/ocfs2/nfs reflink implementations
   and making sure they all get test coverage

I would also like participate in some of the proposed discussions:

 * The ext4 summit (and whatever meeting of XFS devs may happen)

 * Integrating existing filesystems into pmem, or hallway bofs about designing
   new filesystems for pmem

 * Actually seeing the fs developers (well, everyone!) in person again :)

--Darrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
