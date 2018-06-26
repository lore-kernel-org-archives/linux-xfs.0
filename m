Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33093 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752730AbeFZLVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 07:21:00 -0400
Received: by mail-wr0-f193.google.com with SMTP id k16-v6so16862903wro.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jun 2018 04:20:59 -0700 (PDT)
Date: Tue, 26 Jun 2018 13:20:56 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfsprogs: Remove barrier/nobarrier mount options from
 xfs.5
Message-ID: <20180626112056.k6pwswz3bhkwlbrv@odin.usersys.redhat.com>
References: <7105a6a3-bd16-53be-2e4f-d1ec8a491d20@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7105a6a3-bd16-53be-2e4f-d1ec8a491d20@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 25, 2018 at 07:06:51PM -0500, Eric Sandeen wrote:
> Remove the now-removed barrier/nobarrier mount options from
> the xfs.5 manpage.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Although the option is scheduled to be removed in 4.19, I think it's worth to
remove it from xfsprogs before the mount option removal patch lands in kernel,
so:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> ---
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index 745dad4..628bfc3 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -132,20 +132,6 @@ by the filesystem.
>  CRC enabled filesystems always use the attr2 format, and so
>  will reject the noattr2 mount option if it is set.
>  .TP
> -.BR barrier | nobarrier
> -Note: This option has been
> -.B deprecated
> -as of kernel v4.10; in that version, integrity operations are
> -always performed and the mount option is ignored.  These mount
> -options will be removed no earlier than kernel v4.15.
> -.sp
> -Enables/disables the use of block layer write barriers for
> -writes into the journal and for data integrity operations.
> -This allows for drive level write caching to be enabled, for
> -devices that support write barriers.
> -.sp
> -Barriers are enabled by default.
> -.TP
>  .BR discard | nodiscard
>  Enable/disable the issuing of commands to let the block
>  device reclaim space freed by the filesystem.  This is
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
