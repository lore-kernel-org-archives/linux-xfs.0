Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C87337CF5
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:03:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 80789304039
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:03:33 -0700 (PDT)
Received: from mail.zbfmail.de (mail.zbfmail.de [176.9.84.12]) by cuda.sgi.com
	with ESMTP id 0W7kmtyeFoRkZ1Zv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 06:03:30 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 16 Mar 2016 14:03:28 +0100
From: Marko Weber | 8000 <weber@zbfmail.de>
Subject: Re: an mount option question and dunno if right here...
In-Reply-To: <56E1A8B1.2080800@sandeen.net>
References: <08297acdf77244b468e15458f3d78327@zbfmail.de>
	<56E1A8B1.2080800@sandeen.net>
Message-ID: <ebcb0a57f224c5a9be0d2d2777bca581@zbfmail.de>
Reply-To: weber@zbfmail.de
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



Am 2016-03-10 18:02, schrieb Eric Sandeen:
> On 3/9/16 4:35 AM, Marko Weber | 8000 wrote:
>> 
>> 
>> hello list,
>> 
>> my drives are all xfs formatted.
>> in fstab i set:
>> 
>>                  lazytime,logbsize=256k,logbufs=8
>> 
>> 
>> when i call "mount" on console i get:
>> 
>>                  
>> rw,relatime,lazytime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota
>> 
>> 
>> Why is relatime listed? Or is lazytime override this setting?
>> Even when i set "norelatime" in /etc/fstab i get "relatime" listed on 
>> 'mount'
>> 
>> Or am i wrong here with this question? is this not xfs related?
>> anyway, for any hints or suggestions i am thankful
> 
> lazytime is not a valid xfs mount option:
> 
> [root ~]# mount -o lazytime /dev/sdb1 /mnt/test
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
> missing codepage or helper program, or other error
> In some cases useful info is found in syslog - try
> dmesg | tail or so
> 
> [root ~]# dmesg | tail -n 1
> [645779.811802] XFS (sdb1): unknown mount option [lazytime].
> 
> I'm guessing this is your root fs? xfs today will silently ignore
> unknown mount options on remount (patches to fix that are upstream),
> and the root fs may get remounted w/ fstab options.  So presumably
> that's how you got lazytime into the mount output, especially if
> it's looking at /etc/mtab. Look in /proc/mounts; I doubt you'll
> see "lazytime" for this filesystem:
> 
> [root ~]# mount /dev/sdb1 /mnt/test
> [root ~]# mount -o remount,lazytime /mnt/test
> 
> [root ~]# grep sdb1 /etc/mtab /proc/mounts
> /etc/mtab:/dev/sdb1 /mnt/test xfs rw,lazytime 0 0
> /proc/mounts:/dev/sdb1 /mnt/test xfs
> rw,seclabel,relatime,attr2,inode64,noquota 0 0

Hi Eric,


my /etc/fstab entry:

/dev/VolGroup01/wiso    /raid5/wiso     xfs     norelatime,lazytime



# mount:


/dev/mapper/VolGroup01-wiso on /raid5/wiso type xfs 
(rw,relatime,lazytime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota)


cat /proc/mounts:

/dev/mapper/VolGroup01-wiso /raid5/wiso xfs 
rw,lazytime,relatime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota 
0 0






> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
