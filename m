Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4RF00Iw209317 for <xfs@oss.sgi.com>; Sun, 27 May 2012 10:00:00 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	yl61CoAPNIAZim6i (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 27 May 2012 07:59:59 -0700 (PDT)
Received: by obbuo19 with SMTP id uo19so4950267obb.26
	for <xfs@oss.sgi.com>; Sun, 27 May 2012 07:59:59 -0700 (PDT)
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
	<4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net>
	<CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com>
	<1338124504.28212.255.camel@oxygen.netxsys.com>
In-Reply-To: <1338124504.28212.255.camel@oxygen.netxsys.com>
Mime-Version: 1.0 (1.0)
Message-Id: <5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
From: joe.landman@gmail.com
Subject: Re: very slow file deletion on an SSD
Date: Sun, 27 May 2012 10:59:52 -0400
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
To: Krzysztof Adamski <k@adamski.org>
Cc: Stefan Ring <stefanrin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This is going to be a very fragmented file.  I am guessing that this is the reason for the long duration delete.   I'll do some more measurements before going to 3.4.x as per Eric's note.

Sent from my iPad

On May 27, 2012, at 9:15 AM, Krzysztof Adamski <k@adamski.org> wrote:

> On Sun, 2012-05-27 at 09:34 +0200, Stefan Ring wrote:
>>>> [root@siFlash test]# xfs_bmap -vp 2.r.96.0
>>>> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x4 ["2.r.96.0"]: Cannot allocate memory
>>> 
>>> Try filefrag -v maybe, if your e2fsprogs is new enough.
>>> 
>>> Trying to remember, ENOMEM in bmap rings a bell... but this is possibly indicative of an extremely fragmented file.
>> 
>> True, I've had it happen with extremely fragmented files.
>> 
>> I've started playing around with discard myself only recently, but so
>> far I like the approach of using fstrim a lot better than the discard
>> option: http://xfs.org/index.php/FITRIM/discard
> 
> Check what blockdev --getra <md device> is set to. I used to have a
> several second deletes on large (4GB) fragmented files when ra was the
> default 256. Once I changed it to 4096 (best value will depend on your
> setup) the deletes became instant.
> 
> K
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
