Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8P5WnPd044282 for <xfs@oss.sgi.com>; Sun, 25 Sep 2011 00:32:49 -0500
Received: from mail.tuxonice.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A10B4141C619
	for <xfs@oss.sgi.com>; Sat, 24 Sep 2011 22:38:31 -0700 (PDT)
Received: from mail.tuxonice.net (tuxonice.net [96.126.116.212]) by
	cuda.sgi.com with ESMTP id IN5X5HYS3uWPWQ94 for
	<xfs@oss.sgi.com>; Sat, 24 Sep 2011 22:38:31 -0700 (PDT)
Message-ID: <4E7EBCF7.8090906@tuxonice.net>
Date: Sun, 25 Sep 2011 15:32:39 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
MIME-Version: 1.0
Subject: Re: [PATCH] PM / Freezer: Freeze filesystems while freezing processes
	(v2)
References: <4E1C70AD.1010101@u-club.de> <201108062317.19033.rjw@sisk.pl>
	<20110807001446.GI3162@dastard> <201109250056.12545.rjw@sisk.pl>
In-Reply-To: <201109250056.12545.rjw@sisk.pl>
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
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Christoph <cr2005@u-club.de>, Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org, Linux PM mailing list <linux-pm@lists.linux-foundation.org>, linux-ext4@vger.kernel.org

Hi.

On 25/09/11 08:56, Rafael J. Wysocki wrote:
> On Sunday, August 07, 2011, Dave Chinner wrote:
>> On Sat, Aug 06, 2011 at 11:17:18PM +0200, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rjw@sisk.pl>
>>>
>>> Freeze all filesystems during the freezing of tasks by calling
>>> freeze_bdev() for each of them and thaw them during the thawing
>>> of tasks with the help of thaw_bdev().
>>>
>>> This is needed by hibernation, because some filesystems (e.g. XFS)
>>> deadlock with the preallocation of memory used by it if the memory
>>> pressure caused by it is too heavy.
>>>
>>> The additional benefit of this change is that, if something goes
>>> wrong after filesystems have been frozen, they will stay in a
>>> consistent state and journal replays won't be necessary (e.g. after
>>> a failing suspend or resume).  In particular, this should help to
>>> solve a long-standing issue that in some cases during resume from
>>> hibernation the boot loader causes the journal to be replied for the
>>> filesystem containing the kernel image and initrd causing it to
>>> become inconsistent with the information stored in the hibernation
>>> image.
>>>
>>> This change is based on earlier work by Nigel Cunningham.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>> ---
> 
> Below is an alternative fix, the changelog pretty much explains the idea.
> 
> I've tested it on Toshiba Portege R500, but I don't have an XFS partition
> to verify that it really helps, so I'd appreciate it if someone able to
> reproduce the original issue could test it and report back.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Freeze kernel threads after preallocating memory
> 
> There is a problem with the current ordering of hibernate code which
> leads to deadlocks in some filesystems' memory shrinkers.  Namely,
> some filesystems use freezable kernel threads that are inactive when
> the hibernate memory preallocation is carried out.  Those same
> filesystems use memory shrinkers that may be triggered by the
> hibernate memory preallocation.  If those memory shrinkers wait for
> the frozen kernel threads, the hibernate process deadlocks (this
> happens with XFS, for one example).
> 
> Apparently, it is not technically viable to redesign the filesystems
> in question to avoid the situation described above, so the only
> possible solution of this issue is to defer the freezing of kernel
> threads until the hibernate memory preallocation is done, which is
> implemented by this change.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

TuxOnIce has the following logic at the moment: Freeze all threads.
Calculate whether we have enough memory for the image, thaw kernel
threads only, free memory and try again if it looks like we don't have
enough. I've never heard of a deadlock, though I suppose one would be
possible if you had the added complication of userspace
drivers/filesystems - it would be good to be able to distinguish and
thaw them.

It does this prior to the atomic copy, using a user-supplied estimate of
the amount of memory drivers will need - the actual amount used is show
in debugging info at the end of the cycle. Apart from that, if you have
everything else frozen, everything else is pretty deterministic
(assuming you don't have any memory leaks in your image-writing code).

Regards,

Nigel
-- 
Evolution (n): A hypothetical process whereby improbable
events occur with alarming frequency, order arises from chaos, and
no one is given credit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
