Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KEFKEp018216 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 08:15:22 -0600
Received: from mail-bw0-f13.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A6AC1829A3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:15:17 -0800 (PST)
Received: from mail-bw0-f13.google.com (mail-bw0-f13.google.com
	[209.85.218.13]) by cuda.sgi.com with ESMTP id j1Xkv7735B8dxff8
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:15:17 -0800 (PST)
Received: by bwz6 with SMTP id 6so229855bwz.20
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:15:16 -0800 (PST)
Message-ID: <4975DC24.5080806@gmail.com>
Date: Tue, 20 Jan 2009 15:13:56 +0100
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

Applied. Thanks. Will do some tests with your script.

-Jacek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
