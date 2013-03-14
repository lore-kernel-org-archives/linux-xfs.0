Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1D8CD7F37
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 01:18:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBF3E304067
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 23:18:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gTyXtgsYKA0W4AkD for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 23:18:43 -0700 (PDT)
Date: Thu, 14 Mar 2013 17:18:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/14] xfs: Support for interacting with multiple user
	namespaces
Message-ID: <20130314061839.GY21651@dastard>
References: <87boan3prc.fsf@xmission.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87boan3prc.fsf@xmission.com>
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
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>

On Wed, Mar 13, 2013 at 03:21:11PM -0700, Eric W. Biederman wrote:
> 
> Or replace uids, gids, and projids with kuids, kgids, and kprojids
> 
> In support of user namespaces I have introduced into the kernel kuids,
> kgids, and kprojids.  The most important characteristic of these ids is
> that they are not assignment compatible with uids, gids, and projids
> coming from userspace nor are they assignment compatible with uids, gids
> or projids stored on disk.  This assignment incompatibility makes it
> easy to ensure that conversions are introduced at the edge of userspace
> and at the interface between on-disk and in-memory data structures.

TL;DR:

Compared to the last version of this patchset I NACKed, this version
increases the per-inode memory footprint by over 100 bytes (i.e. by
more than 10%), introduces a double copy of the inode core data into
the *hottest path in XFS*, breaks log recovery and fails to address
a single NACK I gave for the previous round of the patch set.

So, NACK.

> Converting xfs is an interesting challenge because of the way xfs
> handles it's inode data is very atypical. 

That you have to tell people that find it strange an unusual
immediately indicates that you do not really understand the design
and structure of the XFS code. This makes your refusal to listen to
feedback from someone who is a subject matter expert all the more
difficult to understand.

I'll accept that you might forget something mentioned in a review
when you post an update, but to ignore a second NACK for the same
patch and posting it a third time unchanged is not the best way to
make friends and influence people....

And given that you didn't respond to a single review comment I made
on the previous version of the patch, well, I have my doubts you are
going to respond this time, either.  In previous reviews comments I
have:
	- outlined exactly how to provide a minimally invasive patch
	  set that provides full namespace support as a first step
	  in getting XFS to support namespaces.
	- told you where the ondisk/in-memory boundaries are.
	- told you that certain IDs are filesystem internal and not
	  subject to namespaces.
	- asked questions about how filesystems utilities are
	  supposed to deal with namespaces (i.e. userspace impacts
	  of ioctl interface changes). 

And you haven't responded to any of them.  You can't selectively
ignore review comments you don't like and then magically expect the
reviewers to accept an almost-identical-but-even-more-broken patch
set the next time around.

> Given the number of ioctls that xfs supports it would be irresponsible to
> do anything except insist that kuids, kgids, and kprojids are used in all of
> in memory data structures of xfs, as otherwise it becomes trivially easy to
> miss a needed conversion with the advent of a new ioctl.

Eric, your rhetoric looks so fine and shiny on the wall, but it is
utterly worthless.  You're telling us that userspace interface are
absolutely necessary, but haven't provided any analysis, description
or justification so we can judge the impact of the changes or review
why you think the only way such changes can be made is your way.

Nor have you provided any regression tests to verify that this shiny
new namespace support is working as the maker has intended. IOWs,
I've got no idea what the impact of changing all the ioctls will be,
no way to verify it is correct and you sure as hell aren't going out
of your way to make it easy for us to understand the impact, either.

Further, I'm pretty sure that you are not even aware of the scope of
the issues that namespace awareness raise for some of these XFS
ioctls. I've previously asked some questions about behaviours of
them, but like most of my other review comments you have ignored
those questions.

So, before we go changing anything ioctl related, here's some
questions you need to answer:

	- if you run bulkstat, what do we do with inodes that
	  contain a ID owned by a namespace outside the current
	  namespace?

	- Can we even check the on-disk inode IDs are valid within a
	  specific namespace within the kernel?

	- open_by_handle() would appear to allow root in any
	  namespace to open any file in the filesystem it has a
	  valid handle for regardless of the namespace. Is this
	  allowable? The output of bulkstat can be fed directly to
	  open_by_handle(), so if bulkstat can return inodes outside
	  the namespace, open-by-handle can open them and we can do
	  invisible IO on them.

	- Further, we can extract and set attributes directly by
	  handle and, IIRC, that includes security/trusted namespace
	  attributes....

	- On the same measure, the handles used by XFS handle
	  interfaces are identical to NFS handles and use the same
	  code for decoding and dentry lookup. So, what do handle
	  restrictions mean for NFS servers?

	- have you considered that fs/fhandle.c raises many of these
	  same issues?

	- and seeing xfsdump and xfs_fsr use bulkstat and handles,
	  what do new limitations on these interfaces mean for these
	  utilities?

	- How does xfs_dump/xfs_restore work if we convert all ids
	  based on the current namespace? e.g. dump in one
	  namespace, restore in another.

	- How does xfs_dump/xfs_restore work if we *don't* convert
	  all ids (i.e. export the on-disk values)?

	- How do we document/communicate all these constraints/
	  behaviours to users who might be completely unaware of
	  them?

IOWs, simply converting IDs the ioctls take in or emit is only a
small part of the larger question of how they are supposed to behave
in namespace containers. These questions need to be answered *in
detail* and with *regression tests* before we accept any changes to
the ioctl interfaces.

Eric, I'm not trying to be difficult here - I'm holding the bar at
the same height as it gets held for any significant XFS change that
impacts userspace interfaces and behaviour. You don't maintain the
XFS code, so you can just walk away once namespaces are "done" and
not care that you've left a mess behind.

And if you leave a mess, I'm the person who will have to clean it
up. I don't want to have to clean up your mess, so I'm going to keep
saying no until you can introduce namespace support without making a
mess....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
