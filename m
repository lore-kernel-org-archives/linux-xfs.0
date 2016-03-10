Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF6B97CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 11:02:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3898304032
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 09:02:46 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id DUgqyH72HNxpbvDB for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2016 09:02:42 -0800 (PST)
Received: from Liberator.local (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6FCF44801
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 11:02:30 -0600 (CST)
Subject: Re: an mount option question and dunno if right here...
References: <08297acdf77244b468e15458f3d78327@zbfmail.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56E1A8B1.2080800@sandeen.net>
Date: Thu, 10 Mar 2016 11:02:41 -0600
MIME-Version: 1.0
In-Reply-To: <08297acdf77244b468e15458f3d78327@zbfmail.de>
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

On 3/9/16 4:35 AM, Marko Weber | 8000 wrote:
> 
> 
> hello list,
> 
> my drives are all xfs formatted.
> in fstab i set:
> 
>                  lazytime,logbsize=256k,logbufs=8
> 
> 
> when i call "mount" on console i get:
> 
>                  rw,relatime,lazytime,attr2,inode64,logbufs=8,logbsize=256k,sunit=1024,swidth=3072,noquota
> 
> 
> Why is relatime listed? Or is lazytime override this setting?
> Even when i set "norelatime" in /etc/fstab i get "relatime" listed on 'mount'
> 
> Or am i wrong here with this question? is this not xfs related?
> anyway, for any hints or suggestions i am thankful

lazytime is not a valid xfs mount option:

[root ~]# mount -o lazytime /dev/sdb1 /mnt/test
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
missing codepage or helper program, or other error
In some cases useful info is found in syslog - try
dmesg | tail or so

[root ~]# dmesg | tail -n 1
[645779.811802] XFS (sdb1): unknown mount option [lazytime].

I'm guessing this is your root fs? xfs today will silently ignore
unknown mount options on remount (patches to fix that are upstream),
and the root fs may get remounted w/ fstab options.  So presumably
that's how you got lazytime into the mount output, especially if
it's looking at /etc/mtab. Look in /proc/mounts; I doubt you'll
see "lazytime" for this filesystem:

[root ~]# mount /dev/sdb1 /mnt/test
[root ~]# mount -o remount,lazytime /mnt/test

[root ~]# grep sdb1 /etc/mtab /proc/mounts
/etc/mtab:/dev/sdb1 /mnt/test xfs rw,lazytime 0 0
/proc/mounts:/dev/sdb1 /mnt/test xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
