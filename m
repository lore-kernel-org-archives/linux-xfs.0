Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBLBKROF013463 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 05:20:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7AD6814709FF
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:22:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lhOEY0iOu6l2BCbh for
	<xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:22:25 -0800 (PST)
Date: Tue, 21 Dec 2010 06:22:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add test 248: Check filesystem FITRIM implementation
Message-ID: <20101221112224.GA30242@infradead.org>
References: <1291996407-26251-1-git-send-email-lczerner@redhat.com>
	<20101220174146.GA32680@infradead.org>
	<alpine.LFD.2.00.1012211132450.6010@dhcp-lab-213.englab.brq.redhat.com>
	<AANLkTi=2J5fi1uQazbzsEQ+658DhoqRaxHuMPN9JPVqW@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=2J5fi1uQazbzsEQ+658DhoqRaxHuMPN9JPVqW@mail.gmail.com>
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
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

On Tue, Dec 21, 2010 at 03:03:03AM -0800, Phil Karn wrote:
> What is the plan for TRIM support in XFS? I don't see any mention in the
> 2.6.36.2 sources, so I guess the code you guys have been discussing must not
> be considered stable yet.
>
> How will it eventually work? Will the filesystem automatically issue the
> commands to the drive whenever a file is deleted, or will it always require
> some sort of prodding from a userspace program?


I submitted a patch to add FITRIM support, which should go into 2.6.38
if I get a positive review.  That is the variant that is triggered by
the fstim userspace program and what the test we're discussing here
exercises.  I've also prototyped various forms of online discard, but
none of them is quite ready yet.  I've started porting some allocator
patches from Dave forward, which are a requirement for reliable online
discard.  After that I need to decide which of the variants we'll
actually use. So far the "dumb" discard at transaction commit time shows
the best results.

> And what kind of experiences are people having with XFS on current SSDs? I
> just put an Intel drive in my newly upgraded box and I'm wondering if this
> blazing performance will screech to a halt when my cumulative writes exceed
> its 120 GB capacity. Does anyone have a standalone "drive optimizer" that
> understands XFS, i.e, that can examine an unmounted file system and issue
> the appropriate TRIM commands for every block on the free list?

The intel SSDs do quite fine without constant trimming, as do most
current SSDs.  I only know of one sample that areally needs periodic
trims, but AFAIK it's not generally available yet (sorry, can't name the
vendor due to NDAs).  But even with the current ones a TRIM once in a
while is useful, but about once every couple of weeks is enough.  For a
system not constantly loaded you can use Mark Lord's wiper.sh script,
but be aware it only works on disks / partitions and not on LVM volumes.
Once the FITRIM support is in you can use that for the same purpose,
with the benefit of also working over LVM, and also working nicely on
a system under heavy use, as it doesn't have to allocate all free space
as the userspace hack done by wiper.sh does.

> Or is the Intel drive somehow really good at avoiding write amplification
> even without TRIM help from the file system? I've heard that may be the
> case, but I don't understand how that can be.

No, the Intel disks actually degrade a lot after heavy use.
Unfortunately even regular trims don't always seem to solve this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
