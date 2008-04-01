Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 17:35:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m310Z2mL002567
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 17:35:06 -0700
Date: Tue, 1 Apr 2008 10:35:18 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: free space problem
Message-ID: <20080401003518.GK103491721@sgi.com>
References: <20080331093951.100ec125@galadriel.home> <20080331173724.24BB68D1DF4@cuda.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080331173724.24BB68D1DF4@cuda.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Cc: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

On Mon, Mar 31, 2008 at 07:36:56PM +0200, Huszár Viktor Dénes wrote:
> -----Original Message-----
> From: Emmanuel Florac [mailto:eflorac@intellique.com] 
> Sent: Monday, March 31, 2008 9:40 AM
> To: Huszár Viktor Dénes; xfs@oss.sgi.com
> Subject: Re: free space problem
> 
> Le Mon, 31 Mar 2008 02:31:16 +0200 vous écriviez:
> 
> >Then maybe you simply ran out of inodes. It's common if you have lots
> >of small files. There is a way to increase the number of inodes but I
> >don't remember it right now.
> --
> No, unfortunately not. There are not many small files and the inode usage is
> 1%. See.

Yes, but if you have fragemented free space then it is possible that there
are not enough free extents large enough (or aligned correctly) to
allocate more inodes. The number of "free inodes" reported doesn't take
this into account; it only looks at the number of free blocks and converts
that to a theoretical number of inodes that could be allocated in that
space (i.e. it assumes perfect fit and no waste). 

In this "not quite full filesystem" situation, you can write data to the
filesystem, but any attempt to create a new inode (new file, directory,
etc) will fail with ENOSPC. This sounds like the symptoms you are
reporting....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
