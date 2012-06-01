Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q513VOhU100305 for <xfs@oss.sgi.com>; Thu, 31 May 2012 22:31:24 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id TIIHRVEf5A9BytU4 for <xfs@oss.sgi.com>;
	Thu, 31 May 2012 20:31:22 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 0C8624963280
	for <xfs@oss.sgi.com>; Thu, 31 May 2012 22:31:22 -0500 (CDT)
Message-ID: <4FC83789.8010900@sandeen.net>
Date: Thu, 31 May 2012 22:31:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Printk for ENOSPC due to lack of inodes
References: <20120227003733.GA28162@Xye> <4F579D4C.4040208@sandeen.net>
	<20120531193616.GA3953@Xye.local>
In-Reply-To: <20120531193616.GA3953@Xye.local>
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
To: xfs@oss.sgi.com

On 5/31/12 2:36 PM, Raghavendra D Prabhu wrote:
> Hi,
> 
> Thanks for the review. I have now moved it inside xfs_dialloc. Along with adding the message, I noticed that the loop
> 
>     while (!agi->agi_freecount) {
>     }
> 
> is redundant when noroom=1 and okalloc=0.
> 
> Also, xfs_ialloc_ag_alloc function in the loop calls 
> ============
>     if (mp->m_maxicount &&
>         mp->m_sb.sb_icount + XFS_IALLOC_INODES(mp) > mp->m_maxicount) {
> 
> ===============
> 
> condition again.
> 
> So I have moved xfs_tran_brelse etc. into the condition along with message.
> 
> Is this logic valid? If it is, then I will look into rate-limiting the message etc.

It'd be easiest to understand this new change as a patch rather than as a description.

If you are changing logic or flow in addition to adding the messages, it should almost certainly be sent as more than one patch.

Thanks,

-eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
