Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QDNEYM144685 for <xfs@oss.sgi.com>; Tue, 26 May 2009 08:23:14 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF7301001CF7
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 06:29:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id cH0RcPzcWxE0drQt for
	<xfs@oss.sgi.com>; Tue, 26 May 2009 06:29:16 -0700 (PDT)
References: <20090526120250.GA447@infradead.org>
Message-Id: <6A03430F-1F6A-4F35-9557-D77AA35D79A8@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20090526120250.GA447@infradead.org>
Mime-Version: 1.0 (iPod Mail 5H11)
Subject: Re: [PATCH] xfstests: only run 164 for xfs
Date: Tue, 26 May 2009 08:22:05 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>



On May 26, 2009, at 7:02 AM, Christoph Hellwig <hch@infradead.org>  
wrote:

> Test 164 uses the xfs_io bmap subcommand which only works for XFS,
> so don't offer it for nfs and udf.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
>
> Index: xfstests-dev/164
> ===================================================================
> --- xfstests-dev.orig/164    2009-05-26 12:00:00.000000000 +0000
> +++ xfstests-dev/164    2009-05-26 12:00:54.000000000 +0000
> @@ -54,8 +54,7 @@
>
> # real QA test starts here
>
> -# Modify as appropriate.
> -_supported_fs xfs udf nfs
> +_supported_fs xfs
> _supported_os IRIX Linux
>
> testfile=$TEST_DIR/file.$seq
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
