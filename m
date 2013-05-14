Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C9BB37F37
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 12:55:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87E2030405F
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 10:55:14 -0700 (PDT)
Received: from mail-oa0-f54.google.com (mail-oa0-f54.google.com
	[209.85.219.54]) by cuda.sgi.com with ESMTP id WPXko0G5ktd0jnVf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 14 May 2013 10:55:13 -0700 (PDT)
Received: by mail-oa0-f54.google.com with SMTP id o17so1015475oag.13
	for <xfs@oss.sgi.com>; Tue, 14 May 2013 10:55:12 -0700 (PDT)
Message-ID: <51927A6D.8010303@gmail.com>
Date: Tue, 14 May 2013 13:54:53 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair force_geometry
References: <5190DB7F.2050505@tum.de> <519165F2.80902@sandeen.net>
	<5191C772.4020607@tum.de> <5191ECCD.2070806@gmail.com>
	<5191FC34.10105@tum.de> <51922FAC.4000101@hardwarefreak.com>
In-Reply-To: <51922FAC.4000101@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

On 05/14/2013 08:35 AM, Stan Hoeppner wrote:
> On 5/14/2013 3:56 AM, Benedikt Schmidt wrote:
> ...
>> I see, I should have mentioned this earlier. I already tried xfs_repair
>> and it failed to find the second superblock. Because I am still able to
>> mount the original disk and most parts of it I guessed that xfs_repair
>> is confused by the different disk geometries. What I have also already
>> tried out was, naturally, to copy the whole stuff with for example cp or
>> xfs_copy, but both failed because of filesystem errors. The only program
>> which didn't fail to copy the data was dd_rescue, which can handle the
>> errors. That is why I used, as it was my only option (as far as I can see).
>
> You are able to mount the XFS on the original disk which means the
> superblocks are apparently intact and the log section isn't corrupt.
> But when you attempt to copy files from that XFS to another
> disk/filesystem you get what you describe as filesystem errors.  How far
> did the cp/xfs_copy progress before you received the filesystem errors?
>   What is the result of running xfs_repair -n on the original filesystem?
>
> The point of these questions is to reveal whether the original disk
> simply has media surface errors toward the end of the disk where you
> wrote those few most recent files, *or* if the problem with the disk is
> electrical or mechanical.
>
> The fact that cp/xfs_copy fail, yet ddrescue completes by retrying
> (though possibly while ignoring some sectors due to retry limit of 1),
> would tend to suggest the problem is electrical or mechanical, not
> platter surface defects.  From what you've described so far it sounds
> like the more load you put on the drive the more errors it throws.  This
> is typical when the internal power supply circuit on a drive is failing.
>
> While the drive is idle, I would suggest you use xfs_db on the original
> XFS to locate the positions of those few files that are not backed up.
> Unmount the XFS and use dd with skip/seek to copy only these files to
> another location.  Do one file at a time to put as little load on the
> drive as possible.  Give it some resting time between dd operations.  If
> this works it eliminates the need to expand your RAID5 or attempt more
> full partition copies to the new 2TB drive.  If this doesn't work, it
> also eliminates the need for either of these steps, as it will
> demonstrate it's simply not possible to recover the data.
>

I've been hesitant to suggest using the smartmontools to aid in this 
quest.  In the event of surface errors, `smartctl -a /dev/sdd` may or 
may not show the exact error locations.  The read error rate numbers 
might be helpful, too.  However, smartctl has extra features that might 
cause SMART to remap sectors that could be read one last time. `smartctl 
--test=long /dev/sdd` should be a no-no at this point.  At any rate, I 
wouldn't want that SMART initialization clunk noise to be the drive's 
last dying gasp.  Thoughts?

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
