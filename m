Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9N2ZmlE158591 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 21:35:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3391C2F61A
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 19:37:22 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id wG7dFzbKE4camK1r for
	<xfs@oss.sgi.com>; Thu, 22 Oct 2009 19:37:22 -0700 (PDT)
Message-ID: <4AE116E1.5050008@sandeen.net>
Date: Thu, 22 Oct 2009 21:37:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>	<4ADF2EE8.6010700@sandeen.net>	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>	<4ADF4882.70106@sandeen.net>	<c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>	<4AE06BAE.8090706@sandeen.net>	<c2dcdfa40910220930l19a8dab0y88e80630a2453b39@mail.gmail.com>	<4AE08AED.1020702@sandeen.net>
	<c2dcdfa40910220955q586bdcabn268ddbc30d9b785d@mail.gmail.com>
In-Reply-To: <c2dcdfa40910220955q586bdcabn268ddbc30d9b785d@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

Amit Sahrawat wrote:
> that means it highely unlikey to get a fix for this issue :(
>  
> Yes, backporting just doest not suits for me.
>  
> I am trying to dig into the code, but really dont know if that's going 
> to be that easy.
>  
> Thanks Eric for all the help.
> W'll you know if I am able to fix this.

One other thought on the backporting side; RHEL5.4 now has xfs merged 
into a 2.6.18-ish kernel.  There are still some other supporting bits in 
that kernel, it's hardly vanilla 2.6.18, but if you want to try a 
backport route it might be one option.

Testing an upstream kernel w/ your testcase in an emulator would also be 
a reasonable thing to do, I think.

-eric

> Thanks & Regards,
> Amit Sahrawat
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
