Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o281FTxP248541 for <xfs@oss.sgi.com>; Sun, 7 Mar 2010 19:15:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E749022228C
	for <xfs@oss.sgi.com>; Sun,  7 Mar 2010 17:16:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	pEuUg7bdnWq4RfbI for <xfs@oss.sgi.com>;
	Sun, 07 Mar 2010 17:16:58 -0800 (PST)
Date: Mon, 8 Mar 2010 12:16:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/9] xfs: introduce new internal log vector structure
Message-ID: <20100308011655.GG28189@discord.disaster>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-9-git-send-email-david@fromorbit.com>
	<20100306154610.GA29590@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100306154610.GA29590@infradead.org>
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

On Sat, Mar 06, 2010 at 10:46:10AM -0500, Christoph Hellwig wrote:
> On Sat, Mar 06, 2010 at 12:51:23PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The current log IO vector structure is a flat array and not
> > extensible. To make it possible to keep separate log IO vectors for
> > individual log items, we need a method of chaining log IO vectors
> > together.
> > 
> > Introduce a new log vector type that can be used to wrap the
> > existing log IO vectors on use that internally to the log. This
> > means that the existing external interface (xfs_log_write) does not
> > change and hence no changes to the transaction commit code are
> > required.
> > 
> > This initial use of the new log vectors does not use the chaining
> > capability of the new log vector structure - it is not needed to
> > implement the flat vector array the current transaction commit path
> > creates.
> 
> Looks good to me,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> A few comments below:
> 
> > +			/* the data section must be 32 bit size aligned */
> > +			struct {
> > +			    __uint16_t magic;
> > +			    __uint16_t pad1;
> > +			    __uint32_t pad2; /* may as well make it 64 bits */
> > +			} magic = {
> > +				.magic = XLOG_UNMOUNT_TYPE,
> > +			};
> > +			struct xfs_log_iovec reg = {
> > +				.i_addr = (void *)&magic,
> > +				.i_len = sizeof(magic),
> > +				.i_type = XLOG_REG_TYPE_UNMOUNT,
> > +			};
> > +			struct xfs_log_vec vec = {
> > +				.lv_niovecs = 1,
> > +			};
> > +			/* sigh. c99 initialisers don't work on anon unions */
> > +			vec.lv_iovecp = &reg;
> 
> I can't see an anonymous union involved anywhere here, and initializing
> these normally works just fine (see patch below).

Ah, I killed that union for this patch set - I was using embedded
arrays to cut down on memory allocations for the delayed logging so
there was a:

	union {
		struct xfs_log_iovec	*lv_iovecp;
		struct xfs_log_iovec	lv_iovec[0];
	};

in the structure. I decided that the union wasn't necessary for
these patches (and can be avoided entirely, anyway) but I forgot to
fix up the setup of the structure to remove those comments. I'll
update it as you've suggested.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
