Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5SFxrT8041364 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 10:59:53 -0500
Date: Thu, 28 Jun 2012 11:01:56 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: cleanup the mount options
Message-ID: <20120628160156.GC29979@sgi.com>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120627174448.GA3278@infradead.org>
	<4FEBAB3B.6020707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FEBAB3B.6020707@cn.fujitsu.com>
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
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hey Wanlong,

On Thu, Jun 28, 2012 at 08:54:19AM +0800, Wanlong Gao wrote:
> On 06/28/2012 01:44 AM, Christoph Hellwig wrote:
> > On Thu, Jun 28, 2012 at 12:57:23AM +0800, Wanlong Gao wrote:
> >> remove the mount options macro, use tokens instead.
> >> Futher cleanup will use xfs_*_opt in xfs instead,
> >> but it may be hard to be merged in one patch.
> > 
> > Thanks a lot!
> > 
> > I like the use of the option parse a lot, this has been long overdue.
> > 
> > But is there any good reason to add the xfs_*_opt macros?  They make
> > reading and especially grepping the code a lot harder, so there better
> > be a good reason for them.
> 
> I think that using the macro makes code more clearly, and it's more
> convenient to use the macro than the original "|=", "&=" and "&" things.
> And, no more harder for reading and grepping, just omit the "XFS_MOUNT_".

Granted.  It's not hard to omit 'XFS_MOUNT_'.  The difficulty is that when you
omit XFS_MOUNT_ in your grep, you may get many more unrelated hits from other
contexts to sift through.  Maybe that's what Christoph was getting at.

> BTW, these macros were borrowed from Btrfs. I myself like it, but if
> you XFS guys all do not like, I can drop it.

It's not a strong objection from me, but I do have a preference for keeping the
XFS_MOUNT_ prefix to retain context for cscope and grep.  Maybe others feel
differently.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
