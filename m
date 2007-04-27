Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 20:56:15 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3R3u8fB005288
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 20:56:11 -0700
Subject: Re: [PATCH] Fix segmentation fault when using xfs_quota state
	command.
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200704270240.AA05279@TNESG9305.tnes.nec.co.jp>
References: <200704270240.AA05279@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 13:58:22 +1000
Message-Id: <1177646302.6273.386.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

On Fri, 2007-04-27 at 11:40 +0900, Utako Kusaka wrote:
> +	if (!fs_count)
> +		return 0;
> +

Is the segfault due to this line in state.c?
237             else if (fs_path->fs_flags & FS_MOUNT_POINT)

If so, a fix that is more clear to the reader might be:

- else if (fs_path->fs_flags & FS_MOUNT_POINT)
+ else if (fs_path && fs_path->fs_flags & FS_MOUNT_POINT)

This keeps the fix alongside the problematic access to fs_path.

cheers.

-- 
Nathan
