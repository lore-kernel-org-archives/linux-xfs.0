Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LHh5As017831 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 12:43:05 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3E6628585
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 10:44:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JsjQwfxIfQ7DcDeY for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2009 10:44:36 -0700 (PDT)
Message-ID: <4ADF4882.70106@sandeen.net>
Date: Wed, 21 Oct 2009 12:44:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>	
	<4ADF2EE8.6010700@sandeen.net>
	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
In-Reply-To: <c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
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
> Thanks Eric,
>  
> Yes, I am able to get this for the same Inode and Block number.
>  
> xfs_check reports error for dir inode 128 missing leaf entries..(exact
> string I m missing), will provide you the details.
>  
> Using xfs_repair fixes the problem. But again the same operation leads
> to the crash.
> Even on a freshly formatted disk, I get this error.
>  
> Please let me know from where I can get this patch to try whether it
> fixes for me or not.


http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
