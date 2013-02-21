Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE9747F50
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 05:11:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7CBDCAC004
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2013 03:11:42 -0800 (PST)
Received: from atlas.fiton.is (atlas.fiton.is [62.145.135.105]) by
	cuda.sgi.com with ESMTP id 8FINkEdFeM6oswkI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Feb 2013 03:11:40 -0800 (PST)
Received: from localhost ([127.0.0.1]) by atlas.fiton.is for xfs@oss.sgi.com;
	Thu, 21 Feb 2013 11:13:54 +0000
From: =?iso-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
Subject: Ideal RAID-1 Stripe Size for IMAP Server ?
Date: Thu, 21 Feb 2013 11:11:35 +0000
Message-Id: <D991F48F-6D86-4199-9762-698DD7A61895@fiton.is>
Mime-Version: 1.0 (Apple Message framework v1283)
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

Hi there.

I'm currently configuring a brand new email server(IMAP) which will run
CentOS 6.3 x64. 

So lots of files on the data volume.

I'm confused about stripe size for my data volume.
I'm using 2x500GB for OS in RAID1 and 2x2TB SAS for DATA in RAID1 which is
hosted on a HP Smart Array P420 Controller with 1GB in Cache/Battery Backed Up.
Both these array's are on the P420 controller.

The initial configuring from Array Configuration Tools gives me 256K in Strip Size.
On both array's. 

What would be ideal for the data volume, and or the OS array ?

I'm going to run XFS for the DATA volume.

Any help and or suggestions would be much appreciated.

p.s. I have never configured mkfs.xfs manually, just wandering if some could help
a brother about correct commands about ideal fs creation.

THANKS.

Thanks allot folks.

Best regards,

Svavar
Reykjavik - Iceland








_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
