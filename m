Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06Now3O022694 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 17:50:58 -0600
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80C7317B541B
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 15:50:57 -0800 (PST)
Received: from wa-out-1112.google.com (wa-out-1112.google.com
	[209.85.146.180]) by cuda.sgi.com with ESMTP id
	8LRv5dPbS5xlUz2R for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 15:50:57 -0800 (PST)
Received: by wa-out-1112.google.com with SMTP id j5so4577919wah.4
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2009 15:50:56 -0800 (PST)
Message-ID: <b75ef8170901061526j3671c4d9qbdb16459789ab2d4@mail.gmail.com>
Date: Wed, 7 Jan 2009 01:26:11 +0200
From: "Gergely Soos" <sogerc1@gmail.com>
Subject: Re: need help to repair XFS partition
In-Reply-To: <20090106230930.GA24703@infradead.org>
MIME-Version: 1.0
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
	<49638190.3070803@sandeen.net>
	<b75ef8170901061004n75f52cffg7f810a51aca21ff@mail.gmail.com>
	<4963A706.8000500@sandeen.net>
	<b75ef8170901061351madb546flbc1631bc55cd4412@mail.gmail.com>
	<4963D320.9010000@sandeen.net>
	<b75ef8170901061431i68f8ebdey3ab08ea3dec9c079@mail.gmail.com>
	<4963DDD2.4030501@sandeen.net>
	<b75ef8170901061454v76081ca8x6f87e4bf14eb8491@mail.gmail.com>
	<20090106230930.GA24703@infradead.org>
Content-Disposition: inline
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
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

I want to thank everybody for the help, especially for Eric.
The solution was:
fdisk /dev/hdd
then go to expert mode (x)
print the partition table (p)
move the beginning of the partition (b) - where I increased the start number
by 63
write to disk and exit (w)
Reboot and everything is fine.
I'm so happy :)

Gergely

PS: I made a typo in my previous letter. Instead of 5132575420 I should have
written 5132574720 in case anybody wonders...

On Wed, Jan 7, 2009 at 1:09 AM, Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Jan 07, 2009 at 12:54:52AM +0200, Gergely Soos wrote:
> > Unfortunately it's not that simple. Actually that HDD has two partitions
> and
> > hdd2 is physically before hdd1 (they are reversed in the partition
> table),
> > so I absolutely need to move the start of the partition to the address
> which
> > is 63 sectors more than it is now.
> > Currently it starts at absolute byte position 5132575420 and it should
> start
> > at 5132606976.
> > Do you know what program is capable of doing this? I looked for MBR
> > documentation and in the partition table it is stored in CHS format
> > so it would be really hard (at least for me) to do it by hand.
>
> If you want to mount the partitions once you can creat a loop device
> ontop of you disk device and use the -o option, e.g.
>
>
> losetup -o 5132606976 /dev/loop0 /dev/hdd1
>
> and then mount /dev/loop0.  But that's not really something I'd want
> to use for a longer time..
>


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
