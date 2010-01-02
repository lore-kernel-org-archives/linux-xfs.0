Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o02CBJVE104855 for <xfs@oss.sgi.com>; Sat, 2 Jan 2010 06:11:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02C2715033D4
	for <xfs@oss.sgi.com>; Sat,  2 Jan 2010 04:12:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	jOkaNyTZUwj6FlgD for <xfs@oss.sgi.com>;
	Sat, 02 Jan 2010 04:12:07 -0800 (PST)
Date: Sat, 2 Jan 2010 23:12:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Kill filestreams cache flush
Message-ID: <20100102121203.GG13802@discord.disaster>
References: <1262399900-19110-1-git-send-email-david@fromorbit.com>
	<20100102115338.GA18502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100102115338.GA18502@infradead.org>
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
Cc: xfs@oss.sgi.com

On Sat, Jan 02, 2010 at 06:53:38AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 02, 2010 at 01:38:20PM +1100, Dave Chinner wrote:
> > The filestreams cache flush is not needed in the sync code as it
> > does not affect data writeback, and it is now not used by the
> > growfs code, either, so kill it.
> 
> I have to admit I never understood the purpose of this call.

I can't remember why it was put there, either. I may have even put
it there when I was getting filestreams ready for merge but I can't remember
at all...

> What xfs_fstrm_free_func does is:
> 
>  - clear the filesystems flag on the inode
>  - decrement pagf_fstrms
>  - drop references on the inode (and parent if known)
>  - free the filestream item
> 
> Nothing of that should matter for sync, although dropping inode
> references during sync might generally be a good idea.

Which means that sync destroys active filestreams associations and
that seems more broken to me than anything an active reference will
cause. I think just letting them time out is better than having them
destroyed by external operations. I'm happy to leave it there if you
want....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
