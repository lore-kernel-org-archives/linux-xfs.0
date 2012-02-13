Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DLGxpZ042657 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 15:16:59 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6fVLO2qPP1opneTW (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 13:16:55 -0800 (PST)
Date: Mon, 13 Feb 2012 16:16:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120213211654.GA20192@infradead.org>
References: <20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
	<20120213172937.GA25248@infradead.org>
	<4F394E10.9000804@cape-horn-eng.com>
	<20120213180220.GA24163@infradead.org>
	<4F395134.8030202@cape-horn-eng.com>
	<20120213181012.GA27962@infradead.org>
	<4F395B1A.7010709@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F395B1A.7010709@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 07:48:58PM +0100, Richard Ems wrote:
> I already updated to 3.2.4 and started the same "find dir" command again
> that previously took 100 min to run. It has been running now for over 30
> min ...
> 
> Should this "find" run time also improve ?

No, not by that change anyway.

> Or will only unlink run time improve ?

Yes.

> Do I have to mount the XFS partition with some new/old/special option?

I'd have to look into it in more detail.  IIRC you said you're using
RAID6 which can be fairly nasty for small reads.  Did you use the
inode64 mount option on the filesystem?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
