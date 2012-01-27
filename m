Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RLGLc9253361 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 15:16:21 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 5V671mgKd6mgS4Rz for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 13:16:20 -0800 (PST)
Message-ID: <4F231423.8050900@sandeen.net>
Date: Fri, 27 Jan 2012 15:16:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 273 274 275: do test in dedicated dir and leave
	test files in it
References: <1326388815-21181-1-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1326388815-21181-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: xfs@oss.sgi.com

On 1/12/12 11:20 AM, Eryu Guan wrote:
> Do all testings in dedicated dir($SCRATCH_MNT/$seq) instead of
> $SCRATCH_MNT and don't remove test files in _cleanup() for debug
> purpose.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
...


> @@ -58,8 +60,9 @@ umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
> -rm -rf $SCRATCH_MNT/*
> -cd $SCRATCH_MNT
> +rm -rf $WORK_DIR
> +mkdir -p $WORK_DIR

Seems like the simplest solution is to just not rm -rf _anything_ immediately
after the mkfs.  Why bother?  All it does is remove lost+found/ ... wouldn't
it be simpler to just remove that one line?

-Eric

> +cd $WORK_DIR
>  
>  dd if=/dev/zero of=tmp1 bs=4K count=1 >/dev/null 2>&1
>  if [ $? -ne 0 ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
