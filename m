Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750820AbdJCVRD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 17:17:03 -0400
Date: Tue, 3 Oct 2017 23:16:58 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
Message-ID: <20171003211658.GK2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-3-mcgrof@kernel.org>
 <20171003205841.GN3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003205841.GN3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 07:58:41AM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 11:53:10AM -0700, Luis R. Rodriguez wrote:
> > diff --git a/fs/super.c b/fs/super.c
> > index d45e92d9a38f..ce8da8b187b1 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -1572,3 +1572,82 @@ int thaw_super(struct super_block *sb)
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL(thaw_super);
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static bool super_allows_freeze(struct super_block *sb)
> > +{
> > +	return !!(sb->s_type->fs_flags & FS_FREEZE_ON_SUSPEND);
> > +}
> 
> That's a completely misleading function name. All superblocks can be
> frozen - freeze_super() is filesystem independent. And given that, I
> don't see why these super_should_freeze() hoops need to be jumped
> through...

I added this given ext4's current thaw implementation stalls on resume 
as it implicates a bio_submit() and this never completes. So I refactored
ext4 thaw skip a sync on thaw. This requires more eyeballs. This may be an
underlying issue elsewhere.  If its not an bug elsewhere or on ordering, then
there may be some restrictions on thaw when used on resume. Refer to my notes
to Ted on patch #4 for ext4.

> > +int fs_suspend_freeze_sb(struct super_block *sb, void *priv)
> > +{
> > +	int error = 0;
> > +
> > +	spin_lock(&sb_lock);
> > +	if (!super_should_freeze(sb))
> > +		goto out;
> > +
> > +	up_read(&sb->s_umount);
> > +	pr_info("%s (%s): freezing\n", sb->s_type->name, sb->s_id);
> > +	error = freeze_super(sb);
> > +	down_read(&sb->s_umount);
> > +out:
> > +	if (error && error != -EBUSY)
> > +		pr_notice("%s (%s): Unable to freeze, error=%d",
> > +			  sb->s_type->name, sb->s_id, error);
> > +	spin_unlock(&sb_lock);
> > +	return error;
> > +}
> 
> I don't think this was ever tested.  Calling freeze_super() with a
> spinlock held with through "sleeping in atomic" errors all over the
> place.

No, I run time tested it with a rootfs with ext4 and xfs with my
development tree and hammering on both while I loop on suspend
and resume.

> Also, the s_umount lock juggling is nasty. Your new copy+pasted
> iterate_supers_reverse() takes the lock in read mode, yet all the
> freeze/thaw callers here want to take it in write mode.

Yeap, yuk!

> So, really,
> iterate_supers_reverse() needs to be iterate_supers_reverse_excl()
> and take the write lock, and freeze_super/thaw_super need to be
> factored into locked and unlocked versions.
> 
> In which case, we end up with:
> 
> int fs_suspend_freeze_sb(struct super_block *sb, void *priv)
> {
> 	return freeze_locked_super(sb);
> }
> 
> int fs_suspend_thaw_sb(struct super_block *sb, void *priv)
> {
> 	return thaw_locked_super(sb);
> }

Groovy, thanks, I suspected that locking was convoluted and
we could come up with something better. Will do it this way.

Its really what I hoped we could do :) I just needed to get
it in writing.

  Luis
