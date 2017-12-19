Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22148 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751013AbdLSUoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Dec 2017 15:44:54 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1eROks-00058S-7e
        for linux-xfs@vger.kernel.org; Wed, 20 Dec 2017 07:44:50 +1100
Date: Wed, 20 Dec 2017 07:44:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: fallocate behavior on -ENOSPC for blocks past EOF
Message-ID: <20171219204450.GY4094@dastard>
References: <20171213161611.53oavmzhnsum2fqc@odin.usersys.redhat.com>
 <20171213212906.GA5858@dastard>
 <20171219121117.72yd4iio3iaeaq3b@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219121117.72yd4iio3iaeaq3b@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Tue, Dec 19, 2017 at 01:11:17PM +0100, Carlos Maiolino wrote:
> Hi Dave,
> 
> On Thu, Dec 14, 2017 at 08:29:06AM +1100, Dave Chinner wrote:
> > On Wed, Dec 13, 2017 at 05:16:11PM +0100, Carlos Maiolino wrote:
> > > We have talked a bit about it on irc before but iirc we didn't end on any
> > > conclusion about it.
> > > 
> > > Current fallocate behavior on XFS in case it hits -ENOSPC in the middle of the
> > > reservation is kind of weird now when these new blocks are allocated past EOF.
> > > 
> > > We end up not changing the i_size to match the partial blocks allocated even if
> > > fallocate is not called with KEEP_SIZE.
> > > 
> > > Such behavior is confusing some users of fallocate, and I've been talking to
> > > Eric if wouldn't be better to update the i_size to match the partially allocated
> > > blocks IF KEEP_SIZE has not been used.
> > 
> > What's the confusion? fallocate is supposed to provide the backing
> > for posix_fallocate(), which either succeeds completely or returns
> > an error. posix_fallocate() specifically states that:
> > 
> > 	If the offset+ len is beyond the current file size, then
> > 	posix_fallocate() shall adjust the file size to offset+ len.
> > 	Otherwise, the file size shall not be changed.
> > 
> > (http://pubs.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html)
> > 
> > IOWs, setting the file size to anything other than offset+len
> > is not allowed (it's a "shall" definition which means we must follow
> > that exact behaviour), and hence on failure we have only two choices:
> > 
> > 	a) lie to the user and extend the file even though we didn't
> > 	preallocate all the space; or
> > 
> > 	b) don't change the file size so there's no visible change
> > 	to the file on failure.
> > 
> > We've chosen b) when fallocate fails for *any reason*. IOWs, the
> > file appears unchanged to the user on failure so they don't have to
> > handle undoing a failed partial operation.
> > 
> > > I know though that fallocate behavior is kind of undefined in this case, but I
> > 
> > Seems pretty clearly defined to me :/
> 
> I'm still not 100% convinced this behavior can be said as defined. Might be me
> overlooking too much into it or just stupidity from my part, but as you said
> above, we have 2 options: Lie to the user and partially extend the file

No, I didn't say "partially extend the file". I mean we *fully
extend* the file and lie about it all being preallocated. We have to
match the specified success or failure conditions exactly, not make
up our own.

> or don't
> change the file size. Which still looks like to me as an undefined behavior,
> once, fallocate users must know how the underlying filesystem is handling
> fallocate failures.
> 
> I shouldn't but :) Ext4 uses the 'a' option, while xfs uses 'b' option.

Ext4 violates the specification of posix_fallocate() on failure,
and so really needs to be fixed.

> Not
> saying any of them are wrong,

I am.

> > I think, though, this is a side issue and really doesn't matter when
> > it comes to how fallocate should behave on failure.
> 
> I think it does. The user fallocate X bytes beyond EOF and at some point it
> fails with ENOSPC. In one filesystem the file size is extended by Y bytes
> related to the partially fallocate'd blocks. In another the file size isn't
> extended at all, but the blocks are still there, consuming space on the
> filesystem, which, depending on the size of the fallocate, it can be a large
> part of the filesystem that will be occupied by pre-allocated blocks during a
> failure in the middle of fallocate(), which can certainly make users confused.
>
> I am starting to thing that the best approach after a failed fallocate() is to
> truncate the file to the original size, deallocating any possible space
> partially pre-allocated during fallocate. At least that's how I'd use this :)

That's not side-effect free, either - it will remove other
*successful* preallocation beyond EOF that has already been made,
and so writes into a range of a previous preallocation could now
fail with ENOSPC.... Also, without careful implementation of the
failure case, the truncate could race with other concurrent
operations that extend the file size and that would be bad...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
