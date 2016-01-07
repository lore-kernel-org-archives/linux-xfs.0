Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 385277F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 20:21:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 19D1C8F804C
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 18:21:46 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iEB476Lu7OzyDMvc for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 18:21:43 -0800 (PST)
Date: Thu, 7 Jan 2016 13:21:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lazytime implementation questions
Message-ID: <20160107022140.GM21461@dastard>
References: <20160104062219.GB19802@dastard>
	<20160105173604.GE18604@quack.suse.cz>
	<20160105225907.GE21461@dastard> <20160107010506.GB2866@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160107010506.GB2866@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Jan 06, 2016 at 08:05:06PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 06, 2016 at 09:59:07AM +1100, Dave Chinner wrote:
> > > So the intended semantics is:
> > > 1) fsync / sync / freeze / unmount will write the timestamp updates even
> > >    with lazytime. So unless crash happens, timestamps are guaranteed to be
> > >    consistent. Also sync / fsync guarantees all changes to get to disk.
> > > 2) We periodically write back timestamps (once per 24 hours) to avoid too
> > >    big timestamp inconsistencies in case of crash.
> > 
> > Ok, so it's supposed to be a delayed timestamp update mechanism
> > without any specific ordering guarantees, not an opportunistic
> > timestamp update mechanism.
> 
> There is an optimization which ext4 has which will update related
> timestamps when we write an inode table block, which is
> "opportunistic", but there is no guarantee that this will happen.

XFS used to do that, too, before we removed all that hackery when we
moved to logging timestamp updates unconditionally a few years ago.
I'm going to have to re-instate some of that code for lazytime, I
think.

> This is purely optional; other file systems don't have to do this, but
> it can be a win in that if related inodes are in the same 4k block,
> and we need to update, say, the index file one because we are changing
> i_size, but we were also doing non-allocating writes to the data file,
> then we might as well write out the timestamps for the data file at
> the same time, since this is "free".

*nod*. Explicit, optimised clustered inode writeback (rather than
purely opportunistic clustering via delayed buffer writeback) was
added to XFS way back in early 1999. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
