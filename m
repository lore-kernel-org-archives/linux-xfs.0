Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 01:07:45 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1O97bwK002594
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:07:41 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 176FDEA3E36
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:08:04 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.171]) by cuda.sgi.com with ESMTP id yCvr3rWUR9KKEp2J for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:08:04 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so652005ugd.20
        for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 01:08:03 -0800 (PST)
Date: Sun, 24 Feb 2008 10:01:06 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: xfs I/O error
Message-ID: <20080224090106.GD27124@teal.hq.k1024.org>
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com> <20080223220818.GC27124@teal.hq.k1024.org> <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db2c6b80802231414m38f70795n7f24fea1a40195df@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 23, 2008 at 11:14:32PM +0100, Rekrutacja119 wrote:
> so i should use the list i got from badblocks with dd but with bs=1024? are
> you sure? i'm not sure what is my block size, but xfs_info says this:
the block size of the filesystem has no relation to the block size
badblocks uses in checking the block device.
> 
[...]
> 
> i think i made it with 4K stack size ... well anyways, i should use the list
> i got earlier and just try dd but with bs=1024... ? don't want to erase more
> than i have to. (i want to do it so i can smartctl -t offline /dev/sdb then,
> so maybe it will somehow see that these blocks are broken and mark them)

I don't understand what do you want to do with smartctl at all. How
would offlining the disk would help?

Again, I would:
  - take the block list given by badblocks
  - verify that each block can't be read  first via dd if=/dev/...
    of=/dev/null bs=1024 count=1 seek=NUMBER_FROM_BADBLOCK
  - if confirmed that you got the right 'bad' blocks, use that for dd
    with bs=1024 to write zeroes over them

As Eric confirmed, you probably already destroyed some good data on the
drive.

regards,
iustin
