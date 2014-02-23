Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D94A37F51
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 15:38:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBA268F8033
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 13:38:23 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WVj6W76tc3CUR6re for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 13:38:21 -0800 (PST)
Date: Mon, 24 Feb 2014 08:36:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
Message-ID: <20140223213606.GE4317@dastard>
References: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
	<20140222140625.GD26637@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140222140625.GD26637@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, bpm@sgi.com, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Ashish Sangwan <a.sangwan@samsung.com>

On Sat, Feb 22, 2014 at 09:06:25AM -0500, Theodore Ts'o wrote:
> On Wed, Feb 19, 2014 at 01:37:43AM +0900, Namjae Jeon wrote:
> > +	/*
> > +	 * There is no need to overlap collapse range with EOF, in which case
> > +	 * it is effectively a truncate operation
> > +	 */
> > +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> > +	    (offset + len >= i_size_read(inode)))
> > +		return -EINVAL;
> > +
> 
> I wonder if we should just translate a collapse range that is
> equivalent to a truncate operation to, in fact, be a truncate
> operation?

Trying to collapse a range that extends beyond EOF, IMO, is likely
to only happen if the DVR/NLE application is buggy. Hence I think
that telling the application it is doing something that is likely to
be wrong is better than silently truncating the file....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
