Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2C2NeX7045825 for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 21:24:00 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91A441C36B15
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2009 19:23:15 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id fral8FcKH6vs44FF for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2009 19:23:15 -0700 (PDT)
Message-ID: <49B8720E.3070400@sandeen.net>
Date: Wed, 11 Mar 2009 21:23:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data detected
References: <169670ec0901011846q1d370e6cu31514519afc8295d@mail.gmail.com>		<495D88EE.2040406@sandeen.net>	<169670ec0903101944i2ea05432q7bf9776a347a11a5@mail.gmail.com>	<49B73E50.5080906@sandeen.net>
	<49B79586.5060801@gmail.com>
In-Reply-To: <49B79586.5060801@gmail.com>
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
To: Thomas Gutzler <thomas.gutzler@gmail.com>
Cc: xfs@oss.sgi.com

Thomas Gutzler wrote:
> Eric Sandeen wrote:
>> Thomas Gutzler wrote:
...

>>> What can I do to help getting this fixed?
>>>
>> can you make an xfs_metadump of the filesystem in question, and then try
>> an xfs_repair?  Capture/save the repair output.  If repair finds errors,
>> then perhaps the bug is triggered by bad error checking on a corrupted
>> image, and we might reproduce it w/ the metadump image.
> 
> I tried...
> 
> root@io:~# xfs_metadump /dev/sda xfs_metadump_sda
> *** glibc detected *** xfs_db: double free or corruption (out):
> 0x00000000017b8000 ***

...

> Aborted

:(  what version of xfsprogs?

> and tried again:
> root@io:~# xfs_metadump -w /dev/sda xfs_metadump_sda
> root@io:~# ll xfs_metadump_sda
> -rw-r--r-- 1 root root 588407296 2009-03-11 19:09 xfs_metadump_sda
> (where do I upload this to?)

You can bzip2 it and probably shrink it pretty well (it's sparse).  See
how big that is, and we can find a place for it.

> xfs_repair fixed "bad names" of 4 inodes (see attached log file)
> 
> another xfs_metadump /dev/sda xfs_metadump_sda_2 (without -w):
> -rw-r--r--  1 root root 588261888 2009-03-11 19:23 xfs_metadump_sda_2
> 
>> It'd be nice if ubuntu had debug kernel variants (Fedora does this, I
>> dunno about ubuntu) - if you are hitting any kind of memory corruption
>> then a kernel with debug checks enabled might catch it sooner.
> 
> I haven't seen any - probably have to build my own debug kernel. Oh joy.
> 
> Is the metadump of any use?

it might be, let's see how well it shrinks.

-Eric

> Tom
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
