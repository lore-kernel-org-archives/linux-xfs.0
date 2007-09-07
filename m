Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Sep 2007 05:15:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l87CFF4p023224
	for <xfs@oss.sgi.com>; Fri, 7 Sep 2007 05:15:16 -0700
Date: Fri, 7 Sep 2007 22:15:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Need of inode->i_mutex in xfs_write()
Message-ID: <20070907121505.GX734179@sgi.com>
References: <9ee2fe770708210826n5952e727od0df16a5a7b267f0@mail.gmail.com> <20070823225111.GW72985246@sgi.com> <9ee2fe770709062243u67956d26o7222435956213f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ee2fe770709062243u67956d26o7222435956213f0@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: kanishk rastogi <kanishk.85@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Fri, Sep 07, 2007 at 11:28:27AM +0545, kanishk rastogi wrote:
> On 8/24/07, David Chinner <dgc@sgi.com> wrote:
> > On Tue, Aug 21, 2007 at 09:11:56PM +0545, kanishk rastogi wrote:
> > > I was looking at the xfs_write code path in kernel 2.6.20 .......
> > > I saw it acquiring inode->i_mutex .
> > > Whats the need ?
> > > What are we safegaurding inode for.
> >
> > See Documentation/filesystems/Locking and other files in that
> > directory for what i_mutex is supposed to protect.
> >
> > XFS is different as it has it's own inodes and inode locks, but
> > it still mostly uses i_mutex inteh accepted way.
> >
> 
> xfs_write comes in file_operations->aio_write()
> and the documentation doesnt say anything for it to acquire i_mutex in
> that path.

The i_mutex is supposed to be held across various calls into
generic code. See generic_file_aio_write() for the common
implementation of ->aio_write(). The entire write path is
supposed to be protected by the i_mutex.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
