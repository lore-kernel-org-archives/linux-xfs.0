Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p184gLP7092168 for <xfs@oss.sgi.com>; Mon, 7 Feb 2011 22:42:22 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 364AC2BB446
	for <xfs@oss.sgi.com>; Mon,  7 Feb 2011 20:44:54 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id wQVSf0sCg3aA9vUI for
	<xfs@oss.sgi.com>; Mon, 07 Feb 2011 20:44:54 -0800 (PST)
Message-ID: <4D50CA45.8070807@sandeen.net>
Date: Mon, 07 Feb 2011 22:44:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: segmentation fault during mount
References: <02b401cbc6b6$5b7ac0b0$12704210$@samsung.com>
In-Reply-To: <02b401cbc6b6$5b7ac0b0$12704210$@samsung.com>
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
To: Ryan Roh <unisist.roh@samsung.com>
Cc: xfs@oss.sgi.com

On 2/7/11 5:01 AM, Ryan Roh wrote:
> Dear Members,
> 
> I'm using XFS based on STMicro SH4 based chip (STi7105).
> 
> and I have some issue on xfs log mounting.
> 

Were the errors after any sort of harsh testing of the filesystem, such 
as usb disconnects or power off?

Or was this after a clean unmount?

-Eric

> 
> 1. chip : sh4 STi7105
> 
> 2. HDD : 320GB USB HDD USB 2.0 port.
> 
> 3. OS : Linux 2.6.23.17 + patch for fixing cache aliasing issue.
> 
> 4. XFSProgs version : 3.1.1
> 
>  
> 
> mounting and repairing log in the below. This segmentation fault is caused by
> 
> the assert in xfs_alloc_increment function of xfs_alloc_btree.c file. The btree
> 
> level is equal to root level in the below code.
> 
>  
> 
>     /*
> 
>      * If we went off the root then we are seriously confused.
> 
>      */
> 
>     ASSERT(lev < cur->bc_nlevels);
> 
>  

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
