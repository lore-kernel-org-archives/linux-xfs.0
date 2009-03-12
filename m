Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2C57QRZ053814 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 00:07:47 -0500
Received: from rv-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCCA518DD8C
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 22:07:03 -0700 (PDT)
Received: from rv-out-0506.google.com (rv-out-0506.google.com
	[209.85.198.228]) by cuda.sgi.com with ESMTP id
	aV5dLBTngcqh8X2c for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2009 22:07:03 -0700 (PDT)
Received: by rv-out-0506.google.com with SMTP id g9so3167125rvb.4
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 22:07:03 -0700 (PDT)
Message-ID: <49B8986F.60009@gmail.com>
Date: Thu, 12 Mar 2009 14:06:55 +0900
From: Thomas Gutzler <thomas.gutzler@gmail.com>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data detected
References: <169670ec0901011846q1d370e6cu31514519afc8295d@mail.gmail.com>		<495D88EE.2040406@sandeen.net>	<169670ec0903101944i2ea05432q7bf9776a347a11a5@mail.gmail.com>	<49B73E50.5080906@sandeen.net>
	<49B79586.5060801@gmail.com> <49B8720E.3070400@sandeen.net>
In-Reply-To: <49B8720E.3070400@sandeen.net>
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
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Thomas Gutzler wrote:
>>
>> root@io:~# xfs_metadump /dev/sda xfs_metadump_sda
>> *** glibc detected *** xfs_db: double free or corruption (out):
>> 0x00000000017b8000 ***
> 
> ...
> 
>> Aborted
> 
> :(  what version of xfsprogs?

xfsprogs 2.9.8-1
most recent version that comes with ubuntu intrepid.

>> and tried again:
>> root@io:~# xfs_metadump -w /dev/sda xfs_metadump_sda
>> root@io:~# ll xfs_metadump_sda
>> -rw-r--r-- 1 root root 588407296 2009-03-11 19:09 xfs_metadump_sda
>> (where do I upload this to?)
> 
> You can bzip2 it and probably shrink it pretty well (it's sparse).  See
> how big that is, and we can find a place for it.

87M     xfs_metadump_sda_2.bz2
109M    xfs_metadump_sda.bz2

The filesystem has 3.1TB of data on it.
I can put that on our webserver for download or put it somewhere - let
me know what's best.

Tom

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
