Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 271397FE6
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 14:47:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05DD08F8033
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 12:47:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qk6lgjsbkg6FGlAT for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 12:47:38 -0700 (PDT)
Message-ID: <5213C7D8.5020603@sandeen.net>
Date: Tue, 20 Aug 2013 14:47:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
References: <51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com> <520C6E39.7030501@redhat.com>
	<20130815180400.GF3783@sgi.com> <520D4B1B.4080602@redhat.com>
	<20130816140811.GA30422@sgi.com>
In-Reply-To: <20130816140811.GA30422@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 8/16/13 9:08 AM, Geoffrey Wehrman wrote:

> I would like to take this opportunity to point out that SGI's
> attempts to contribute code to XFS are frequently blocked by Red
> Hat without technical merit.  Most recently we tried to submit
> code for the agskip mount option which SGI has been shipping for
> years.  [http://oss.sgi.com/archives/xfs/2013-01/msg00561.html]

Honestly, shipping it for years was SGI's first mistake.  At that
point you can't respond to upstream reviews, because you are committed
to the patch as-is - it's already in the field.  You can't
argue from technical points; you need it merged because you shipped it.
So all you can ask for is thumbs up or thumbs down; you got thumbs down.

Not going upstream first will almost always burn you; now you have
extra maintenance burden forever.  Which takes time away from your
upstream presence, etc, etc.

> We asked for fields to be reserved in the new v3 inodes for parent
> pointers and allocation policies.  That request was soundly rejected
> despite the existence of unreserved padding in the new inode format.
> [http://oss.sgi.com/archives/xfs/2013-04/msg00214.html]  The response
> to code submitted by SGI has been so negative

The response, IIRC, was that we shouldn't reserve fields for
unreviewed designs from the future.  That's sound practice, IMHO,
and I agree.

extN has weird, old, unused structure fields, because this principle
wasn't followed.  I've seen the counterexample, and it sucks.

TBH, if I went to btrfs or ext4, and said hey, please add these fields
because I have a plan, they'd have told me no as well, and to come
back with a patch which implements the plan, for review.

> , we don't even bother
> submitting most of our code to the list anymore as long as it does not
> affect the on-disk format.

That really is unfortunate.  See above about how that is only going to
hurt you, I'm afraid.

>  The list of features and capabilities that we
> carry in our internally maintained source trees is significant and long:
> DMAPI, behavior chains, agskip mount option, ibound mount option, etc.
> These are all features that have been rejected by the external community
> but are of value to SGI customers.

Sure, but their mere existence in your tree doesn't mean that it's the
best solution.  Upstream review & discussion can be arduous, but it
finds & fixes things.  Code written & shipped w/o 3rd party review
tends to have more rough edges than if it had been wrung through
8 versions.

"Note: The ibound mount option is not compatible with the inode64
mount option. If you specify both options, the mount(8) command will
ignore the first option specified. "

Review might have cleaned up that behavior.  :)

> A reiterate my appreciation of Red Hat's contributions to XFS.  However, I
> hope that you and others at Red Hat recognize that Red Hat is not the sole
> source for innovation and contributions to XFS.  The playing field must be
> kept level and everyone in the community must be allowed to participate.

Asking for justification, testing, adherence to best practices, patch
modification cycles, hard questioning, design review, etc is the standard
to which everyone should be held.  It's how xfs has been developed upstream
for years, and what has made it the premier Linux filesystem.   We owe 
each other courtesy during the process, but hard questions and a high bar
should not be perceived as discourtesy.  If it really does get personal,
and sometimes it does despite all our efforts, then point it out, and people
should reset the discussion to the technical side.

Look, I'm trying to be master of 3 or more different Linux filesystems - 
and probably doing a poor job of it.   But the one thing that has impressed
me about XFS apart from the others is that for the most part, bad code doesn't
get through.  On-list review is rigorous, and code is held to very high
standards.  You have to be willing to get behind your proposal and make good
technical arguments, and see it through to the end - or sometimes, lose the
argument and regroup.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
