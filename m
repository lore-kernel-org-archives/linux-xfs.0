Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7H0I2ML010892 for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 19:18:02 -0500
Received: from isrv.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9C361B70
	for <xfs@oss.sgi.com>; Mon, 16 Aug 2010 17:18:30 -0700 (PDT)
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231]) by cuda.sgi.com
	with ESMTP id m3TFTeK0FblkRGEp for <xfs@oss.sgi.com>;
	Mon, 16 Aug 2010 17:18:30 -0700 (PDT)
Message-ID: <4C69D554.4010407@msgid.tls.msk.ru>
Date: Tue, 17 Aug 2010 04:18:28 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: Alignment size?
References: <4C64715F.8060000@msgid.tls.msk.ru>
	<20100812234911.GC10429@dastard>
	<4C64E52E.2060806@msgid.tls.msk.ru>
	<20100813113915.GD10429@dastard>
In-Reply-To: <20100813113915.GD10429@dastard>
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
Cc: xfs@oss.sgi.com

13.08.2010 15:39, Dave Chinner wrote:
> On Fri, Aug 13, 2010 at 10:24:46AM +0400, Michael Tokarev wrote:
[]
>> And a related question, -- is there a way to create
>> xfs fs with the right sector size?  The filesystem
>> were ok in years, not only on this machine, and I'm
>> quite afraid to replace it with something else (e.g.
>> ext4) in a hurry without good prior testing.
> 
> # mkfs.xfs -s <size> ....
> 
> if you want to set it manually. YOu shouldn't need to with any
> relatively recent mkfs.xfs...

Um.  It appears that mkfs.xfs ignores -s size=512 on this
raid5 array, and silently creates a filesystem with 4096
sector size, regardless of various -s size=nn and -s log=mm
options.

This is xfsprogs  3.1.2-1 (debian squeeze package).

So the question stands...

Thanks!

/mjt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
