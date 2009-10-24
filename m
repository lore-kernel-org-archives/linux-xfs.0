Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9OEhxQt042586 for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 09:44:00 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F31A3453A
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2009 07:45:35 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id URyfPTOXCia4E0PB for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2009 07:45:35 -0700 (PDT)
Message-ID: <4AE3130E.8080409@sandeen.net>
Date: Sat, 24 Oct 2009 09:45:34 -0500
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
	<4AE08AED.1020702@sandeen.net>	
	<c2dcdfa40910220955q586bdcabn268ddbc30d9b785d@mail.gmail.com>	
	<4AE116E1.5050008@sandeen.net>
	<c2dcdfa40910240128n7895d5c1s92fb88952a4bddcf@mail.gmail.com>
In-Reply-To: <c2dcdfa40910240128n7895d5c1s92fb88952a4bddcf@mail.gmail.com>
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
> Hi Eric,
>  
> Can this issue be related to some timing issue/synchronization with disk?
> Test case is something like this..
>  
> I create thousands of files... (simply keep touching to create '0' bytes 
> files from a shell script) and in between I do Ctrl + C, to stop.
> Then, I issue command to remove files (rm -rf *) and crash appears. 
>  
> Thanks & Regards,
> Amit Sahrawat
> 

Whatever it is, I think it must be arch-dependent, I don't think such a 
thing would fail on x86 - I kind of doubt that it's timing, but it's 
hard to say.

Have you tested in an emulator yet?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
