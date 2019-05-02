Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfEBMeQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 08:34:16 -0400
Date: Thu, 2 May 2019 08:34:14 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502123414.GA11584@sasha-vm>
References: <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190501221107.GI29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Andre Noll <maan@tuebingen.mpg.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, stable@vger.kernel.org

On Thu, May 02, 2019 at 08:11:07AM +1000, Dave Chinner wrote:
>On Wed, May 01, 2019 at 12:28:22PM -0700, Darrick J. Wong wrote:
>> On Wed, May 01, 2019 at 07:51:29PM +0200, Andre Noll wrote:
>> > On Wed, May 01, 19:15, Greg Kroah-Hartman wrote
>> > > On Wed, May 01, 2019 at 06:59:33PM +0200, Andre Noll wrote:
>> > > > On Wed, May 01, 08:36, Darrick J. Wong wrote
>> > > > > > > You could send this patch to the stable list, but my guess is that
>> > > > > > > they'd prefer a straight backport of all three commits...
>> > > > > >
>> > > > > > Hm, cherry-picking the first commit onto 4.9,171 already gives
>> > > > > > four conflicting files. The conflicts are trivial to resolve (git
>> > > > > > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
>> > > > > > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
>> > > > > > (xfs: create a function to query all records in a btree) is needed as
>> > > > > > well. But then, applying 86210fbebae (xfs: move various type verifiers
>> > > > > > to common file) on top of that gives non-trivial conflicts.
>> > > > >
>> > > > > Ah, I suspected that might happen.  Backports are hard. :(
>> > > > >
>> > > > > I suppose one saving grace of the patch you sent is that it'll likely
>> > > > > break the build if anyone ever /does/ attempt a backport of those first
>> > > > > two commits.  Perhaps that is the most practical way forward.
>> > > > >
>> > > > > > So, for automatic backporting we would need to cherry-pick even more,
>> > > > > > and each backported commit should be tested of course. Given this, do
>> > > > > > you still think Greg prefers a rather large set of straight backports
>> > > > > > over the simple commit that just pulls in the missing function?
>> > > > >
>> > > > > I think you'd have to ask him that, if you decide not to send
>> > > > > yesterday's patch.
>> > > >
>> > > > Let's try. I've added a sentence to the commit message which explains
>> > > > why a straight backport is not practical, and how to proceed if anyone
>> > > > wants to backport the earlier commits.
>> > > >
>> > > > Greg: Under the given circumstances, would you be willing to accept
>> > > > the patch below for 4.9?
>> > >
>> > > If the xfs maintainers say this is ok, it is fine with me.
>> >
>> > Darrick said, he's in favor of the patch, so I guess I can add his
>> > Acked-by. Would you also like to see the ack from Dave (the author
>> > of the original commit)?
>>
>> FWIW it seems fine to me, though Dave [cc'd] might have stronger opinions...
>
>Only thing I care about is whether it is QA'd properly. Greg, Sasha,
>is the 4.9 stable kernel having fstests run on it as part of the
>release gating?

I test only for 5.1 and 4.19 and this point. I don't have a solid
baseline for anything older.

--
Thanks,
Sasha
