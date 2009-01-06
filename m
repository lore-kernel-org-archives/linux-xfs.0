Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06N9Wgb020970 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 17:09:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A49CC68795
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 15:09:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id tJQICthG9LHmYUYz for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2009 15:09:32 -0800 (PST)
Date: Tue, 6 Jan 2009 18:09:30 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: need help to repair XFS partition
Message-ID: <20090106230930.GA24703@infradead.org>
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
	<49638190.3070803@sandeen.net>
	<b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
	<4963A706.8000500@sandeen.net>
	<b75ef8170901061351madb546flbc1631bc55cd4412@mail.gmail.com>
	<4963D320.9010000@sandeen.net>
	<b75ef8170901061431i68f8ebdey3ab08ea3dec9c079@mail.gmail.com>
	<4963DDD2.4030501@sandeen.net>
	<b75ef8170901061454v76081ca8x6f87e4bf14eb8491@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b75ef8170901061454v76081ca8x6f87e4bf14eb8491@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Gergely Soos <sogerc1@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jan 07, 2009 at 12:54:52AM +0200, Gergely Soos wrote:
> Unfortunately it's not that simple. Actually that HDD has two partitions and
> hdd2 is physically before hdd1 (they are reversed in the partition table),
> so I absolutely need to move the start of the partition to the address which
> is 63 sectors more than it is now.
> Currently it starts at absolute byte position 5132575420 and it should start
> at 5132606976.
> Do you know what program is capable of doing this? I looked for MBR
> documentation and in the partition table it is stored in CHS format
> so it would be really hard (at least for me) to do it by hand.

If you want to mount the partitions once you can creat a loop device
ontop of you disk device and use the -o option, e.g.


losetup -o 5132606976 /dev/loop0 /dev/hdd1

and then mount /dev/loop0.  But that's not really something I'd want
to use for a longer time..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
