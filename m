Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49892 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1956730AbdDZIBq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 04:01:46 -0400
Date: Wed, 26 Apr 2017 10:01:42 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Message-ID: <20170426080142.GY28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de>
 <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
 <175c1e19-12df-2993-811d-b5de631ac00f@sandeen.net>
 <20170426013815.GS28800@wotan.suse.de>
 <ef444d22-6251-c611-9c1e-106f7bbe4e0f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef444d22-6251-c611-9c1e-106f7bbe4e0f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 09:00:40PM -0500, Eric Sandeen wrote:
> On 4/25/17 8:38 PM, Luis R. Rodriguez wrote:
> >>>>> +#define MAX_OPTS     16
> >>>>
> >>>> This is fragile, every time a new opt is added this needs to be updated
> >>
> >> <pedantic>There are only 8 now, so there are still 8 free slots</pedantic>
> >>
> >>>> and so is the index, and we should be pedantic over not going out of bounds.
> >>>> We could instead use a flexible array and compute the max opts at run time
> >>>> as a global. This way the max opts is always updated automatically.
> >>
> >> I don't think it's all that fragile;
> > 
> > We can avoid such compilation warnings.
> 
> Well, post the proposed patch when appropriate, and it can go through review.
> 
> ...

Well it is Jan's patch I am reviewing, not mine. I was happy to help with all this
given I had dome similar work as Jan is doing, we determined it was best to wait
for Jan's table work to fold in as it was compatible with my own goals. But I
think we all agree that while we're making all these changes to the opts / subopts
best to strive for anything that makes things better. Its part of my review.

> >> In any case, any changes around this behavior would certainly
> >> be part of a different patch, because you'd want to be consistent with all
> >> the other structure initializers, and it would be a functionally separate
> >> change if it is warranted at all.
> > 
> > The opt_params are separate today though, this patch folds them in together,
> > what I propose is just to use a flexible array to avoid an explicit size
> > from the start. Not sure how much more functional of a change that is ?
> 
> Because it'd be inconsistent with the other array declarations.
> 
> Prior to this patch we had 2 #defines to declare sizes of global
> arrays:
> 
> #define MAX_SUBOPTS	16
> 	const char	*subopts[MAX_SUBOPTS];
> 	}		subopt_params[MAX_SUBOPTS];
> 
> #define MAX_CONFLICTS	8
> 		int		conflicts[MAX_CONFLICTS];
> 
> now we add a third:
> 
> #define MAX_OPTS	16
> } opts[MAX_OPTS] = {

Ah yes in that sense yes, it would be inconsistent with the old way
of using defines for arrays. But then again the struct opt_params never
had this define, and its "old way" was to declare each on its own.

> If you're not a fan of #defines to size global arrays that's ok, but
> let's be consistent and change them all at once, and not change one
> of the 3 as a side-effect of collapsing the separate opts structures
> into one.

Hm, changing all 3 of these of these: opts, suboopts, conflicts to flexible
array may be possible without making the patch impossible to review, but its not
clear to me, I'd be surprised though.

Anyway in case its useful to Jan or others here's an example of what it using
flexible arrays could look like for an opt/subopt framework:

http://drvbp1.linux-foundation.org/~mcgrof/demos/demo-flexible-array-subopts.c

> For now, let's follow the pattern of the existing code, and submit a 
> comprehensive functional patch to address this separate change.
> 
> Small, reviewable, distinct, functional changes.

This patch moves the opts to the 'old' way of doing things with no good reason
other than its the old style. I find more reasons to move away from it, to enable
later making subopts and conflicts also use flexible array (if this is agreed
suitable).

  Luis
