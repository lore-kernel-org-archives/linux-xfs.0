Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 908737F5D
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 15:06:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72ECC304048
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 13:06:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id chHCKU7xaDFAL34C for <xfs@oss.sgi.com>;
	Sat, 05 Jul 2014 13:06:09 -0700 (PDT)
Message-ID: <53B85AB0.30800@sandeen.net>
Date: Sat, 05 Jul 2014 15:06:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Data loss XFS with RT kernel on Debian.
References: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
In-Reply-To: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
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
To: Jan de Kruyf <jan.de.kruyf@gmail.com>, xfs@oss.sgi.com

On 7/5/14, 7:41 AM, Jan de Kruyf wrote:
> Hallo,
> 
> While doing a reasonably high density job like rsynching a subdirectory from one place to another, or tarring it to a pipe and untarring it at the other end, I note that the cpu usage goes practically to 100% and when I after 5 minutes or so I reset the computer the writing has not finished at all.
> However on the stock Debian kernel it works without a problem.
> 
> Could I still use this combination in an industrial environment reading and writing reasonably short text files? So far I did not experience this problem with normal day to day use. It stuck up its head during installation of   gnat-gpl-2014-x86_64-linux-bin from the http://libre.adacore.com/download/ page. The offending code is in the Makefile in the top directory page. The Xterm will give you the place where it gets stuck.

http://lwn.net/Articles/457667/

-Eric

> Regards,
> 
> Jan de Kruijf.
> 
> 
> Her are the details of the installation:
> 
> root@jan:~# xfs_info -V
> xfs_info version 3.1.7
> 
> root@jan:~# xfs_info /usr
> meta-data=/dev/sda3 isize=256 agcount=4, agsize=732416 blks
>               = sectsz=512 attr=2
>        data = bsize=4096 blocks=2929664, imaxpct=25
>                = sunit=0 swidth=0 blks
> naming =version 2 bsize=4096 ascii-ci=0
> log =internal bsize=4096 blocks=2560, version=2
>        = sectsz=512 sunit=0 blks, lazy-count=1
> realtime =none extsz=4096 blocks=0, rtextents=0
> 
> This combination does not work:
> root@jan:~# uname -a
> Linux jan 3.14-0.bpo.1-rt-amd64 #1 SMP PREEMPT RT Debian 3.14.7-1~bpo70+1 (2014-06-21) x86_64 GNU/Linux
> 
> Also kernel 3.10-0.bpo.3-rt-amd64 does not work
> 
> But this combination works:
>  root@jan:~# uname -a
> Linux jan 3.2.0-4-amd64 #1 SMP Debian 3.2.57-3+deb7u2 x86_64 GNU/Linux
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
