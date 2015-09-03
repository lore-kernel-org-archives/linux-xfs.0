Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A76757F89
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 09:55:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67D4A304032
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 07:55:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id rsVH3hVGckOMrzok for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 07:55:28 -0700 (PDT)
Subject: Re: xfs corruption
References: <CAC=x_0hAQR9Ynmnqohv1R8xv3TBot5wmn7DODx6GbKU7tYv2sA@mail.gmail.com>
	<55E8498F.8090508@sandeen.net>
	<CAC=x_0iUc2VEfW9qChuvUpDk5Kz=wvRGH-1w6sS0XP6CG_ERBQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E85F5F.6010005@sandeen.net>
Date: Thu, 3 Sep 2015 09:55:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAC=x_0iUc2VEfW9qChuvUpDk5Kz=wvRGH-1w6sS0XP6CG_ERBQ@mail.gmail.com>
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
To: Danny Shavit <danny@zadarastorage.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On 9/3/15 9:26 AM, Danny Shavit wrote:
> Hi Eric,
> 
> Thanks for the prompt response. Sorry for the missing parts, I was
> wrongly assuming that everybody knows our environment :-)

Maybe some do, but my brain is too small for that.  ;)

> More information: uname -a:  Linux vsa-00000142 3.8.13-030813-generic
> #201305111843 SMP Sat May 11 22:44:40 UTC 2013 x86_64 x86_64 x86_64
> GNU/Linux xfs_repair version 3.1.7
> 
> We are using modified xfs. Mainly, added some reporting features and
> changed discard operation to be aligned with chunk sizes used in our
> systems. The modified code resides at  https://github.com/zadarastora
> <https://github.com/zadarastorage/zadara-xfs-pushback>ge/zadara-xfs-pushback
> <https://github.com/zadarastorage/zadara-xfs-pushback>.

Interesting, thanks for the pointer.  I guess at this point I have to
ask, do you see these same problems without your modifications?

I'd really encourage Zadara to work on submitting some of these upstream,
if they are of general interest.  It'll get more review, more testing,
and will reduce your maintenance burden.  Obviously some of it may not
be desired upstream, but if you've solved a general problem, it'd be
very good to propose a patch for inclusion.

> We were in a hurry at the time we run xfs_repair with -L. Was not so
> smart... Any way, the xfs_dump was taken before running xfs_repair. 
> We will use the original xfs meta data to run xfs_repair after mount
> and get back with the results.

Ok, from the metadump I see that log replay fails due to the corruption:

[ 7708.169145] XFS (loop0): Mounting V4 Filesystem
[ 7708.178379] XFS (loop0): Starting recovery (logdev: internal)
[ 7708.185369] XFS (loop0): Metadata corruption detected at xfs_bmbt_read_verify+0x7e/0xc0 [xfs], block 0x50ffb50
[ 7708.195344] XFS (loop0): Unmount and run xfs_repair
[ 7708.200214] XFS (loop0): First 64 bytes of corrupted metadata buffer:
[ 7708.206638] ffff8802e5b9d000: ea bb 12 3a 5f 44 01 a8 b9 2a 80 10 b3 a7 d5 af  ...:_D...*......
[ 7708.215312] ffff8802e5b9d010: f6 b0 39 2d 08 54 7a ec 37 1b 94 b0 c2 37 23 1f  ..9-.Tz.7....7#.
[ 7708.223986] ffff8802e5b9d020: 54 62 b5 fd ff 63 95 01 4b 23 fc 5d 8b d4 7b 78  Tb...c..K#.]..{x
[ 7708.232662] ffff8802e5b9d030: 94 e6 fa cc e2 87 3d fe ab df b8 e9 e5 9b e5 da  ......=.........
[ 7708.241341] XFS (loop0): metadata I/O error: block 0x50ffb50 ("xfs_trans_read_buf_map") error 117 numblks 8
[ 7708.251058] XFS (loop0): xfs_do_force_shutdown(0x1) called from line 315 of file fs/xfs/xfs_trans_buf.c.  Return address = 0xffffffffa036c41a
[ 7708.263721] XFS (loop0): I/O Error Detected. Shutting down filesystem
[ 7708.270144] XFS (loop0): Please umount the filesystem and rectify the problem(s)
[ 7708.277533] XFS (loop0): Ending recovery (logdev: internal)
[ 7708.283095] SELinux: (dev loop0, type xfs) getxattr errno 5
[ 7708.288664] XFS (loop0): xfs_log_force: error -5 returned.
[ 7708.294136] XFS (loop0): Unmounting Filesystem


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
