Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CGCImv004524 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 11:12:19 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BAE4EF0EE4
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 09:16:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OAwwQmlNoqvO70HC for <xfs@oss.sgi.com>;
	Mon, 12 Sep 2011 09:16:51 -0700 (PDT)
Date: Mon, 12 Sep 2011 12:12:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair segfaut in stage 6
Message-ID: <20110912161215.GA17798@infradead.org>
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E6A2B73.50503@nasza-klasa.pl>
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
To: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 05:06:27PM +0200, Bartosz Cisek wrote:
> W dniu 09.09.2011 14:01, Michael Monnerie pisze:
> 
> Thanks for reply :)
> 
> > Can you provide a metadump of that partition? By this, the devs can 
> > reproduce the bug on their machine, and resolve issues much quicker.
> 
> xfs_metadump -g /dev/cciss/c0d5p1 - | bzip2  > metadump.bz2
> 
> http://bartoszcisek.pl/metadump.bz2
> 
> > Which kernel and architecture are you on?
> 
> Linux hd-slave5 2.6.30-1-amd64 #1 SMP Tue Aug 18 17:39:23 CEST 2009
> x86_64 GNU/Linux

I've repaired the image fine using xfs_repair from the Debian testing
xfsprogs 3.1.5+nmu1 package.  It found two invalid blocks in a
directory, which look like the result from the hardware error you saw.

You should be able to just rebuild the current xfsprogs (from
testing/unstable or git) on Lenny and get the same result.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
