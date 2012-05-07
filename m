Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q476ekwA210425 for <xfs@oss.sgi.com>; Mon, 7 May 2012 01:40:46 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id BKN5vHyrabE6dv77 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 06 May 2012 23:40:43 -0700 (PDT)
Message-ID: <4FA76E69.9090207@profihost.ag>
Date: Mon, 07 May 2012 08:40:41 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: suddenly slow writes on XFS Filesystem
References: <4FA63DDA.9070707@profihost.ag>
	<201205061233.58496.Martin@lichtvoll.de>
	<4FA69CB0.8000008@hardwarefreak.com>
	(sfid-20120506_233742_387085_AFEABC59)
	(sfid-20120506_233742_387085_AFEABC59)
	<201205062343.21871.Martin@lichtvoll.de>
In-Reply-To: <201205062343.21871.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Am 06.05.2012 23:43, schrieb Martin Steigerwald:
> Am Sonntag, 6. Mai 2012 schrieb Stan Hoeppner:
>> On 5/6/2012 5:33 AM, Martin Steigerwald wrote:
>>> Am Sonntag, 6. Mai 2012 schrieb Stefan Priebe:
>>>> It is a raid 10 of 20 SATA Disks and i can only write to them with
>>>> about  700kb/s while doing random i/o. I tried vanilla Kernel 3.0.30
>>>> and 3.3.4 - no difference. Writing to another partition on another
>>>> xfs array works fine.
>>>
>>> Additionally what RAID is this? SoftRAID or some - which one? -
>>> hardware RAID controller? And what disks are used, whats the rpm of
>>> these?
It is a HW Adaptec 5805 Controller with 20x 7200rpm SATA Disks.

> Can free space be defragmented in XFS? xfs_fsr only tries to defragment 
> files as far as I know.
That is a good question.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
