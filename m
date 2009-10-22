Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MGcg3Z114077 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:38:42 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEB6C2DA79
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:40:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P0DypntWquFUXwlS for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:40:17 -0700 (PDT)
Message-ID: <4AE08AED.1020702@sandeen.net>
Date: Thu, 22 Oct 2009 11:40:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>	
	<4ADF2EE8.6010700@sandeen.net>	
	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>	
	<4ADF4882.70106@sandeen.net>	
	<c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>	
	<4AE06BAE.8090706@sandeen.net>
	<c2dcdfa40910220930l19a8dab0y88e80630a2453b39@mail.gmail.com>
In-Reply-To: <c2dcdfa40910220930l19a8dab0y88e80630a2453b39@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

Amit Sahrawat wrote:
> I am already using that patch.
> Other than using higher XFS version, can I try any other thing?
>  
> I cannot directly use higher XFS version, I will have to backport the
> changes for higher to the kernel I am using  because of dependencies.
> 

backporting xfs would be hard; I was hoping that perhaps you could just
boot a newer kernel, though I know w/ vendor arm kernels that can be tough.

There are drawbacks to not getting machine support upstream... :)

I don't really have other things for you to try, and don't have a lot of
time to debug 3 year old kernels either...  :(

You could try your arm testcase in a qemu emulator on a new kernel; if
that shows the same problem I'll be much more interested & motivated...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
