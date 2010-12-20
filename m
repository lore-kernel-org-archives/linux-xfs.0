Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBK4nY3l062018 for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 22:49:35 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E072204A5E
	for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 20:51:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	ry69NxKWpfXrWgMe for <xfs@oss.sgi.com>;
	Sun, 19 Dec 2010 20:51:29 -0800 (PST)
Date: Mon, 20 Dec 2010 15:51:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with XFS on USB 2TB HD
Message-ID: <20101220045126.GK5193@dastard>
References: <4D0C9A4F.4040108@pzystorm.de> <20101220001024.GH5193@dastard>
	<4D0EC5C5.2070407@pzystorm.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D0EC5C5.2070407@pzystorm.de>
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
To: Kevin Richter <xfs@pzystorm.de>
Cc: xfs@oss.sgi.com

On Mon, Dec 20, 2010 at 03:56:05AM +0100, Kevin Richter wrote:
> Thanks a lot for your responses.
> 
> > I don't have a solution to your problem unfortunately.  Keep in mind you
> > posted this problem on a weekend, and one week before Christmas no less.
> >  Your timing is not optimal for receiving a prompt response.  It's
> > possible you may have to wait until Monday for help. :(
> 
> No problem at all. It can wait. My backup drive has indeed no real
> important stuff on it - just 100% backups from other disks.
> I'd just use this issue as an opportunity to try out the xfs repair
> functionality.
> 
> 
> >> It is a problem with the interaction of LUKS, XFS and USB?
> >
> > You are encrypting the external drive? That would explain the
> > garbage then - a single bit error in a sector will render it
> > completely incorrect....
> 
> Yes, I do.
> aes-cbc-essiv:sha256
> If the connection breaks while writing a block, only this block should
> be garbled? This should be 256 bit in this case, shouldn't it?

<shrug>

Who knows how the encryption algorithm (sha256) is encrypting
blocks. or what internal block size it is using. All I know is that
the it has to ensure that sectors (512 bytes) are written and read
atomically to/from the storage device.

Hence, at minimum, it will be encoding individual sectors (512
bytes), so any single bit error in the sector will likely result in
512 bytes of garbage.

> it has succeeded in this way, that it is now at least possible to mount
> the volume. But there is only the lost+found folder in there which
> contains again a lot of folders and files named with numbers. Looking
> deeper in these directories all the names of further files or
> directories are preserved. Phew! Only the fs structure in the first
> level seems to be garbled.
> 
> Checking the size of the lost+found folder, (nearly) everything seems to
> be there.
> 
> Now I am asking myself: If only one 256 bit block is garbled (f. ex.
> because of a terminated usb connection) all the directory and file names
> in the first level gets garbled? Wicked!

That's because you had the misfortune of garbling the root directory
inode along with the superblock. That's a very specific corruption,
but if the corruption occurred a few blocks away in a data extent
you wouldn't even know about it until you restore from backup and
realised the file content in the backup are corrupted. Indeed - you
should consider that entire backup as corrupted and redo it from
scratch.

FWIW, encryption makes any sort of corruption below the encrypted
layer much, much worse as it turns things like single bit media
errors into undecipherable, unrecoverable blocks of noise. No
filesystem can recover from such corruption of an encrypted device.
Hence if you had the same problem on ex3, ext4, JFS, etc you will
end up with the same mess (or worse).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
