Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 03:52:21 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1OBqDkI012896
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 03:52:15 -0800
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AB8D60F582
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 03:52:39 -0800 (PST)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.235]) by cuda.sgi.com with ESMTP id XM6RFePmfUJCONA8 for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 03:52:39 -0800 (PST)
Received: by wr-out-0506.google.com with SMTP id 50so1927829wra.18
        for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 03:52:39 -0800 (PST)
Message-ID: <2db2c6b80802240352o301a0d15q991efb97a1dbff82@mail.gmail.com>
Date: Sun, 24 Feb 2008 12:52:38 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: Re: xfs I/O error
In-Reply-To: <20080224090106.GD27124@teal.hq.k1024.org>
MIME-Version: 1.0
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
	 <20080223220818.GC27124@teal.hq.k1024.org>
	 <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com>
	 <20080224090106.GD27124@teal.hq.k1024.org>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>, xfs@oss.sgi.com

smartctl -t offline is i think scheduling a SMART test

i will try what you say, but there is no way to force XFS to not unmount
filesystem if it finds out I/O error?

also, i didnt edit any info, it was just all i got from messages log

2008/2/24, Iustin Pop <iusty@k1024.org>:
>
> On Sat, Feb 23, 2008 at 11:14:32PM +0100, Rekrutacja119 wrote:
> > so i should use the list i got from badblocks with dd but with bs=1024?
> are
> > you sure? i'm not sure what is my block size, but xfs_info says this:
>
> the block size of the filesystem has no relation to the block size
> badblocks uses in checking the block device.
> >
> [...]
>
> >
> > i think i made it with 4K stack size ... well anyways, i should use the
> list
> > i got earlier and just try dd but with bs=1024... ? don't want to erase
> more
> > than i have to. (i want to do it so i can smartctl -t offline /dev/sdb
> then,
> > so maybe it will somehow see that these blocks are broken and mark them)
>
>
> I don't understand what do you want to do with smartctl at all. How
> would offlining the disk would help?
>
> Again, I would:
>   - take the block list given by badblocks
>   - verify that each block can't be read  first via dd if=/dev/...
>     of=/dev/null bs=1024 count=1 seek=NUMBER_FROM_BADBLOCK
>   - if confirmed that you got the right 'bad' blocks, use that for dd
>     with bs=1024 to write zeroes over them
>
> As Eric confirmed, you probably already destroyed some good data on the
> drive.
>
> regards,
>
> iustin
>


[[HTML alternate version deleted]]
