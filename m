Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Mar 2007 19:24:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2L2Oh6p019627
	for <xfs@oss.sgi.com>; Tue, 20 Mar 2007 19:24:45 -0700
Date: Wed, 21 Mar 2007 13:24:23 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS bug???
Message-ID: <20070321022423.GB32602149@melbourne.sgi.com>
References: <87y7lrmnra.wl%peterc@chubb.wattle.id.au> <1174439821.5051.314.camel@edge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174439821.5051.314.camel@edge>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: Peter Chubb <peterc@gelato.unsw.edu.au>, xfs@oss.sgi.com

On Wed, Mar 21, 2007 at 12:17:01PM +1100, Nathan Scott wrote:
> On Wed, 2007-03-21 at 11:41 +1100, Peter Chubb wrote:
> > Hi Nathan,
> > 	Our main backup machine is showing XFS errors.  Any ideas how
> > to fix?  
> 
> Hi Peter,
> 
> I don't have as much time to spend on XFS as I used to, so better to
> contact the list at SGI (CC'd).  What kernel version are you running
> there?  Looks like a corrupt directory - was this machine exposed to
> the 2.6.17 corruption issue perhaps?
> >
> > Mar 20 08:12:29 bitburger kernel: Filesystem "dm-0": XFS internal
> > error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xf91d5d60

Oh, yet another report of this. Peter, can you run with the patch
posted here:

http://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg105975.html

And if you trip over the problem again it will tell us a bit
more about what triggered the error that caused the shutdown.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
