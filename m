Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 15:51:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NMpK4p005861
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 15:51:22 -0700
Date: Fri, 24 Aug 2007 08:51:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Need of inode->i_mutex in xfs_write()
Message-ID: <20070823225111.GW72985246@sgi.com>
References: <9ee2fe770708210826n5952e727od0df16a5a7b267f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ee2fe770708210826n5952e727od0df16a5a7b267f0@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: kanishk rastogi <kanishk.85@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 21, 2007 at 09:11:56PM +0545, kanishk rastogi wrote:
> I was looking at the xfs_write code path in kernel 2.6.20 .......
> I saw it acquiring inode->i_mutex .
> Whats the need ?
> What are we safegaurding inode for.

See Documentation/filesystems/Locking and other files in that
directory for what i_mutex is supposed to protect.

XFS is different as it has it's own inodes and inode locks, but
it still mostly uses i_mutex inteh accepted way.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
