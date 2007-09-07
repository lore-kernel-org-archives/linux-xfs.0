Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 23:10:45 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.235])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l876Ad4p023911
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 23:10:42 -0700
Received: by wx-out-0506.google.com with SMTP id s9so365385wxc
        for <xfs@oss.sgi.com>; Thu, 06 Sep 2007 23:10:41 -0700 (PDT)
Message-ID: <9ee2fe770709062243u67956d26o7222435956213f0@mail.gmail.com>
Date: Fri, 7 Sep 2007 11:28:27 +0545
From: "kanishk rastogi" <kanishk.85@gmail.com>
Subject: Re: Need of inode->i_mutex in xfs_write()
In-Reply-To: <20070823225111.GW72985246@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9ee2fe770708210826n5952e727od0df16a5a7b267f0@mail.gmail.com>
	 <20070823225111.GW72985246@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On 8/24/07, David Chinner <dgc@sgi.com> wrote:
> On Tue, Aug 21, 2007 at 09:11:56PM +0545, kanishk rastogi wrote:
> > I was looking at the xfs_write code path in kernel 2.6.20 .......
> > I saw it acquiring inode->i_mutex .
> > Whats the need ?
> > What are we safegaurding inode for.
>
> See Documentation/filesystems/Locking and other files in that
> directory for what i_mutex is supposed to protect.
>
> XFS is different as it has it's own inodes and inode locks, but
> it still mostly uses i_mutex inteh accepted way.
>

xfs_write comes in file_operations->aio_write()
and the documentation doesnt say anything for it to acquire i_mutex in
that path.

I still fail to understand its usage.

Where i am going wrong.

regards
kanishk






> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
