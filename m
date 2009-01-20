Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KELph0018522 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 08:21:52 -0600
Received: from mu-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE4001BA7210
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:21:49 -0800 (PST)
Received: from mu-out-0910.google.com (mu-out-0910.google.com
	[209.85.134.184]) by cuda.sgi.com with ESMTP id
	0ooqM2NjQrzJHcOD for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2009 06:21:49 -0800 (PST)
Received: by mu-out-0910.google.com with SMTP id w1so1740850mue.2
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:21:48 -0800 (PST)
Message-ID: <4975DE45.7050004@gmail.com>
Date: Tue, 20 Jan 2009 15:23:01 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
MIME-Version: 1.0
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
	<20090120121335.GA19182@infradead.org>
	<20090120124515.GA31838@infradead.org> <4975D88B.7020906@gmail.com>
	<20090120140514.GA2976@infradead.org>
In-Reply-To: <20090120140514.GA2976@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig pisze:
> On Tue, Jan 20, 2009 at 02:58:35PM +0100, Jacek Luczak wrote:
>> Good job! Is there some ,,quick'' fix?
> 
> The patch below makes it go away for me, alternatively just enable
> CONFIG_LBD.
> 
> 
> Index: linux-2.6/fs/xfs/xfs_types.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_types.h	2009-01-20 14:55:55.806068213 +0100
> +++ linux-2.6/fs/xfs/xfs_types.h	2009-01-20 14:56:01.437945154 +0100
> @@ -96,7 +96,7 @@ typedef	__uint64_t	xfs_dfilblks_t;	/* nu
>  /*
>   * Memory based types are conditional.
>   */
> -#if XFS_BIG_BLKNOS
> +#if 1 //XFS_BIG_BLKNOS
>  typedef	__uint64_t	xfs_fsblock_t;	/* blockno in filesystem (agno|agbno) */
>  typedef __uint64_t	xfs_rfsblock_t;	/* blockno in filesystem (raw) */
>  typedef __uint64_t	xfs_rtblock_t;	/* extent (block) in realtime area */
> 

I've applied it and now running ,,fixed'' kernel. What I've notice is:
$ LC_ALL=C df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1              20G  -40E   40E   -  /
/dev/sda5              20G  -23E   23E   -  /home
/dev/sda6              56G   56G  774M  99% /NORA
/dev/sda7              45G   44G  1.2G  98% /MAGAZYN

-Jacek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
