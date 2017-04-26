Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1434585AbdDZCCO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 22:02:14 -0400
Date: Wed, 26 Apr 2017 04:02:13 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/12] mkfs: save user input into opts table
Message-ID: <20170426020213.GX28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <2bc062f7-eae5-b89a-59e6-4d10daadcd3e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bc062f7-eae5-b89a-59e6-4d10daadcd3e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Apr 25, 2017 at 11:20:34AM -0500, Eric Sandeen wrote:
> On 4/23/17 1:54 PM, Jan Tulak wrote:
> > Hi guys,
> > 
> > I decided to split my big patchset into more smaller ones. So, this is the
> > first set. It adds set/get functions similar to Dave's suggestion, to save and
> > retrieve user values to and from the big opts table and prepares the ground for
> > future patches.
> > 
> > 
> > It is a mix of patches I already submitted and new ones:
> > Patches 2, 3, 4, 5 are just slightly modified to fix their issues.
> > Other patches are new.
> > 
> > The last few patches could be merged into one, because it should only
> > substitute variables for get/set calls, but because there are so many
> > places where the changes occurs, I split them into smaller chunks,
> > making it (hopefully) easier for you to review.
> > 
> > This patchset requires my two previous uint patches.
> 
> Just to be clear, those were NAK'd, I believe, so these may need
> to be rebased without them.

I checked and I see concerns for the data types used expressed but from
what I can tell Jan addressed these concerns and followed up with
subsequent patches. Perhaps it was not clear given he only respun one
of the patches multiple times.

Not sure, but the new bool *processing* request you made though seem to
be a type of change that can perhaps be folded in as part of this initial
series.

  Luis
