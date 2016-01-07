Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 131C47F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 19:05:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C2D8AC003
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 17:05:12 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id YytEKWkNFZ93KYrr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jan 2016 17:05:10 -0800 (PST)
Date: Wed, 6 Jan 2016 20:05:06 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: lazytime implementation questions
Message-ID: <20160107010506.GB2866@thunk.org>
References: <20160104062219.GB19802@dastard>
	<20160105173604.GE18604@quack.suse.cz>
	<20160105225907.GE21461@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160105225907.GE21461@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed, Jan 06, 2016 at 09:59:07AM +1100, Dave Chinner wrote:
> > So the intended semantics is:
> > 1) fsync / sync / freeze / unmount will write the timestamp updates even
> >    with lazytime. So unless crash happens, timestamps are guaranteed to be
> >    consistent. Also sync / fsync guarantees all changes to get to disk.
> > 2) We periodically write back timestamps (once per 24 hours) to avoid too
> >    big timestamp inconsistencies in case of crash.
> 
> Ok, so it's supposed to be a delayed timestamp update mechanism
> without any specific ordering guarantees, not an opportunistic
> timestamp update mechanism.

There is an optimization which ext4 has which will update related
timestamps when we write an inode table block, which is
"opportunistic", but there is no guarantee that this will happen.

This is purely optional; other file systems don't have to do this, but
it can be a win in that if related inodes are in the same 4k block,
and we need to update, say, the index file one because we are changing
i_size, but we were also doing non-allocating writes to the data file,
then we might as well write out the timestamps for the data file at
the same time, since this is "free".

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
