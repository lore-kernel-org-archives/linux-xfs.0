Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB4JiYfv254687 for <xfs@oss.sgi.com>; Tue, 4 Dec 2012 13:44:34 -0600
Received: from relay02.pair.com (relay02.pair.com [209.68.5.16]) by
	cuda.sgi.com with SMTP id 26xzTCfupW4C8wB4 for
	<xfs@oss.sgi.com>; Tue, 04 Dec 2012 11:46:56 -0800 (PST)
Date: Tue, 04 Dec 2012 14:46:53 -0500
Subject: Re: xfsdump INTERRUPT issue
From: "J. Ellis" <jellis@dhnet.us>
Message-ID: <CCE3BD5D.B0540%jellis@dhnet.us>
In-Reply-To: <CCE2425A.B0475%jellis@dhnet.us>
Mime-version: 1.0
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
To: Jeffrey Ellis <jellis@dhnet.us>, stan@hardwarefreak.com, Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi, Dave & Stan, et al--

Are you guys getting this post? I don't see it showing up on the list and
have had no responses. I'm wondering if the size of the text of the
requested xfs info I had added is causing an issue getting it posted.

If not, here's a repost, using a link to the file instead.

http://dhnet.us/xfs/xfs_data_file.odt

Best,
Jeffrey


on 12/3/12 11:49 AM, Jeffrey Ellis at jellis@dhnet.us wrote:

> Thank you to Stan and Dave for helping me through this.
> 
> Ok, here's the file, printed below.
> 
> Basically, I'm running the following commands under Ubuntu 12.10:
> 
> Type mkdir /mnt/fp
> Type mkdir /mnt/hr20
> Type mount -t xfs -o rtdev=/dev/sda3 /dev/sda2 /mnt/fp
> Type mount -t xfs -o rtdev=/dev/sdb3 /dev/sdb2 /mnt/hr20
> Type xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fp
> 
> When run, I get this as my output:
> 
> xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)
> xfsdump: ending media file
> xfsdump: media file size 18874368 bytes
> xfsdump: dump size (non-dir files) : 13698056 bytes
> xfsdump: NOTE: dump interrupted: 16 seconds elapsed
> xfsdump: Dump Status: INTERRUPT
> 
> This happens each time. In the forum where this copy procedure was
> suggested, they've been reporting that the latest xfsprogs is creating these
> errors, which didn't happen under at least somewhat earlier versions.
> 
> The version of xfsprogs should be in the file, but it was just downloaded a
> few days ago using git.
> 
> Best,
> Jeffrey


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
