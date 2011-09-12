Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CFwg0m004024 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 10:58:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F1111F0DF44
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 08:58:41 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	fqWqr8uKtRK7E6Du for <xfs@oss.sgi.com>;
	Mon, 12 Sep 2011 08:58:41 -0700 (PDT)
Date: Mon, 12 Sep 2011 11:58:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_repair segfaut in stage 6
Message-ID: <20110912155838.GA14744@infradead.org>
References: <4E69D1B9.8070201@nasza-klasa.pl> <201109091401.31422@zmi.at>
	<4E6A2B73.50503@nasza-klasa.pl> <4E6E285A.5090905@nasza-klasa.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E6E285A.5090905@nasza-klasa.pl>
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

On Mon, Sep 12, 2011 at 05:42:18PM +0200, Bartosz Cisek wrote:
> W dniu 09.09.2011 17:06, Bartosz Cisek pisze:
> 
> >> Can you provide a metadump of that partition? By this, the devs can 
> >> reproduce the bug on their machine, and resolve issues much quicker.
> > 
> > xfs_metadump -g /dev/cciss/c0d5p1 - | bzip2  > metadump.bz2
> > 
> > http://bartoszcisek.pl/metadump.bz2
> 
> Is there anything more I can get from failed partition to help solving
> this bug? Or it can be safely recreated?

Sorry for not replying earlier Bart.  I'm downloading the metadump image
now and will look at it.

Do you still have the kernel logs from when the issue happened?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
