Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CBA137CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 02:05:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8EEB78F8037
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 00:05:30 -0700 (PDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
	by cuda.sgi.com with ESMTP id AjesLioXLYfwrz3S (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 00:05:27 -0700 (PDT)
Subject: Re: [PATCH] xfs: simplify the calculation of tpp at xfs_bmdr_to_bmbt
References: <1466746760-155962-1-git-send-email-houtao1@huawei.com>
	<20160624063805.GD12670@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <576CDAE4.2040202@huawei.com>
Date: Fri, 24 Jun 2016 15:01:56 +0800
MIME-Version: 1.0
In-Reply-To: <20160624063805.GD12670@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: miaoxie@huawei.com, fangwei1@huawei.com, xfs@oss.sgi.com



On 2016/6/24 14:38, Dave Chinner wrote:
> On Fri, Jun 24, 2016 at 01:39:20PM +0800, Hou Tao wrote:
>> remove the usage of rblocklen at xfs_bmdr_to_bmbt, and
>> use be16_to_cpu(dblock->bb_numrecs) instead. It also
>> reduces an extra calculation.
> 
> What problem does this fix, why does it need to be made and
> how did you test it?
It fixes nothing, just for simplification of code understanding.
And now I realize keeping the original code untouched is better,
because using rblocklen to calculate the offset of xfs_bmbt_ptr_t
is common among the btree code, so keeping it consistent.

> We have to be really careful about changing code that interacts with
> the on-disk format, as any bugs we introduced will result in
> filesystem corruption.  Hence you need to explain to the reviewers
> why the change needs to be made to the reviewers...
I will take care, Thanks.

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
