Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdDMMCG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 08:02:06 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E224AC0467E5
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 12:02:05 +0000 (UTC)
Date: Thu, 13 Apr 2017 08:01:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfsprogs: update man for metadump about dirty
 log/obfuscation issue
Message-ID: <20170413120152.GB24893@bfoster.bfoster>
References: <20170413081354.22170-1-jtulak@redhat.com>
 <20170413081354.22170-3-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170413081354.22170-3-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 10:13:54AM +0200, Jan Tulak wrote:
> This is something that should be documented, as it is not obvious to
> everyone.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  man/man8/xfs_metadump.8 | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
> index 3731d6a..1b40fb8 100644
> --- a/man/man8/xfs_metadump.8
> +++ b/man/man8/xfs_metadump.8
> @@ -59,6 +59,12 @@ options where
>  are not obfuscated. Names between 5 and 8 characters in length inclusively
>  are partially obfuscated.
>  .PP
> +Log recovery of an obfuscated metadata image can leak
> +unobfuscated metadata and/or cause image corruption. Please mount
> +the source filesystem to clean the log or disable obfuscation, if possible.
> +If you have to obfuscate an image with a dirty log, tell about it to whoever
> +you are sending the image to.
> +.PP

We might want the man page content to be a bit more descriptive than
what xfs_metadump actually emits for a warning. For example:

"xfs_metadump does not obfuscate data in the filesystem log. Log
recovery of an obfuscated metadump image may expose unobfuscated
metadata and/or cause filesystem corruption. It is recommended to
disable obfuscation for filesystems that must be captured with a dirty
log."

... but that's just my .02. Feel free to reword that and solicit more
feedback from others too. Another thought here could be to intimate that
if an obfuscated+dirty log metadump image is truly required, it is the
user responsibility to verify that the resulting image has not been
corrupted by the metadump process and does not contain sensitive
metadata (as opposed to telling the user to simply tell the recipient of
the image about it).

Brian

>  .B xfs_metadump
>  should not be used for any purposes other than for debugging and reporting
>  filesystem problems. The most common usage scenario for this tool is when
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
