Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 392337CB4
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 02:26:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C9818F8035
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 00:26:52 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 30V1PefkKG82xU1f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 00:26:47 -0800 (PST)
Date: Mon, 7 Mar 2016 00:26:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/12] block: test fallocate for block devices
Message-ID: <20160307082612.GE22185@birch.djwong.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305003837.28738.49794.stgit@birch.djwong.org>
	<20160305182508.GA25528@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305182508.GA25528@infradead.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Sat, Mar 05, 2016 at 10:25:08AM -0800, Christoph Hellwig wrote:
> I'm not sure xfstests is the right fit, as it does not test a file
> system, but rather block devices.

I asked Dave if he'd take a fallocate-for-bdevs test, and he didn't
object.  After all, we're testing a semi-standard FS API, just with
block devices.

> If people think it should go into xfstests we should at least not
> add it to the default group, but just to a new bdev group.

Sure, I don't mind changing the group to 'bdev' or something.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
