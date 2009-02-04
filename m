Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n141sMvl108709 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 19:54:22 -0600
Received: from poopey.oranged.to (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AF02E2E0E
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 17:53:42 -0800 (PST)
Received: from poopey.oranged.to (poopey.oranged.to [213.198.65.20]) by
	cuda.sgi.com with ESMTP id Lud6jdgFxxyMJhSJ for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 17:53:42 -0800 (PST)
Message-Id: <7B2E904E-498E-4EEC-A09F-4DE823E4FAB0@alink.co.za>
From: George Barnett <george@alink.co.za>
In-Reply-To: <4988F363.1070708@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XFS corruption on ubuntu 2.6.27-9-server
Date: Wed, 4 Feb 2009 12:53:38 +1100
References: <2653B83E-85DA-4949-BCED-AF2BA3D324E1@alink.co.za>	<4988EF37.7020306@sandeen.net>
	<5CCF20F5-33D5-409E-BB27-5E1C5CB4D9E5@alink.co.za>
	<4988F363.1070708@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 04/02/2009, at 12:46 PM, Eric Sandeen wrote:

>> bad version number 0x0 on inode 18046
>> bad magic number 0x0 on inode 18047
>> bad version number 0x0 on inode 18047
>> bad directory block magic # 0 in block 0 for directory inode 18000
>
> Interesting that all the bad magic numbers were 0... not sure what to
> make of that, offhand, I'm afraid...

Oh dear.

I'm going to try moving the filesystem to ext3 to see if this  
continues.  If it does, it would suggest a bug in the underlying  
raid10 implementation or a problem with the disks, although they're  
not reporting any errors [1].

Is there any further debugging I can do before I start fresh?

George


1.  The hardware ecc recovered smartctl metric is /very/ high,  
although I'm told this may be normal for samsung drives.  I cant think  
of any way to confirm a disk problem without a CRC checking fs though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
