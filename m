Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0Q48lkt098671 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 22:08:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 709211360387
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 20:09:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	DeFCwDEdpDf1FffW for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2010 20:09:49 -0800 (PST)
Date: Tue, 26 Jan 2010 15:09:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't hold onto reserved blocks on remount,ro
Message-ID: <20100126040945.GA15853@discord.disaster>
References: <1264397572-18230-1-git-send-email-david@fromorbit.com>
	<20100125114433.GA8595@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125114433.GA8595@infradead.org>
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

On Mon, Jan 25, 2010 at 06:44:33AM -0500, Christoph Hellwig wrote:
> On Mon, Jan 25, 2010 at 04:32:52PM +1100, Dave Chinner wrote:
> > If we hold onto reserved blocks when doing a remount,ro we end
> > up writing the blocks used count to disk that includes the reserved
> > blocks. Reserved blocks are not actually used, so this results in
> > the values in the superblock being incorrect.
> > 
> > Hence if we run xfs_check or xfs_repair -n while the filesystem is
> > mounted remount,ro we end up with an inconsistent filesystem being
> > reported. Also, running xfs_copy on the remount,ro filesystem will
> > result in an inconsistent image being generated.
> > 
> > To fix this, unreserve the blocks when doing the remount,ro, and
> > reserved them again on remount,rw. This way a remount,ro filesystem
> > will appear consistent on disk to all utilities.
> 
> Looks good to me, the only thing that was rather confusing when trying
> to read the patch is the m_resblks_ro field in struct xfs_mount, it's
> more a m_resblks_save, as in the saved value before we modified the
> block count during remount,ro.

Ok, I changed the variable name.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
