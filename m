Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5UKxC5x146959 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 15:59:13 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 388C4157E3A9
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 14:01:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ZIcnKAadVF3bVoyi
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 14:01:57 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 58B286C3F6
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 16:01:57 -0500 (CDT)
Message-ID: <4C2BB0C4.4060800@hardwarefreak.com>
Date: Wed, 30 Jun 2010 16:01:56 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs file system in process of becoming corrupt; though xfs_repair
	thinks it's fine! ; -/ (was xfs_dump problem...)
References: <4C26A51F.8020909@tlinx.org>
	<20100628022744.GX6590@dastard>	<4C2A749E.4060006@tlinx.org>
	<20100629232532.GA24712@dastard>	<4C2A8948.3030008@tlinx.org>
	<20100630010622.GC24712@dastard> <4C2AA36F.2070905@tlinx.org>
In-Reply-To: <4C2AA36F.2070905@tlinx.org>
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
To: xfs@oss.sgi.com

Linda A. Walsh put forth on 6/29/2010 8:52 PM:

> I have another directory "Shakugan no Shana II OST", that I can't cd
> into or ls.
> Just says 'not found'.
> 
> This all happened today.  They were accessible before today.  I'm not
> sure what changed,
> other than new files were added.

It is interesting that all of these "corrupt" files originate from Japan.  The
filenames have likely passed through many different character encodings on
their journey from their source to your XFS filesystems.  And they probably
originated on a MS Windows machine.

How can you be so certain that there isn't a wonky bit somewhere that's
wreaking havoc with BabelMap?  Maybe that program has a bug, that after after
Y access cycles flips a bit, changes a character, or something along these
lines?  Did you update this program recently, or any other programs that might
affect character encoding/displaying, or anything remotely related to such?
Have you done any software updates recently, period?

Given the entirety of what we're looking at, and that you're apparently not
seeing this with files created in a native English language encoding, I'd say
Dave is probably on the right track here.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
