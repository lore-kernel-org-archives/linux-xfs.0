Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AEBAB7FB3
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 08:42:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A9A18F8040
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 06:42:19 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id RNgXu2ZWcEpnGjuh (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 06:42:17 -0700 (PDT)
Date: Thu, 25 Sep 2014 09:41:37 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140925134136.GE4592@thunk.org>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
	<20140925075912.GG4758@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925075912.GG4758@dastard>
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
Cc: adilger@dilger.ca, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Sep 25, 2014 at 05:59:12PM +1000, Dave Chinner wrote:
> > Also I'm afraid we may quickly run out of
> > 32 available flags in xflags so we'd need to extend that. But all this
> > seems to be doable.
> 
> The struct fsxattr was designed to be extensible - it has unused
> padding and enough space in the flags field to allow us to
> conditionally use that padding....

I agree that it would be useful for ext4 to support as much of the
XFS_IOC_GETXATTR/XFS_IOC_SETATTR as would make sense for ext4, and to
use that to set/get the project ID.  (And that we should probably do
that as a separate set of patches that we could potentially go into
ext4 ahead of the project quota while it is undergoing testing and
review.)

A few questions of Dave and other XFS folks:

1) If we only implement a partial set of the flags or other
functionality, are there going to be tools that get confused?  i.e.,
are there any userspace programs that will test for whether the ioctl
is supported, and then assume that some minimal set of functionality
must be implemented?

2) Unless I'm missing something, there is nothing that enforces that
fsx_pad must be zero.  I assume that means that the only way you can
expand use of fields into that space is via a flag bit being consumed?

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
