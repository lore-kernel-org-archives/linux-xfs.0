Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5S0sMBX251816 for <xfs@oss.sgi.com>; Wed, 27 Jun 2012 19:54:24 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id oXrw9P7WmGsSIyfn for
	<xfs@oss.sgi.com>; Wed, 27 Jun 2012 17:54:20 -0700 (PDT)
Message-ID: <4FEBAB3B.6020707@cn.fujitsu.com>
Date: Thu, 28 Jun 2012 08:54:19 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: cleanup the mount options
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120627174448.GA3278@infradead.org>
In-Reply-To: <20120627174448.GA3278@infradead.org>
Reply-To: gaowanlong@cn.fujitsu.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 06/28/2012 01:44 AM, Christoph Hellwig wrote:
> On Thu, Jun 28, 2012 at 12:57:23AM +0800, Wanlong Gao wrote:
>> remove the mount options macro, use tokens instead.
>> Futher cleanup will use xfs_*_opt in xfs instead,
>> but it may be hard to be merged in one patch.
> 
> Thanks a lot!
> 
> I like the use of the option parse a lot, this has been long overdue.
> 
> But is there any good reason to add the xfs_*_opt macros?  They make
> reading and especially grepping the code a lot harder, so there better
> be a good reason for them.

I think that using the macro makes code more clearly, and it's more
convenient to use the macro than the original "|=", "&=" and "&" things.
And, no more harder for reading and grepping, just omit the "XFS_MOUNT_".

BTW, these macros were borrowed from Btrfs. I myself like it, but if
you XFS guys all do not like, I can drop it.

Thanks,
Wanlong Gao

> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
