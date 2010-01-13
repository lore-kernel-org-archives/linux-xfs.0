Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D8gG8s136449 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 02:42:16 -0600
Received: from crca.org.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 235F31611FD
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 00:43:11 -0800 (PST)
Received: from crca.org.au (mail.crca.org.au [67.207.131.56]) by cuda.sgi.com
	with ESMTP id ng1RIRqb21UROEoj for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 00:43:11 -0800 (PST)
Message-ID: <4B4D87D8.5050900@crca.org.au>
Date: Wed, 13 Jan 2010 19:44:08 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
MIME-Version: 1.0
Subject: Re: [TuxOnIce-devel] Latest updates.
References: <20100113054152.GL17483@discord.disaster>	<99724068.1731191263362718752.JavaMail.root@mail-au.aconex.com>	<20100113065740.GN17483@discord.disaster>
	<20100113081140.GO17483@discord.disaster>
In-Reply-To: <20100113081140.GO17483@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Hi.

Dave Chinner wrote:
> On Wed, Jan 13, 2010 at 05:57:40PM +1100, Dave Chinner wrote:
>> On Wed, Jan 13, 2010 at 05:05:18PM +1100, Nathan Scott wrote:
>>> [Looks like tuxonice is a subscriber-only list...]
>>>
>>> ----- "Dave Chinner" <david@fromorbit.com> wrote:
>>>
>>>> On Wed, Jan 13, 2010 at 02:09:14PM +1100, Nathan Scott wrote:
>>>> Agreed that it is trivial to implement but there are still some
>>>> definite traps - like the fact the sb change transaction may be
>>>> logged
>>>> immediately but the physical superblock may not get written for some
>>>> time after the mount.
>>> *nod* ... it will be written when unmounted though...
>> suspend in the kernel doesn't unmount filesystems. I have no idea
>> what tuxonice does these days, but last time I heard it left them
>> mounted but frozen over the suspend/resume cycle.
> 
> I found the code - it doesn't unmount filesystems. The git tree is
> here:
> 
> http://git.kernel.org/?p=linux/kernel/git/nigelc/tuxonice-head.git;a=summary
> 
> It appears that it walks the list of superblocks to grab the block
> device off each mounted superblock to do it's work, so I don't see
> any fundamental problem with using an attribute hanging off
> sb->s_root to hold the boot time...

Yeah. The idea is to have very simple code that looks at a fixed number
of bytes at a known offset into the partition. The value of the bytes is
stored in the image header, and compared prior to starting to resume. If
the data is different, we assume the filesystem has been mounted since
the image was written and it's unsafe to resume. It doesn't _need_ to be
a time - just something that's guaranteed to have changed if the
filesystem gets mounted afresh.

By the way, sorry for the slow replies so far and for slow ones in the
coming 24 hours. I'm on holidays and my father-in-law's funeral is tomorrow.

Nigel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
