Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p880q2vn193137 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 19:52:02 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E876813D2A6D
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 17:56:08 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 8Pq9hcytE2yAHlHZ for <xfs@oss.sgi.com>;
	Wed, 07 Sep 2011 17:56:08 -0700 (PDT)
Date: Thu, 8 Sep 2011 02:51:58 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH, RFC] writeback: avoid redirtying when ->write_inode
	failed to clear I_DIRTY
Message-ID: <20110908005158.GJ7725@quack.suse.cz>
References: <20110827061409.GA6854@infradead.org>
	<20110827135825.GA22575@localhost>
	<20110903011315.GJ12182@quack.suse.cz>
	<20110903213527.GB10529@localhost>
	<20110905111153.GD5466@quack.suse.cz>
	<20110905132216.GB1349@localhost>
	<20110907115237.GA21478@infradead.org>
	<20110907125105.GA15064@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110907125105.GA15064@localhost>
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
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed 07-09-11 20:51:05, Wu Fengguang wrote:
> On Wed, Sep 07, 2011 at 07:52:37PM +0800, Christoph Hellwig wrote:
> > On Mon, Sep 05, 2011 at 09:22:16PM +0800, Wu Fengguang wrote:
> > > > > That's a reasonable robust option, however at the cost of keeping the
> > > > > writeback code in some ambiguous state ;)
> > > >   What do you exactly mean by ambiguous state?
> > > 
> > > I mean in Christoph's case, it will be calling requeue_io() and at the
> > > same time rely on your suggested unconditional sleep at the end of
> > > wb_writeback() loop to avoid busy loop. Or in other words, b_more_io
> > > will be holding both inodes that should be busy retried and the inodes
> > > to be opportunistically retried.  However I admit it's not a big
> > > problem if we take b_more_io as general "to be retried ASAP".
> > > 
> > > > I don't see anything ambiguous in waiting for a jiffie or so. Not
> > > > that I'd be completely happy about "just wait for a while and see if
> > > > things are better" but your solution does not seem ideal either... 
> > > 
> > > There are no big differences (that matter) in terms of "how much exact
> > > time to wait" in this XFS case.  What make me prefer b_more_io_wait is
> > > that it looks a more general solution to replace the majority
> > > redirty_tail() calls to avoid modifying dirtied_when.
> > 
> > FYI, we had a few more users hit this issue recently.  I'm not sure why,
> > but we are seeing this fairly often now.  I'd really like to get some
> > sort of fix for this in ASAP as it causes data loss for users.  
> 
> Jan, do you agree to push the b_more_io_wait patch into linux-next?
> 
> If not, let's do a patch to do unconditional sleep at the end of the
> wb_writeback() loop?
  Well, what I don't like about b_more_io_wait is that the logic shifting
inodes between lists becomes subtle and I'm afraid we could easily break it
in future. Also times when inodes are retried are not so well defined
although I agree that most likely that's not going to be a problem in
practice. So that's why I'd prefer to use more robust approach of just
waiting in the loop when we couldn't make any progress. I've just sent a
patch which does that and a patch which converts redirty_tail()s to
requeue_io() where it makes sense. Note that writeback_single_inode()
change is a bit more complex to keep livelock avoidance working. Please
have a look whether the patches would be fine with you. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
