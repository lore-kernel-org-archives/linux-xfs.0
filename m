Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQ5fbB2013466 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 23:41:37 -0600
Message-ID: <492CE189.2000304@sgi.com>
Date: Wed, 26 Nov 2008 16:41:29 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C9FB9.3090204@sgi.com> <20081126020009.GF6291@disturbed>
	<492CC287.3070709@sgi.com> <20081126040840.GG6291@disturbed>
In-Reply-To: <20081126040840.GG6291@disturbed>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Nov 26, 2008 at 02:29:11PM +1100, Timothy Shimmin wrote:
>> Dave Chinner wrote:
>>> On Wed, Nov 26, 2008 at 12:00:41PM +1100, Lachlan McIlroy wrote:
>>>> Christoph Hellwig wrote:
>>>>> In either case, do you expect patches against the xfs-dev or the master
>>>>> tree?  It would also be useful if the trees and which one to be used
>>>>> could be documented on oss.sgi.com/projects/xfs or xfs.org.
>>>> We would prefer patches based on the master branch but patches can be
>>>> against the mainline, master or xfs-dev branches. If a patch against
>>>> mainline or xfs-dev doesn't apply cleanly to the master branch we may
>>>> ask the author to rebase that patch against the master branch. If a
>>>> patch to the master branch needs auxillary changes to files that only
>>>> exist in the xfs-dev branch (ie xfsidbg stuff) we may ask for an
>>>> additional patch from the author.
>>> IIUC correctly, you are saying that we'll have to provide two
>>> different versions of every patch set? i.e. one that applies to
>>> the -master branch and potentially another that applies to the
>>> -xfs-dev branch?
>>>
>> No, that's not how I was envisaging this.
>> If you are not interested in modifying xfsidbg.c or dmapi
>> then I'd expect you to only send patches against the master branch.
> 
> Ok, but that conflicts with "we may ask for an additional patch".
:-)
Note the "may".
We're still trying to see what will be the best approach.
I think it is simpler just to expect a patch for one branch that
is convenient to how the external developer works.
SGI is responsible for keeping the branches in sync (is what
I was thinking).

> 
> I'm trying to understand how we (i.e. those of us outside SGI) are
> expected to use these branches.
I understand.
That's why I'd like it to be simple if possible.


> The new setup doesn't seem any
> different to the old trees - there's one repository but really it is
> still two "trees" that will require "external merging" to move
> complex changes between them.
> 
Yeah, there is no magic we can do with kdb and dmapi.
I think Niv tried to reduce some changes between xfs-dev and mainline.

>> I was expecting the xfs-team when they pull in or git-am the
>> patches to update the other branch accordingly.
> 
> It might help to describe how you're expecting patches to flow
> from the developers up to Linus - that might help us understand
> how we should use these trees (i.e. describe the workflow you
> expect to be using)....
> 
> Also, how does a "pull request" from a developer fit into this?
I was just thinking that if an external developer is working on a clone of
say the master branch and they have a fix, that they might post a patch
and say where sgi can pull from (the developer's tree) to receive the patch(es)
as an easier way to bring stuff in.
Otherwise, we can just work with the patches and use git-am to bring them in.

I was expecting the master and for-linus branches to be working similarly
to how they have in the past except now we'd be directly working with the
master branch (instead of a nominated sgi developer having to move ptools
mods over every so often etc..).

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
