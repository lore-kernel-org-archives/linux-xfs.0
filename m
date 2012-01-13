Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0D09bdR046117 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 18:09:38 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0VGMWeHEG1ENgbLt for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 16:09:35 -0800 (PST)
Date: Fri, 13 Jan 2012 11:09:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] Fix filesystem freezing
Message-ID: <20120113000932.GD2806@dastard>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
	<20120112024841.GB2806@dastard>
	<20120112113031.GA8778@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120112113031.GA8778@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Jan 12, 2012 at 12:30:31PM +0100, Jan Kara wrote:
> On Thu 12-01-12 13:48:41, Dave Chinner wrote:
> > On Thu, Jan 12, 2012 at 02:20:49AM +0100, Jan Kara wrote:
> > > 
> > >   Hello,
> > > 
> > >   filesystem freezing is currently racy and thus we can end up with dirty data
> > > on frozen filesystem (see changelog of the first patch for detailed race
> > > description and proposed fix). This patch series aims at fixing this.
> > 
> > It only fixes the dirty data race (i.e. SB_FREEZE_WRITE). The same
> > race conditions exist for SB_FREEZE_TRANS on XFS, and so need the
> > same fix. That race has had one previous attempt at fixing it in
> > XFS but that's not possible:
> > 
> > b2ce397 Revert "xfs: fix filesystsem freeze race in xfs_trans_alloc"
> > 7a249cf xfs: fix filesystsem freeze race in xfs_trans_alloc
> > 
> > It was looking at that problem earlier today that lead to the
> > solution Eric proposed. Essentially the method in these patches
> > needs to replace the xfs specifc m_active_trans counter and delay
> > during ->fs_freeze to prevent that race condition....
>   OK, I see. I just checked ext4 to make sure and ext4 seems to get this
> right. Looking into Christoph's original patch it shouldn't be hard to fix
> it. Instead of:
>         atomic_inc(&mp->m_active_trans);
>  
>         if (wait_for_freeze)
>               xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
> 
> we just need to do a bit more elaborate
> 
> retry:
>         if (wait_for_freeze)
>               xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
>         atomic_inc(&mp->m_active_trans);
> 	if (wait_for_freeze && mp->m_super->s_frozen >= SB_FREEZE_TRANS) {
>         	atomic_dec(&mp->m_active_trans);
> 		goto retry;
> 	}
> 
> Or does XFS support nested transactions (i.e. a thread already holding a
> running transaction can call into xfs_trans_alloc() again)?
> That would make things more complicated...

You're still missing the point - that this isn't an XFS specific
problem or that the write problem is a ext4 specific problem. The
problem is that these are freeze state transition problems -
something that can affect every filesystem because the freeze code
is generic.  Quite frankly, I'm not interested in having a generic
solution for SB_FREEZE_WRITE and a custom, per filesystem solution
for SB_FREEZE_TRANS when the solution is exactly the same.

> Using sb_start_write() instead of m_active_trans won't be that easy because
> it can create A-A deadlocks (e.g. we do sb_start_write in
> block_page_mkwrite() and then xfs_get_blocks() decides to start a
> transaction and calls sb_start_write() again which might block if
> filesystem freezing started in the mean time).

So, like Eric said in his first email, it's not a "write start/end"
interface that is needed, the interface has to work with different
freeze levels (e.g "sb_freeze_ref(sb, level)/sb_freeze_drop(sb,
level)").  Sure, internally it would have to map to two counters and
different level checks, but it solves the same problem for all
levels of freeze for all filesystems.

Let's fix this freeze problem once and for all in the generic code,
and not have to keep coming back to it to add more functioanlity for
different situations the most recent fix didn't handle for random
filesystem X....

> So it's up to XFS maintainers to decide what's best but I'd take
> Christoph's patch with above fixup. I guess I'll put it in this series and
> see what people say.

Eric and I have already discussed and agreed to replacing the XFS
sepcific code with the fixed VFS level API where other XFS
developers including the "XFS Maintainers" (*) can see. Nobody has
objected so I doubt there's any problem with doing so.

Besides, anything that replaces custom XFS code with a better
generic solution is pretty much guaranteed to be done. And given
that this is not an XFS specifc problem and it needs be fixed at
the VFS level.....

Cheers,

Dave.

[*] keep in mind that "XFS Maintainer" is just a figurehead who
maintains the tree that is sent to Linus, not the person with final
say over what changes are made. That decision is made by the
reviewers of the code...

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
