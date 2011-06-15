Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5FF3Rck191875 for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 10:03:28 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAB8212DDC05
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2011 08:03:26 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id maqwJVvSdEKFw58g for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2011 08:03:26 -0700 (PDT)
Message-ID: <4DF8C9BD.6020104@sandeen.net>
Date: Wed, 15 Jun 2011 10:03:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: auto group failing on kernel v2.6.38.5
References: <BANLkTi=pgOCvn_2tdKXM6sLx_JKhzbrcEw@mail.gmail.com>
In-Reply-To: <BANLkTi=pgOCvn_2tdKXM6sLx_JKhzbrcEw@mail.gmail.com>
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
To: Manish Aggarwal <mani.iitb@gmail.com>
Cc: xfs@oss.sgi.com

On 6/15/11 4:24 AM, Manish Aggarwal wrote:
> Hi I am running xfstest suite using command
> 
> ./check -xfs -g auto
> 
> PC x86 machine with Kernel version 2.6.38.5
> XFS Tests Suite dated 2011-05-11 (http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git;a=summary)
> 
> 
> Many of the test cases are failing , please let me know thatt am I missing something?

Most are failing with something like "+umount: /home/manish/Projects/xfstests/sdb4: device is busy."

You should investigate to find out why that might be the case ...

> +umount: /home/manish/Projects/xfstests/sdb4: device is busy.
> +        (In some cases useful info about processes that use
> +         the device is found by lsof(8) or fuser(1))

-Eric

> Regards,
> Manish
> 
> 
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/i686 mannuDesk 2.6.38.5
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda6
> MOUNT_OPTIONS -- /dev/sda6 /home/manish/Projects/xfstests/sdb4
> 
> 001 4s ... 5s
> 002 0s ... 0s
> 003 0s ... 0s
> 004 1s ... 1s
> 005 0s ... 0s
> 006 35s ... 36s
> 007 58s ... 58s
> 008 1s ... 1s
> 009 1s ... 1s
> 010     [not run] dbtest was not built for this platform
> 011 43s ... 45s
> 012 1s ... 2s
> 013 145s ... 158s
> 014 53s ... 51s
> 015 1s ... - output mismatch (see 015.out.bad)
> --- 015.out    2011-05-11 22:32:24.000000000 +0530
> +++ 015.out.bad    2011-06-15 14:34:36.561351828 +0530
> @@ -4,4 +4,8 @@
>  check free space:
>  delete fill:
>  check free space:
> -   !!! free space is in range
> +   !!! free space has value of 20
> +free space is NOT in range 43306.56 .. 44181.44
> +umount: /home/manish/Projects/xfstests/sdb4: device is busy.
> +        (In some cases useful info about processes that use
> +         the device is found by lsof(8) or fuser(1))

... snip

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
