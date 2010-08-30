Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7UNVW3X028906 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 18:31:32 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68B361236941
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 16:42:36 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id gfKqZa2STMFb2L5h for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 16:42:36 -0700 (PDT)
Message-ID: <4C7C3F78.5020500@sandeen.net>
Date: Mon, 30 Aug 2010 18:32:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: What should to do with ASSERT failed
References: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>	<4C7C26E8.9070308@sandeen.net>
	<AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
In-Reply-To: <AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: xfs@oss.sgi.com

Mike Gao wrote:
> Thanks very much for help. The kernel is pretty old, 2.6.19 but the xfs
> is pretty new.
> the block size is 512 and use mmap for test with write and read compare.
> (xfstest 074).
> 
> If I ignored this ASSERT(comment out), the test will failed. I guess
> because some pages never written to disk.
> 

FWIW, in your case, if you are not expecting to do IO like test 194
then maybe you'd be better off w/o this patch if it's causing problems
in more normal IO patterns ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
