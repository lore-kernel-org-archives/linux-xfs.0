Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A4FB7F61
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 22:32:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 691328F8035
	for <xfs@oss.sgi.com>; Sun, 30 Nov 2014 20:32:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RyNoy5dUWAaMJuQe for <xfs@oss.sgi.com>;
	Sun, 30 Nov 2014 20:32:10 -0800 (PST)
Date: Mon, 1 Dec 2014 15:31:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Meeting
Message-ID: <20141201043155.GH16151@dastard>
References: <BLU402-EAS63BA21BE641D092688C4CAE1700@phx.gbl>
	<CAJAKVEFdkSEMW84=TvRNqOQdNMz6nS_WRVGN-2MX5se9NUaV1A@mail.gmail.com>
	<CAFhuFEd3eVhKy1Jg7qL-ycw4XHnAd16kkstpOhOUpwVsAPN5mw@mail.gmail.com>
	<CAJAKVEHs=FczXUnAYfhbdav1o6JONmD7y0Kgc1xUo1t9g3=63Q@mail.gmail.com>
	<CAJAKVEFk5oc98gqF8CnGzz7Vsat-i=0da+aYwJh-EGX8eX9sgw@mail.gmail.com>
	<CAFhuFEc+mbGqZtDVY_wT99dd=FPUKDKZkHN3FYaBgzaVEb=q_A@mail.gmail.com>
	<CAJAKVEFD0PuFW0eF_Csk1oQJnzZ2eYW=pywHFKJb-ArroRq_cA@mail.gmail.com>
	<CAJAKVEE2Lu=MReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw@mail.gmail.com>
	<CAF3jHnqRp9HCuXcgv7SBE=kNJ036GysLAx+dgL6v2V_jN2Nrng@mail.gmail.com>
	<CAJAKVEEAAaf-sA+jbTr8A_HAUMcToo6Esd8ithPvE4tY4TW2NA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJAKVEEAAaf-sA+jbTr8A_HAUMcToo6Esd8ithPvE4tY4TW2NA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Somdeep Dey <somdeepdey10@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 01, 2014 at 01:29:47AM +0530, Somdeep Dey wrote:
> Hi,
> 
> We've now resumed working on the xfs_fsr utility as discussed before, after
> our exams.
> 
> The first task that we undertook was to use fiemap to get file extent
> mappings and tried to correlate the output with the information obtained
> from xfs_bmap. For this we used the two underlying structures fiemap
> and fiemap_extent. We're now trying to use the available free space mapping
> patches to get free spaces in the file system.
> 
> We also wanted to ask about the current status of the rmap, as we'll
> be required to define the interfaces that query it, as a key component of
> our
> work.

The rmap design is slowly being thrashed out. Brian and I had a
discussion about it on IRC a couple of weeks ago (below).

I'm relatively close to having a proof of concept for single-owner
rmap btrees that works...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

>From #xfs on freenode.net

