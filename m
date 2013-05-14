Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 368487F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 07:35:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BA325AC002
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 05:35:55 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9DYdh48qY8hLwWOu
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 05:35:54 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 7B7C96C147
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 07:35:54 -0500 (CDT)
Message-ID: <51922FAC.4000101@hardwarefreak.com>
Date: Tue, 14 May 2013 07:35:56 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de> <519165F2.80902@sandeen.net>
	<5191C772.4020607@tum.de> <5191ECCD.2070806@gmail.com>
	<5191FC34.10105@tum.de>
In-Reply-To: <5191FC34.10105@tum.de>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 5/14/2013 3:56 AM, Benedikt Schmidt wrote:
...
> I see, I should have mentioned this earlier. I already tried xfs_repair
> and it failed to find the second superblock. Because I am still able to
> mount the original disk and most parts of it I guessed that xfs_repair
> is confused by the different disk geometries. What I have also already
> tried out was, naturally, to copy the whole stuff with for example cp or
> xfs_copy, but both failed because of filesystem errors. The only program
> which didn't fail to copy the data was dd_rescue, which can handle the
> errors. That is why I used, as it was my only option (as far as I can see).

You are able to mount the XFS on the original disk which means the
superblocks are apparently intact and the log section isn't corrupt.
But when you attempt to copy files from that XFS to another
disk/filesystem you get what you describe as filesystem errors.  How far
did the cp/xfs_copy progress before you received the filesystem errors?
 What is the result of running xfs_repair -n on the original filesystem?

The point of these questions is to reveal whether the original disk
simply has media surface errors toward the end of the disk where you
wrote those few most recent files, *or* if the problem with the disk is
electrical or mechanical.

The fact that cp/xfs_copy fail, yet ddrescue completes by retrying
(though possibly while ignoring some sectors due to retry limit of 1),
would tend to suggest the problem is electrical or mechanical, not
platter surface defects.  From what you've described so far it sounds
like the more load you put on the drive the more errors it throws.  This
is typical when the internal power supply circuit on a drive is failing.

While the drive is idle, I would suggest you use xfs_db on the original
XFS to locate the positions of those few files that are not backed up.
Unmount the XFS and use dd with skip/seek to copy only these files to
another location.  Do one file at a time to put as little load on the
drive as possible.  Give it some resting time between dd operations.  If
this works it eliminates the need to expand your RAID5 or attempt more
full partition copies to the new 2TB drive.  If this doesn't work, it
also eliminates the need for either of these steps, as it will
demonstrate it's simply not possible to recover the data.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
