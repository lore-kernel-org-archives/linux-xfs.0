Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7ALQsI053349 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 04:21:28 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 848B11CEA842
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 02:21:22 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sJFcmeK8KbFyYZqr for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 02:21:22 -0800 (PST)
Date: Mon, 7 Nov 2011 05:21:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Online TRIM/discard performance impact
Message-ID: <20111107102121.GA2891@infradead.org>
References: <CAMYYbY7=tRU1bmHkeBMesSC1jgXXz7J8-eUFm5VenVam3g1+nA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMYYbY7=tRU1bmHkeBMesSC1jgXXz7J8-eUFm5VenVam3g1+nA@mail.gmail.com>
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
To: Martin Rusko <martin.rusko@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Nov 05, 2011 at 09:07:05PM +0100, Martin Rusko wrote:
> SSD drive in question is one of the latest with SF-2281 chipset. I
> expected, that TRIM function will just schedule sectors for garbage
> collection, which happens some time later (during which drive can be
> potentially slower). Trying the same tests with ext4 filesystem, it
> got following numbers.

That's unfortunately not how it works - the TRIM command always drains
the whole queue of outstanding requests, and thus has a fairly severe
impact on performance.  We could reduce it a bit by using vectored
trims like Windows does, but the Linux blocklayer doesn't have the
infrastructure for that yet.

Your workload will remove a lot of inode clusters on XFS, while ext4
never deletes inodes. Using the ikeep mount option for XFS (can't be
set during remount) should speed the performance with discard for
your workload up a lot.  I would still recommand to do a periodic
fstrim run instead, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
