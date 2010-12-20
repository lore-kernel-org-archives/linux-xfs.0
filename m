Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBK2sGv9043454 for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 20:54:17 -0600
Received: from mail.pzystorm.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 255A0208AF1
	for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 18:56:12 -0800 (PST)
Received: from mail.pzystorm.de (mail.pzystorm.de [188.40.193.4]) by
	cuda.sgi.com with ESMTP id kPpWkqZYGu79T65t for
	<xfs@oss.sgi.com>; Sun, 19 Dec 2010 18:56:12 -0800 (PST)
Received: from hnvr-4d07aad7.pool.mediaways.net ([77.7.170.215]
	helo=[192.168.0.72])
	by mail.pzystorm.de with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69) (envelope-from <xfs@pzystorm.de>) id 1PUVuz-00088K-7g
	for xfs@oss.sgi.com; Mon, 20 Dec 2010 03:56:11 +0100
Message-ID: <4D0EC5C5.2070407@pzystorm.de>
Date: Mon, 20 Dec 2010 03:56:05 +0100
From: Kevin Richter <xfs@pzystorm.de>
MIME-Version: 1.0
Subject: Re: Problem with XFS on USB 2TB HD
References: <4D0C9A4F.4040108@pzystorm.de> <20101220001024.GH5193@dastard>
In-Reply-To: <20101220001024.GH5193@dastard>
Reply-To: xfs@pzystorm.de
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
To: xfs@oss.sgi.com

Thanks a lot for your responses.

> I don't have a solution to your problem unfortunately.  Keep in mind you
> posted this problem on a weekend, and one week before Christmas no less.
>  Your timing is not optimal for receiving a prompt response.  It's
> possible you may have to wait until Monday for help. :(

No problem at all. It can wait. My backup drive has indeed no real
important stuff on it - just 100% backups from other disks.
I'd just use this issue as an opportunity to try out the xfs repair
functionality.


>> It is a problem with the interaction of LUKS, XFS and USB?
>
> You are encrypting the external drive? That would explain the
> garbage then - a single bit error in a sector will render it
> completely incorrect....

Yes, I do.
aes-cbc-essiv:sha256
If the connection breaks while writing a block, only this block should
be garbled? This should be 256 bit in this case, shouldn't it?


>> ERROR: The filesystem has valuable metadata changes in a log which
>> > needs to be replayed.
> Given this message, you'll have to run xfs_repair with the zero log
> option ( -L ). This is dangerous, but it can't get much worse anyway.
> 
> Run xfs_repair -L /device , you should be able to mount your filesystem
> afterwards, however any data under change at the time of failure will
> most probably be lost.

OK, if there is no way around...

xfs_repair -L /dev/mapper/backup has run a few minutes and has printed a
lot of screens. After lines like

disconnected inode 4083355215, moving to lost+found
disconnected dir inode 4083355216, moving to lost+found

or

Phase 7 - verify and correct link counts...
resetting inode 128 nlinks from 2 to 3
...
b767c6f0: Badness in key lookup (length)
bp=(bno 0, len 4096 bytes) key=(bno 0, len 512 bytes)
done

it has succeeded in this way, that it is now at least possible to mount
the volume. But there is only the lost+found folder in there which
contains again a lot of folders and files named with numbers. Looking
deeper in these directories all the names of further files or
directories are preserved. Phew! Only the fs structure in the first
level seems to be garbled.

Checking the size of the lost+found folder, (nearly) everything seems to
be there.

Now I am asking myself: If only one 256 bit block is garbled (f. ex.
because of a terminated usb connection) all the directory and file names
in the first level gets garbled? Wicked!



Cheers,
Kevin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
