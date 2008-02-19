Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 20:36:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1J4aBbo032740
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 20:36:15 -0800
Message-ID: <47BA5CBF.1010307@sgi.com>
Date: Tue, 19 Feb 2008 15:36:15 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs: convert beX_add to beX_add_cpu patch(2.6.25-rc2)
References: <200802180257.AA00066@TNESB07328.wm.jp.nec.com>
In-Reply-To: <200802180257.AA00066@TNESB07328.wm.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Cc: t-sato@yk.jp.nec.com, xfs-oss <xfs@oss.sgi.com>

Hi Utako,

Thanks for the heads-up. I believe Lachlan is going to push that
change into our development tree (which will sync with cvs).
As we have number of people working on XFS and interested in it,
can you please also include the XFS oss list on similar emails.

Kind regards,
Tim.

Utako Kusaka wrote:
> Hi Timothy,
> 
> It seems that the following patch is not added to XFS cvs tree yet.
> 
> ChangeLog-2.6.25-rc2:
> commit 413d57c9907c72ed608df2be72ef8ed13a3eeb46
> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date:   Wed Feb 13 15:03:29 2008 -0800
> 
>     xfs: convert beX_add to beX_add_cpu (new common API)
>     
>     remove beX_add functions and replace all uses with beX_add_cpu
>     
>     Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>     Cc: Mark Fasheh <mark.fasheh@oracle.com>
>     Reviewed-by: Dave Chinner <dgc@sgi.com>
>     Cc: Timothy Shimmin <tes@sgi.com>
>     Cc: <linux-ext4@vger.kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> 
> + xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch added to -mm tree
> http://marc.info/?l=linux-ext4&m=119974956926515&w=4
> 
> Regards,
> 
> Utako.
