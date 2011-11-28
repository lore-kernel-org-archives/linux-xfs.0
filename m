Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASGN6s7242160 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 10:23:07 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B783319D6436
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 08:11:41 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 8TF7S09x0VgEw94C for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 08:11:41 -0800 (PST)
Message-ID: <4ED3B2BC.1060609@sandeen.net>
Date: Mon, 28 Nov 2011 10:11:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical Sector
	size
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
	<20111127235051.GX2386@dastard>
	<yq1vcq4grgi.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1vcq4grgi.fsf@sermon.lab.mkp.net>
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
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 11/28/11 10:08 AM, Martin K. Petersen wrote:
>>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:
> 
>>> Ok, if we have mismanaged the alignment and aligned to logical, not
>>> physical, then I guess there would be an issue... but at that point
>>> we've already messed up (though not catastrophically I guess)...
> 
> Dave> That's where I'm concerned - if alignment is screwed because the
> Dave> FS is 512B sector aligned (because something read the logical
> Dave> sector size), then using a 4k sector will result in torn writes
> Dave> because every 4k sector write is potentially made up of 2 4k write
> Dave> IOs, not 1.
> 
> There's another inherent failure scenario with 512b logical / 4096b
> physical. If you write in 512-byte multiples and experience a medium
> error you can lose the sibling logical blocks within that physical
> block. You'll get an I/O error back but there are no means to
> communicate that you have also lost blocks that were not part of your
> write request. So if you use 512-byte entries in the journal and get a
> write error you should at the very minimum consider adjacent entries
> inside a 4KB window suspect.
> 
> 
> Dave> That's my concern - using the logical 512b sector size is -always-
> Dave> safe, but using the 4k physical block size is only safe if
> Dave> everything under the filesystem has detected and used the physical
> Dave> block size of the disk for alignment and sector sizes...
> 
> You should always take alignment into account.
> 
> And while Christoph is right that (thankfully) nobody ended up shipping
> drives with 1-alignment by default, most 512e drives have the alignment
> jumper and some people actually use it.

It seems that we should be checking for any alignment offsets in libxfs
then, too; if there IS an offset, then perhaps 4k is the wrong answer,
(perhaps there is no right answer) but if there is NO offset, 4k should
be the right choice, yes?

And if the drive is broken then c'est la vie?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
