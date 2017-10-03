Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43125 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750820AbdJCUXj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:23:39 -0400
Date: Tue, 3 Oct 2017 22:23:35 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
Message-ID: <20171003202335.GF2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-3-mcgrof@kernel.org>
 <1507060941.2567.6.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507060941.2567.6.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mcgrof@kernel.org" <mcgrof@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "jgross@suse.com" <jgross@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "jack@suse.cz" <jack@suse.cz>

On Tue, Oct 03, 2017 at 08:02:22PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-03 at 11:53 -0700, Luis R. Rodriguez wrote:
> > +static bool super_allows_freeze(struct super_block *sb)
> > +{
> > +	return !!(sb->s_type->fs_flags & FS_FREEZE_ON_SUSPEND);
> > +}
> 
> A minor comment: if "!!" would be left out the compiler will perform the
> conversion from int to bool implicitly

For all compilers?

> so I propose to leave out the "!!" and parentheses.

OK!

> Anyway, I agree with the approach of this patch and I think
> that freezing filesystems before processes are frozen would be a big step
> forward.

Great! But please note, the current implementation calls fs_suspend_freeze()
*after* try_to_freeze_tasks(), ie: this implementation freezes userspace and
only after then filesystems.

Order will be *critical* here to get right, so we should definitely figure
out if this is definitely the right place (TM) to call fs_suspend_freeze().

Lastly, a final minor implementation note:

I think using a PM notifier would have been much cleaner, in fact it was my the
way I originally implemented this orthogonally to Jiri's work, however to get
this right the semantics of __pm_notifier_call_chain() would need to be
expanded with another state, perhaps PM_USERSPACE_FROZEN, for example. I
decided in the end a new state was not worth it give we would just have one
user: fs freezing. So to be clear using a notifier to wrap this code into
the fs code and not touching kernel/power/process.c is not possible with
today's semantics nor do I think its worth it to expand on these semantics.

This approach is explicit about order and requirements for those that should
care: those that will maintain kernel/power/process.c and friends. Having
this in a notifier would shift this implicitly.

  Luis
