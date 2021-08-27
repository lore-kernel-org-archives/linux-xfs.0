Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA5EC4320E
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53FD260F5B
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Aug 2021 15:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244513AbhH0Pt4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 Aug 2021 11:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244511AbhH0Pty (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Aug 2021 11:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BFA360FC4;
        Fri, 27 Aug 2021 15:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630079345;
        bh=JcTG4s3cpeaIpONvdWxqebDMGaqTEtrjDjJwXbOz7Rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aI+7rxdEDAXzHazhxdWwffFvnWuw/C9ndennCfK/muROR0fs22e8q1qGATlQc4flv
         v6RvBYPFMnYzOs2Lh8M2KFokpcroTlU6vY0JafTLMMy5/I0u+lcBSiYz+v0M3eCsgN
         McRdOslTFqjQawajF4/A+4GbjONMBLgYoVGDEvNT6nXtGAbo/iGMCzzqsl6Zpgbp0I
         Tbkq4W/98rb7S7nvJoiICkZJVdcVIOAUYBrzpAt/yQCl99mZdPUAieSrHV/DGehBPH
         mycxghIspzfLlDEr0Hqibz+tfjQ0/G2MZtx8fW2aG4CAN0ZL9iaxwx2OPv3pp3+3gW
         fZ859aesosejw==
Date:   Fri, 27 Aug 2021 08:49:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Bill O'Donnell <bodonnel@redhat.com>
Subject: Re: [PATCH] mkfs.xfs.8: clarify DAX-vs-reflink restrictions in the
 mkfs.xfs man page
Message-ID: <20210827154905.GP12640@magnolia>
References: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ebcf23-9e32-e219-ef8b-9aa7ab2444c2@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 27, 2021 at 10:39:18AM -0500, Eric Sandeen wrote:
> Now that we have the tristate dax mount options, it is possible
> to enable DAX mode for non-reflinked files on a reflink-capable
> filesystem.  Clarify this in the mkfs.xfs manpage.
> 
> Reported-by: Bill O'Donnell <bodonnel@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index a7f70285..84ac50e8 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -316,12 +316,20 @@ option set. When the option
>  is used, the reference count btree feature is not supported and reflink is
>  disabled.
>  .IP
> -Note: the filesystem DAX mount option (
> +Note: the filesystem-wide DAX mount options (
>  .B \-o dax
> -) is incompatible with
> -reflink-enabled XFS filesystems.  To use filesystem DAX with XFS, specify the
> +and
> +.B \-o dax=always
> +) are incompatible with
> +reflink-enabled XFS filesystems.  To use filesystem-wide DAX with XFS, specify the
>  .B \-m reflink=0
>  option to mkfs.xfs to disable the reflink feature.
> +Alternatey, use the

"Alternately..."

> +.B \-o dax=inode
> +mount option to selectively enable DAX mode on non-reflinked files.

/me wonders if this is dangerously close to wading into the muck that is
"Use dax=inode or even no dax option at all, then make sure nobody
shares your file's data blocks to set the DAX fsxattr flag on the file,
and /then/ you can have DAX."

<shrug> But the only blocker I can see is the misspelling above.

--D

> +See
> +.BR xfs (5)
> +for more information.
>  .RE
>  .PP
>  .PD 0
> 
