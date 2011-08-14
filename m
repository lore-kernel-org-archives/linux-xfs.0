Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EG9WPN245280 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 11:09:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCB2E53B687
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 09:09:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UE07xCGHag0kPz8g for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 09:09:30 -0700 (PDT)
Date: Sun, 14 Aug 2011 12:09:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests #62 broken on ext4
Message-ID: <20110814160925.GA29428@infradead.org>
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
	<20110813201419.GA6442@infradead.org>
	<20110814004417.GA3524@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814004417.GA3524@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com

On Sat, Aug 13, 2011 at 08:44:17PM -0400, Ted Ts'o wrote:
> I see there's an sort command at the very end of _extend_test_bed(), I
> presume we should also add a similar "LC_COLLATE=POSIX sort" to the
> other "find" command pipelines, and it's easy enough to filter out the
> lost+found directory by adding a "! -name lost+found".

A patch from you or Stefan would be very welcome.  Note that at least
for btrfs I see problems with the user.name2 attribute in that test too,
so it might be a bit of effort to sort out what actually is going on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
