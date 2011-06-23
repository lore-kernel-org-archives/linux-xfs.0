Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N7giI1169332 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 02:42:45 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEE1D27D9C
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 00:42:43 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hHSIt0e0ahVLdBvO
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 00:42:43 -0700 (PDT)
Message-ID: <4E02EE71.7010300@hardwarefreak.com>
Date: Thu, 23 Jun 2011 02:42:41 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_repair: "fatal error -- ran out of disk space!"
References: <BANLkTi=gS5iO9R9pVk_df-4ofkkb0ZJgfw@mail.gmail.com>	<4E026C42.2030500@sandeen.net>
	<20110622232418.GV32466@dastard>
	<BANLkTinu03WnKTL=SzoWt+Sd9YHjy0_w6g@mail.gmail.com>
In-Reply-To: <BANLkTinu03WnKTL=SzoWt+Sd9YHjy0_w6g@mail.gmail.com>
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
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 6/22/2011 6:41 PM, Patrick J. LoPresti wrote:

> I guess one question is how xfs_repair should behave in this case.  I
> mean, what if the file system had been full, but too corrupt for me to
> delete anything?

Maybe you should rethink your policy on filesystem space management.
>From what you stated the FS in question actually was full.  You
apparently were unaware of it until a problem (misbehaving nfsd process)
brought it to your attention.  You should be monitoring your FS usage.
Something as simple as logwatch daily summaries can save your bacon here.

As a general rule, when an FS begins steadily growing past the 80% mark
heading toward 90%, you need to take action, either adding more disk to
the underlying LVM device and growing the FS, mounting a new device/FS
into a new directory in the tree and manually moving files, or making
use of some HSM software.

Full filesystems have been a source of problems basically forever.  It's
best to avoid such situations instead of tickling the dragon.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
