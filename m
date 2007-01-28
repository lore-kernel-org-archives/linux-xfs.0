Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Jan 2007 15:54:12 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0SNs2qw031932
	for <linux-xfs@oss.sgi.com>; Sun, 28 Jan 2007 15:54:05 -0800
Date: Mon, 29 Jan 2007 10:52:55 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [DISCUSS] xfs allocation bitmap method over linux raid
Message-ID: <20070128235255.GS33919298@melbourne.sgi.com>
References: <5d96567b0701232234y2ff15762sbd1aaada5c3a0a0@mail.gmail.com> <1169678294.18017.200.camel@edge> <5d96567b0701280232w17e1a187r95d2c59711799b1a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d96567b0701280232w17e1a187r95d2c59711799b1a@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: nscott@aconex.com, linux-xfs@oss.sgi.com

On Sun, Jan 28, 2007 at 12:32:23PM +0200, Raz Ben-Jehuda(caro) wrote:
> first many thanks to your reply.
> see bellow.
> 
> On 1/25/07, Nathan Scott <nscott@aconex.com> wrote:
> >Hi Raz,
> >
> >On Wed, 2007-01-24 at 08:34 +0200, Raz Ben-Jehuda(caro) wrote:
> >> David Hello.
> >> I have looked up in LKML and hopefully you are the one to ask in
> >> regard to xfs file system in Linux.
> 
> >
> >OOC, which one?  (would be nice to put an entry for your company
> >on the http://oss.sgi.com/projects/xfs/users.html page).
> >
> >> These servers demand high throughput from the storage.
> >> We applied XFS file system on our machines.
> >>
> >> A video server reads a file in a sequential manner. So, if a
> >
> >Do you write the file sequentially?  Buffered or direct writes?
> does not matter. even command like:
> dd if=/dev/zero of=/d1/xxx bs=1M count=1000
> will reveil extents of size modulo(stripe unit ) !=  0

Did you make the filesystem with a stripe unit set properly?
Can you post the output of 'xfs_info -n /path/to/mntpt'?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
