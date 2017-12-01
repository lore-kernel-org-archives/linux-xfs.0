Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdLAVNb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 16:13:31 -0500
Date: Fri, 1 Dec 2017 22:13:27 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 03/11] fs: add frozen sb state helpers
Message-ID: <20171201211327.GQ729@wotan.suse.de>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171129232356.28296-4-mcgrof@kernel.org>
 <20171130171310.GG28180@quack2.suse.cz>
 <20171130190548.GJ729@wotan.suse.de>
 <20171201114724.GC8365@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171201114724.GC8365@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Dec 01, 2017 at 12:47:24PM +0100, Jan Kara wrote:
> On Thu 30-11-17 20:05:48, Luis R. Rodriguez wrote:
> > On Thu, Nov 30, 2017 at 06:13:10PM +0100, Jan Kara wrote:
> > > ... I dislike the _by_user() suffix as there may be different places that
> > > call freeze_super() (e.g. device mapper does this during some operations).
> > > Clearly we need to distinguish "by system suspend" and "the other" cases.
> > > So please make this clear in the naming.
> > 
> > Ah. How about sb_frozen_by_cb() ?
> 
> And what does 'cb' stand for? :)

Callback. But let me think about bdev usage a bit and we can worry about the
bikeshedding later.

> > > In fact, what might be a cleaner solution is to introduce a 'freeze_count'
> > > for superblock freezing (we already do have this for block devices). Then
> > > you don't need to differentiate these two cases - but you'd still need to
> > > properly handle cleanup if freezing of all superblocks fails in the middle.
> > > So I'm not 100% this works out nicely in the end. But it's certainly worth
> > > a consideration.
> > 
> > Ah, there are three important reasons for doing it the way I did it which are
> > easy to miss, unless you read the commit log message very carefully.
> > 
> > 0) The ioctl interface causes a failure to be sent back to userspace if
> > you issue two consecutive freezes, or two thaws. Ie, once a filesystem is
> > frozen, a secondary call will result in an error. Likewise for thaw.
> 
> Yep. But also note that there's *another* interface to filesystem freezing
> which behaves differently - freeze_bdev() (used internally by dm). That
> interface uses the counter and freezing of already frozen device succeeds.

Ah... so freeze_bdev() semantics matches the same semantics I was looking
for.

> IOW it is a mess.

To say the least.

> We cannot change the behavior of the ioctl but we could
> still provide an in-kernel interface to freeze_super() with the same
> semantics as freeze_bdev() which might be easier to use by suspend - maybe
> we could call it 'exclusive' (for the current freeze_super() semantics) and
> 'non-exclusive' (for the freeze_bdev() semantics) since this is very much
> like O_EXCL open of block devices...

Sure, now typically I see we make exclusive calls with the postfix _excl() so
I take it you'd be OK in renaming freeze_super() freeze_super_excl() eventually
then?

I totally missed freeze_bdev() otherwise I think I would have picked up on the
shared semantics stuff and I would have just made a helper out of what
freeze_bdev() uses, and then have both in-kernel and freeze_bdev() use it.

I'll note that its still not perfectly clear if really the semantics behind
freeze_bdev() match what I described above fully. That still needs to be
vetted for. For instance, does thaw_bdev() keep a superblock frozen if we
an ioctl initiated freeze had occurred before? If so then great. Otherwise
I think we'll need to distinguish the ioctl interface. Worst possible case
is that bdev semantics and in-kernel semantics differ somehow, then that
will really create a holy fucking mess.

> > 1) The new iterate supers stuff I added bail on the first error and return that
> > error. If we kept the ioctl() interface error scheme we'd be erroring out
> > if on suspend if userspace had already frozen a filesystem. Clearly that'd
> > be silly so we need to distinguish between the automatic kernel freezing
> > and the old userspace ioctl initiated interface, so that we can keep the
> > old behaviour but allow in-kernel auto freeze on suspend to work properly.
> 
> This would work fine with the non-exclusive semantics I believe.

Groovy.

> > 2) If we fail to suspend we need to then thaw up all filesystems. The order
> > in which we try to freeze is in reverse order on the super_block list. If we
> > fail though we iterate in proper order on the super_block list and thaw. If
> > you had two filesystems this means that if a failure happened on freezing
> > the first filesystem, we'd first thaw the other filesystem -- and because of
> > 0) if we don't distinguish between the ioctl interface or auto freezing, we'd
> > also fail on thaw'ing given the other superblock wouldn't have been frozen.
> > 
> > So we need to keep two separate approaches. The count stuff would not suffice
> > to distinguish origin of source for freeze call.
> > 
> > Come to think of it, I think I forgot to avoid thaw if the freeze was ioctl
> > initiated..
> > 
> > thaw_unlocked(bool cb_call)
> > {
> >   if (sb_frozen_by_cb(sb) && !cb_call)
> >     return 0; /* skip as the user wanted to keep this fs frozen */
> >   ...
> > }
> > 
> > Even though the kernel auto call is new I think we need to keep ioctl initiated
> > frozen filesystems frozen to not break old userspace assumptions.
> > 
> > So, keeping all this in mind, does a count method still suffice?
> 
> The count method would need a different error recovery method - i.e. if you
> fail freezing filesystems somewhere in the middle of iteration through
> superblock list, you'd need to iterate from that point on to the superblock
> where you've started. This is somewhat more complicated than your approach
> but it seems cleaner to me:
> 
> 1) Function freezing all superblocks either succeeds and all superblocks
> are frozen or fails and no superblocks are (additionally) frozen.

To be clear, for now this would just be, all superblocks that support
freeze_fs() are frozen :)

> 2) It is not that normal users + one special user (who owns the "flag" in
> the superblock in form of a special freeze state) setup. We'd simply have
> exclusive and non-exclusive users of superblock freezing and there can be
> arbitrary numbers of them.

Sorry I did not understand this point. Can you rephrase perhaps a bit?

Anyway, I just tried implementing this and it seemed rather easy to
use a pivot, however note that then freeze_processes() which calls
fs_suspend_freeze() would somehow need to pass the failed sb... do
we want to have let fs_suspend_freeze() pass a parameter to be set
to the failed sb of it failed? Locking-wise this seems racy.

So I mean, adding support to thaw using a pivot, the failed sb is
rather easy:

diff --git a/fs/super.c b/fs/super.c
index 885711c1d35b..8cb6f38652d8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -614,13 +614,21 @@ void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
  *	locked superblock and given argument. Returns 0 unless an error
  *	occurred on calling the function on any superblock.
  */
-int iterate_supers_excl(int (*f)(struct super_block *, void *), void *arg)
+int iterate_supers_excl(int (*f)(struct super_block *, void *), void *arg,
+			struct super_block *pivot)
 {
 	struct super_block *sb, *p = NULL;
 	int error = 0;
 
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &super_blocks, s_list) {
+		/* If we have a pivot, start work on the next item */
+		if (pivot) {
+			if (sb != pivot)
+				continue;
+			pivot = NULL;
+			continue;
+		}
 		if (hlist_unhashed(&sb->s_instances))
 			continue;
 		sb->s_count++;

But we'd still need to to give enough context to let thaw use the failed sb
as a pivot.

  Luis
