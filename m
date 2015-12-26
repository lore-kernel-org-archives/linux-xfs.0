Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 79D7D7F37
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2015 16:54:04 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4EDCB8F8035
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2015 14:54:01 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	XLJOtZWNnAM9gHUk for <xfs@oss.sgi.com>;
	Sat, 26 Dec 2015 14:53:58 -0800 (PST)
Date: Sun, 27 Dec 2015 09:53:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Message-ID: <20151226225355.GV19802@dastard>
References: <567212DA.8050808@cn.fujitsu.com> <567228EF.80007@redhat.com>
	<87twn8vjgo.fsf@flamingspork.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87twn8vjgo.fsf@flamingspork.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stewart Smith <stewart@flamingspork.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com, Qu Wenruo <quwenruo@cn.fujitsu.com>, fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>

On Thu, Dec 24, 2015 at 10:22:31AM +1100, Stewart Smith wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> >> 3) A lot of user even don't now mount ro can still modify device
> >>    Yes, I didn't know this point until I checked the log replay code of
> >>    btrfs.
> >>    Adding such mount option alias may raise some attention of users.
> >
> > Given that nothing in the documentation implies that the block device itself
> > must remain unchanged on a read-only mount, I don't see any problem which
> > needs fixing.  MS_RDONLY rejects user IO; that's all.
> >
> > If you want to be sure your block device rejects all IO for forensics or
> > what have you, I'd suggest # blockdev --setro /dev/whatever prior to mount,
> > and take it out of the filesystem's control.  Or better yet, making an
> > image and not touching the original.
> 
> What we do for the petitboot bootloader in POWER and OpenPower firmware
> (a linux+initramfs that does kexec to boot) is that we use device mapper
> to make a snapshot in memory where we run recovery (for some
> filesystems, notably XFS is different due to journal not being endian
> safe). We also have to have an option *not* to do that, just in case
> there's a bug in journal replay... and we're lucky in the fact that we
> probably do have enough memory to complete replay, this solution could
> be completely impossible on lower memory machines.

Which means the boot loader is going to break horribly when we
change the on-disk format and feature flags the boot loader doesn't
understand get set in the root filesystem. Then the bootloader will
refuse to mount the filesystem and the system won't boot anymore...

IOWs, developers and users can't make a root XFS filesystem with a
new/experimental feature on POWER/OpenPower machines because the
bootloader will refuse to mount it regardless of the clean/dirty
state of the journal....

> As such, I believe we're the only bit of firmware/bootloader ever that
> has correctly parsed a journalling filesystem.

Nope.  The Irix bootloader (sash) could do this 20 years ago - there
are even feature mask bits reserved specifically for SASH in the XFS
superblock. However, seeing as the bootloader was always upgraded
during the install of each new Irix release, the bootloader was
always up-to-date with the on-disk features the kernel supported and
so there was never a problem with mismatched feature support.

However, Linux users can upgrade or change the kernel at any time
independently of the bootloader, so it's pretty much guaranteed that
mismatched bootloader/kernel filesystem capabilities will cause
users problems at some point in the not-too-distant future.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
