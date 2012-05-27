Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4R7YmXN126580 for <xfs@oss.sgi.com>; Sun, 27 May 2012 02:34:48 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	SAvR5bOiegR1hpk5 (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 27 May 2012 00:34:46 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so1237584ghb.26
	for <xfs@oss.sgi.com>; Sun, 27 May 2012 00:34:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC19408.5020502@sandeen.net>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
	<4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net>
Date: Sun, 27 May 2012 09:34:46 +0200
Message-ID: <CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com>
Subject: Re: very slow file deletion on an SSD
From: Stefan Ring <stefanrin@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, Joe Landman <joe.landman@gmail.com>

>> [root@siFlash test]# xfs_bmap -vp 2.r.96.0
>> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x4 ["2.r.96.0"]: Cannot allocate memory
>
> Try filefrag -v maybe, if your e2fsprogs is new enough.
>
> Trying to remember, ENOMEM in bmap rings a bell... but this is possibly indicative of an extremely fragmented file.

True, I've had it happen with extremely fragmented files.

I've started playing around with discard myself only recently, but so
far I like the approach of using fstrim a lot better than the discard
option: http://xfs.org/index.php/FITRIM/discard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