[13/11/14 10:07] <dchinner_> foster: still around?
[13/11/14 10:10] <foster> dchinner_: yep
[13/11/14 10:27] <dchinner_> foster: been prototyping reverse mapping btree code over the past couple of days
[13/11/14 10:28] <dchinner_> couple of interesting issues have come up that need discussion
[13/11/14 10:28] <dchinner_> I think I have solutions to them, but I'm sure there are other ways of solving the problems
[13/11/14 10:28] <dchinner_> basically I want the rmap btree for two purposes
[13/11/14 10:29] <dchinner_> 1) to keep owner information so we can do block-to-owner lookups efficiently
[13/11/14 10:29] <dchinner_> e.g. to identify the files corrupted by bad sectors
[13/11/14 10:29] <dchinner_> found during a media scan
[13/11/14 10:31] <dchinner_> or to provide sufficient redundant information for an online rebuild of a corrupted free space btree
[13/11/14 10:32] <foster> so a btree that maps extents to inodes or something of that nature?
[13/11/14 10:32] <dchinner_> exactly
[13/11/14 10:32] <dchinner_> per-ag btree
[13/11/14 10:32] <dchinner_> that contains { start block, length, owner }
[13/11/14 10:32] <dchinner_> records
[13/11/14 10:32] <foster> ok
[13/11/14 10:33] <dchinner_> that's relatively easy to do
[13/11/14 10:33] <dchinner_> The patches I've written do that.
[13/11/14 10:33] <dchinner_> (not that it does anything other than compile yet)
[13/11/14 10:33] <dchinner_> however, there is a second reason for having a reverse mapping tree
[13/11/14 10:34] <dchinner_> it's for reference counting extents shared between inodes
[13/11/14 10:34] <foster> ah, reflink?
[13/11/14 10:34] <dchinner_> i.e. to implement reflink semantics
[13/11/14 10:34] <dchinner_> *nod*
[13/11/14 10:35] <dchinner_> this doesn't affect how the ramp btree interacts with the rest of the allocation/freeing code
[13/11/14 10:35] <dchinner_> but it does affect the "extent owner" tracking
[13/11/14 10:35] <dchinner_> i.e. we can now have multiple owners of an extent
[13/11/14 10:36] <dchinner_> so that btree record now becomes {stat, len, refcount, owner, owner, .... owner }
[13/11/14 10:36] <foster> yeah
[13/11/14 10:36] <dchinner_> and we can't do that with the generic btree infrastructure because it's all based around fixed length records
[13/11/14 10:38] <dchinner_> I've come up with a way of using fixed length records to implement this variable length shared rmap record
[13/11/14 10:38] <dchinner_> which uses the high bit of the start block number to distinguish between the types of records
[13/11/14 10:39] <dchinner_> and, in some cases, also uses the high bit of the extent length field to hold more information again.
[13/11/14 10:40] <dchinner_> but the issue is that it's quite complicated
[13/11/14 10:40] <dchinner_> and there's some interesting warts around records that span multiple btree blocks
[13/11/14 10:41] <dchinner_> because they've been shared across hundreds of owners
[13/11/14 10:43] <dchinner_> I can't see any obvious way of tracking owner information another way when we have shared extents
[13/11/14 10:44] <dchinner_> it's an 1:N mapping
[13/11/14 10:44] <foster> this information that's encoded in the record indicates the length of the record, or some kind of record chaining method..?
[13/11/14 10:44] <dchinner_> both ;)
[13/11/14 10:45] <foster> heh, ok
[13/11/14 10:45] <dchinner_> the first record becomes { start block, length, refcount, owner records}
[13/11/14 10:45] <dchinner_> and so a shared extent record looks like:
[13/11/14 10:46] <dchinner_> {{ master extent record}, {owner record }, {owner record }, .... {owner record}}
[13/11/14 10:46] <dchinner_> when an owner record is simply {owner #1, owner #2}
[13/11/14 10:47] <dchinner_> so both the master record and the owner record are teh same size (16 bytes)
[13/11/14 10:48] <dchinner_> so you can see how it can be problematic when a btree block only contains owner records
[13/11/14 10:48] <dchinner_> there's no start/len information, and so it's problematic for indexing that block in the higher levels of the btree
[13/11/14 10:49] <dchinner_> as the higher levels need to point to the master records....
[13/11/14 10:49] <foster> I'm missing how the master record refers to the owner record
[13/11/14 10:50] <foster> does it, or it's simply followed by the owner records?
[13/11/14 10:50] <dchinner_> owner records always follow the master record
[13/11/14 10:50] <foster> ok
[13/11/14 10:50] <dchinner_> right
[13/11/14 10:51] <dchinner_> So what I'm wondering is whether you think this is way too complex
[13/11/14 10:51] <dchinner_> or whether we might do better to have some other representation
[13/11/14 10:52] <dchinner_> such as keeping owner records in a different tree
[13/11/14 10:53] <dchinner_> or even not keeping them at all for shared extents
[13/11/14 10:53] <foster> sounds somewhat hairy at first, my first reaction is to think about whether there's some kind of level of indirection
[13/11/14 10:53] <foster> but i obviously haven't thought about this much at all
[13/11/14 10:54] <dchinner_> right, and I'm trying not to expose you to allthe gruesome details of what I've come up with ;)
[13/11/14 10:54] <dchinner_> just enough to describe the problem
[13/11/14 10:54] <foster> understood, i think i get the gist of it
[13/11/14 10:54] <foster> effectively creating first order/second order records within the tree
[13/11/14 10:55] <dchinner_> right
[13/11/14 10:55] <foster> or chaining or whatever the best terminology is ;)
[13/11/14 10:56] <dchinner_> hmmm, which triggers me immediately to think of an interesting btree extension
[13/11/14 10:57] <foster> hmm, a second tree is an interesting thought
[13/11/14 10:57] <foster> or some kind of magic/hidden owner inode that handles shared records
[13/11/14 10:57] <dchinner_> which, at first glance, makes it very similar to the directory btree structure....
[13/11/14 10:59] <dchinner_> need to think about that more....
[13/11/14 11:02] <dchinner_> (basically adding another level below the current leaf level of the btree that only holds owner records)
[13/11/14 11:06] <foster> interesting, though i'm not familiar enough with the on-disk dir structure to reason about off hand

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
