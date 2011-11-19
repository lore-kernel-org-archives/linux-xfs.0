Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIjAji074699 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:45:13 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EFDA1DBE975
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 10:45:08 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cdwkGE4ZrM3TznMg for <xfs@oss.sgi.com>;
	Sat, 19 Nov 2011 10:45:08 -0800 (PST)
Date: Sat, 19 Nov 2011 13:45:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfsprogs: allow linking against libtcmalloc
Message-ID: <20111119184507.GA11208@infradead.org>
References: <20111114155742.285135418@bombadil.infradead.org>
	<20111114160217.591812422@bombadil.infradead.org>
	<201111180804.06413.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201111180804.06413.arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Fri, Nov 18, 2011 at 08:04:06AM +0100, Arkadiusz Mi??kiewicz wrote:
> On Monday 14 of November 2011, Christoph Hellwig wrote:
> > Allow linking against the libtcmalloc library from Google's performance
> > tools, which at least for repair reduces the memory usage dramatically.
> 
> Should -fno-builtin-malloc be also used?

The documentation suggests that it's not strictly required, but probably
a good idea.  I'll fold this into the next version, together with your
autoconf updates from irc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
