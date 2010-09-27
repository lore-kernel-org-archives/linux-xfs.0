Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8RKtugZ204672 for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 15:55:56 -0500
Received: from b.mx.filmlight.ltd.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id EE5A91D95646
	for <xfs@oss.sgi.com>; Mon, 27 Sep 2010 13:56:53 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (bongo.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id 5ct1FmzqxpE2V3et for
	<xfs@oss.sgi.com>; Mon, 27 Sep 2010 13:56:53 -0700 (PDT)
Subject: Re: Contiguous file sequences
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4CA018D9.1030803@sandeen.net>
References: <AANLkTikHqjvEGJb0XnNy+nz7+nHLVLwjF_wp5RZdk_1-@mail.gmail.com>
	<4C9A6298.106@sandeen.net>
	<AANLkTinz4rYCb8cHH69pYy-oPT-041y+DmVaWm3N_1hu@mail.gmail.com>
	<4CA018D9.1030803@sandeen.net>
Date: Mon, 27 Sep 2010 21:56:40 +0100
Message-Id: <1285621000.28107.294.camel@montana.filmlight.ltd.uk>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


On Sun, 2010-09-26 at 23:08 -0500, Eric Sandeen wrote:
> Daire Byrne wrote:
> > Eric,
> > 
> > On Wed, Sep 22, 2010 at 9:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> >> Daire Byrne wrote:
> >>> Hi,
> >>>
> >>> I have been trying to figure out how to lay down a file sequence (e.g.
> >>> images) such that they are guaranteed to always be contiguous on disk
> >>> (i.e. no block gaps between them).
> >> There's no mechanism to guarantee that.
> >>
> >> Why is this the goal, what are you trying to achieve?
> > 
> > I am essentially trying to play back a large frame sequence and trying
> > to minimise seeks as it can lead to sporadic slowdowns on a SATA based
> > RAID.
> 
> Ok - and you've really seen allocation patterns that cause the playback
> to slow down?  xfs_bmap information for a few sequential files that were
> this far off would be interesting to see.

We had a similar requirement which is what prompted the original
allocate near patch. Our problem's not reading an individual file
sequence, but reading several sequences simultaneously. If the system's
only just keeping up reading some number of files from one sequence
alternating with some number from another, the additional overhead of
mid-sequence seeks can push you over the edge. So you need a mechanism
to maintain a separate 'write cursor' for each sequence, which (give or
take) lays the files out contiguously.

> >> I'll just go back and ask what problem you're trying to solve?  There
> >> may be a better (i.e. currently existing) solution.
> > 

I notice that commit 2a82b8be8a8dacb48cb7371449a7a9daa558b4a8 added
"Concurrent Multi-File Data Streams" to XFS which seems to do just about
the same thing. The comments therein explain the problem well. I've not
used it though.

 Also, without some more complexity
> it'd still probably end up being a best effort rather than a guarantee,
> but some hints from userspace might be better than nothing.

The 'allocate near' code simply hooks into the 'extend an existing file'
allocator, so it will generally do something sensible but as you say, it's
best effort not a guarantee. But it turns out that (here, at least) that's
good enough.

--
Roger




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
