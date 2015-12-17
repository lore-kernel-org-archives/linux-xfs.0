Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AB897CBF
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2015 21:16:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B28EEAC004
	for <xfs@oss.sgi.com>; Wed, 16 Dec 2015 19:16:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id r4N084b1MR95soPd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Dec 2015 19:16:01 -0800 (PST)
Subject: Re: Ideas on unified real-ro mount option across all filesystems
References: <567212DA.8050808@cn.fujitsu.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <567228EF.80007@redhat.com>
Date: Wed, 16 Dec 2015 21:15:59 -0600
MIME-Version: 1.0
In-Reply-To: <567212DA.8050808@cn.fujitsu.com>
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
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, fsdevel <linux-fsdevel@vger.kernel.org>
Cc: linux-ext4@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

<xfs list address fixed>

On 12/16/15 7:41 PM, Qu Wenruo wrote:
> Hi,
> 
> In a recent btrfs patch, it is going to add a mount option to disable
> log replay for btrfs, just like "norecovery" for ext4/xfs.
> 
> But in the discussion on the mount option name and use case, it seems
> better to have an unified and fs independent mount option alias for
> real RO mount
> 
> Reasons:
> 1) Some file system may have already used [no]"recovery" mount option
>    In fact, btrfs has already used "recovery" mount option.
>    Using "norecovery" mount option will be quite confusing for btrfs.

Too bad btrfs picked those semantics when "norecovery" has existed on
other filesystems for quite some time with a different meaning... :(

> 2) More straight forward mount option
>    Currently, to get real RO mount, for ext4/xfs, user must use -o
>    ro,norecovery.
>    Just ro won't ensure real RO, and norecovery can't be used alone.
>    If we have a simple alias, it would be much better for user to use.
>    (it maybe done just in user space mount)

mount(8) simply says:

       ro     Mount the filesystem read-only.

and mount(2) is no more illustrative:

       MS_RDONLY
              Mount file system read-only.

kernel code is no help, either:

#define MS_RDONLY        1      /* Mount read-only */

They say nothing about what, exactly, "read-only" means.  But since at least
the early ext3 days, it means that you cannot write through the filesystem, not
that the filesystem will leave the block device unmodified when it mounts.

I have always interpreted it as simply "no user changes to the filesystem,"
and that is clearly what the vfs does with the flag...

>    Not to mention some fs (yeah, btrfs again) doesn't have "norecovery"
>    but "nologreplay".

well, again, btrfs picked unfortunate semantics, given the precedent set
by other filesystems.

f2fs, ext4, gfs2, nilfs2, and xfs all support "norecovery" - xfs since
forever, ext4 & f2fs since 2009, etc.

> 3) A lot of user even don't now mount ro can still modify device
>    Yes, I didn't know this point until I checked the log replay code of
>    btrfs.
>    Adding such mount option alias may raise some attention of users.

Given that nothing in the documentation implies that the block device itself
must remain unchanged on a read-only mount, I don't see any problem which
needs fixing.  MS_RDONLY rejects user IO; that's all.

If you want to be sure your block device rejects all IO for forensics or
what have you, I'd suggest # blockdev --setro /dev/whatever prior to mount,
and take it out of the filesystem's control.  Or better yet, making an
image and not touching the original.

-Eric

> Any ideas about this?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
