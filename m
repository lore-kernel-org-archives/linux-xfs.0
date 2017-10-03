Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41819 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751115AbdJCUNZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:13:25 -0400
Date: Tue, 3 Oct 2017 22:13:21 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 4/5] ext4: add fs freezing support on suspend/hibernation
Message-ID: <20171003201321.GE2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-5-mcgrof@kernel.org>
 <20171003195930.ivgaccdabxczar62@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171003195930.ivgaccdabxczar62@thunk.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 03:59:30PM -0400, Theodore Ts'o wrote:
> On Tue, Oct 03, 2017 at 11:53:12AM -0700, Luis R. Rodriguez wrote:
> > @@ -4926,7 +4926,7 @@ static int ext4_unfreeze(struct super_block *sb)
> >  		ext4_set_feature_journal_needs_recovery(sb);
> >  	}
> >  
> > -	ext4_commit_super(sb, 1);
> > +	ext4_commit_super(sb, 0);
> >  	return 0;
> >  }
> >
> 
> After we remove add the NEEDS_RECOVERY flag, we need to make sure
> recovery flag is pushed out to disk before any other changes are
> allowed to be pushed out to disk.  That's why we originally did the
> update synchronously.

I see. I had to try to dig through linux-history to see why this was done, and
I actually could not find an exact commit which explained what you just did.
Thanks!

Hrm, so on freeze we issue the same commit as well, so is a sync *really* needed
on thaw?

> There are other ways we could fulfill this requirements, but doing a
> synchronous update is the simplest way to handle this.  Was it
> necessary to change this given the other changes you are making the fs
> freeze implementation?

No, it was am empirical evaluation done at testing, I observed bio_submit()
stalls, we never get completion from the device. Even if we call thaw at the
very end of resume, after the devices should be up, we still end up in the same
situation. Given how I order freezing filesystems after freezing userspace I do
believe we should thaw filesystems prior unfreezing userspace, its why I placed
the call where it is now.

So this is something I was hoping others could help grok/iron out. I'd prefer
if we could live with thaw'ing unchanged, but this requires to figure this
issue out. Why we can't implicate bio_submit() on fs thaw as-is in this
implementation.

  Luis
