Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB33k5uG013039 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:46:05 -0600
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C9FB9.3090204@sgi.com> <20081126020009.GF6291@disturbed>
	<492CC287.3070709@sgi.com> <20081126040840.GG6291@disturbed>
Date: Wed, 03 Dec 2008 14:45:52 +1100
In-Reply-To: <20081126040840.GG6291@disturbed> (Dave Chinner's message of
	"Wed, 26 Nov 2008 15:08:40 +1100")
Message-ID: <nccy6yxly4v.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


[Catching up on old mail]
Dave Chinner <david@fromorbit.com> writes:
> On Wed, Nov 26, 2008 at 02:29:11PM +1100, Timothy Shimmin wrote:
>
>> Dave Chinner wrote:
>> > On Wed, Nov 26, 2008 at 12:00:41PM +1100, Lachlan McIlroy wrote:
>> >> Christoph Hellwig wrote:
>> >>> In either case, do you expect patches against the xfs-dev or the master
>> >>> tree?  It would also be useful if the trees and which one to be used
>> >>> could be documented on oss.sgi.com/projects/xfs or xfs.org.
>> >> We would prefer patches based on the master branch but patches can be
>> >> against the mainline, master or xfs-dev branches. If a patch against
>> >> mainline or xfs-dev doesn't apply cleanly to the master branch we may
>> >> ask the author to rebase that patch against the master branch. If a
>> >> patch to the master branch needs auxillary changes to files that only
>> >> exist in the xfs-dev branch (ie xfsidbg stuff) we may ask for an
>> >> additional patch from the author.
>> > 
>> > IIUC correctly, you are saying that we'll have to provide two
>> > different versions of every patch set? i.e. one that applies to
>> > the -master branch and potentially another that applies to the
>> > -xfs-dev branch?
>> > 
>> No, that's not how I was envisaging this.
>> If you are not interested in modifying xfsidbg.c or dmapi
>> then I'd expect you to only send patches against the master branch.
>
> Ok, but that conflicts with "we may ask for an additional patch".
>
> I'm trying to understand how we (i.e. those of us outside SGI) are
> expected to use these branches. The new setup doesn't seem any
> different to the old trees - there's one repository but really it is
> still two "trees" that will require "external merging" to move
> complex changes between them.

you can work with xfs-dev or master as you please, if you work on
xfs-dev, we would like changes to xfs-dev only files (and bits), to be
in separated patches, so that we can push back only those changes to
master.

branches make sense, as we want to keep those trees as close as
possible, and merges will work (from master to xfs-dev, we need, for
obvious reasons, to cherry-pick the other way around).

>> I was expecting the xfs-team when they pull in or git-am the
>> patches to update the other branch accordingly.
>
> It might help to describe how you're expecting patches to flow
> from the developers up to Linus - that might help us understand
> how we should use these trees (i.e. describe the workflow you
> expect to be using)....
>
> Also, how does a "pull request" from a developer fit into this?

[DEV]-(am||pull)->[master]->[LINUS]
                   +-(merge)->[xfs-dev]

OR

[DEV]-(am||pull)->[xfs-dev,xfs-dev/{kdb,idbg,dmapi}]
                   +-(cherry pick)->[master]->[LINUS]

Cheers,
-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
