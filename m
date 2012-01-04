Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04Exp0m148267 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 08:59:51 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1vGvkBMKwlfebsBF for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 06:59:50 -0800 (PST)
Date: Wed, 4 Jan 2012 09:59:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] update 068 to reproduce an unfreeze hanging up problem
Message-ID: <20120104145944.GA21381@infradead.org>
References: <20111213094245.4004.61FB500B@jp.fujitsu.com>
	<20111213063212.GC14273@dastard>
	<20111214112209.1002.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111214112209.1002.61FB500B@jp.fujitsu.com>
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
To: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 11:22:10AM +0900, Masayoshi MIZUMA wrote:
> > test 068 will catch problems like the one your specific test
> > catches, but maybe not every time. Test 068 will catch problems your
> > test case won't, though - it's a trade-off between having lots of
> > tests that are similar but slightly different (difficult to
> > maintain, increases runtime, etc), and having one test that
> > exercises the functionality in a simple manner likely to detect
> > problems.
> 
> Thank you for your explanation about the policy and I understand it.


> I tried to reproduce the problem not dropping the sleep, but the problem was
> not reproduced... Therefore, I dropped it and the problem was reproduced.
> 
> However, as you mentioned, the problem is a timing proglem, so the
> my reproduction might be just by chance. Dropping sleep may increase
> the possibility of the reproduction, but not every time, so the change
> is not good. That is same for the arguments of fsstress which I changed.
> 
> OK, I update 068 just to run other filesystem, ext3, ext4 and btrfs which
> I confirmed xfs_freeze works on.
> (xfs_freeze may work on the other filesystems which have freeze_fs/unfreeze_fs
>  super_operations but I don't confirm...)
> 
> The patch is below.

Given that MIZUMAs patch reproduces a real life issue I think adding
his original patch in addition to this change would be a good idea.

Dave, do you have a strong opinion against that?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
