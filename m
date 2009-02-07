Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n17MlBA7133771 for <xfs@oss.sgi.com>; Sat, 7 Feb 2009 16:47:12 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72410F9B6A
	for <xfs@oss.sgi.com>; Sat,  7 Feb 2009 14:46:33 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id SVwinbbRBsOdIW9V for <xfs@oss.sgi.com>;
	Sat, 07 Feb 2009 14:46:33 -0800 (PST)
Message-ID: <498E0303.5000204@sandeen.net>
Date: Sat, 07 Feb 2009 15:54:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Power loss causes bad magic number??
References: <22271900.11234039561556.JavaMail.root@wombat.diezmil.com>
	<498DF8AD.3020903@sandeen.net>
In-Reply-To: <498DF8AD.3020903@sandeen.net>
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
To: kevin.dual@gmail.com
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:

> Dunno how much damage could have been done, or if you can just try to
> fix the assembly perhaps...?
> 
> -Eric

FWIW on a 3-disk raid5:

[root@inode tmp]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 loop3[2] loop2[1] loop1[0]
      262016 blocks level 5, 4k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

it's the 0th device which should have the superblock:

[root@inode tmp]# file -s /dev/loop[123]
/dev/loop1: SGI XFS filesystem data (blksz 4096, inosz 256, v2 dirs)
/dev/loop2: data
/dev/loop3: data

whereas yours was the 1st (not 0th)

(I wasn't sure how mdstat showed the order so double checked...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
