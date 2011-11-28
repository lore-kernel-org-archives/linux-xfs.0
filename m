Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASG94XP241487 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 10:09:04 -0600
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9710227BFC8
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 08:09:03 -0800 (PST)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id jYSJMXggR1xNvnD5 for
	<xfs@oss.sgi.com>; Mon, 28 Nov 2011 08:09:03 -0800 (PST)
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard> <4ED2C233.8010104@sandeen.net>
	<20111127235051.GX2386@dastard>
Date: Mon, 28 Nov 2011 11:08:29 -0500
In-Reply-To: <20111127235051.GX2386@dastard> (Dave Chinner's message of "Mon,
	28 Nov 2011 10:50:51 +1100")
Message-ID: <yq1vcq4grgi.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

>>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:

>> Ok, if we have mismanaged the alignment and aligned to logical, not
>> physical, then I guess there would be an issue... but at that point
>> we've already messed up (though not catastrophically I guess)...

Dave> That's where I'm concerned - if alignment is screwed because the
Dave> FS is 512B sector aligned (because something read the logical
Dave> sector size), then using a 4k sector will result in torn writes
Dave> because every 4k sector write is potentially made up of 2 4k write
Dave> IOs, not 1.

There's another inherent failure scenario with 512b logical / 4096b
physical. If you write in 512-byte multiples and experience a medium
error you can lose the sibling logical blocks within that physical
block. You'll get an I/O error back but there are no means to
communicate that you have also lost blocks that were not part of your
write request. So if you use 512-byte entries in the journal and get a
write error you should at the very minimum consider adjacent entries
inside a 4KB window suspect.


Dave> That's my concern - using the logical 512b sector size is -always-
Dave> safe, but using the 4k physical block size is only safe if
Dave> everything under the filesystem has detected and used the physical
Dave> block size of the disk for alignment and sector sizes...

You should always take alignment into account.

And while Christoph is right that (thankfully) nobody ended up shipping
drives with 1-alignment by default, most 512e drives have the alignment
jumper and some people actually use it.

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
