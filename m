Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44571C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF5B61039
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhG1VPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhG1VPh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 698E16101B;
        Wed, 28 Jul 2021 21:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506935;
        bh=IF+oS7UC7ho97wHh63olpNbTilnHcpDVBI65OqOZJ8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WcKYnQFsco85PMZsaqIcYTB4RkgSTJYlUVjNvebMQWpkk/PXL8otpHFOBYTKmxytP
         stY34I0KLpaJlkuTLp9e6hNfiEDQSnbOPV7ouyhuNWbY5iTRxbphGHdh1AI6jt2SN5
         o7eiiG6fuUU8KWBUHwC73Wb4VuFOslW7S75ISVzQcLu6QmPXlFyMuCgAZpAzpmRIPO
         RgaFgFm0mBMFNsVeOxxfM75Pdt2O4/UNBZL3V6Q5h+suT+6b9KUW+eW+uMOCdzKknx
         A9yRSWPMKGTU2cLNY7rdueDC5okEKWviQ33zWUSMHf/04Ilxp8l064RTcYu66Wktal
         rgQr5MBVyNTew==
Date:   Wed, 28 Jul 2021 14:15:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] quota: allow users to truncate group and project quota
 files
Message-ID: <20210728211535.GI3601443@magnolia>
References: <20210728200208.GH3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728200208.GH3601443@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eric asked me to resend all the pending patches for 5.13, so I might as
well NAK this and tell everyone to watch for the imminent patchbomb.

--D

On Wed, Jul 28, 2021 at 01:02:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 79ac1ae4, I /think/ xfsprogs gained the ability to deal with
> project or group quotas.  For some reason, the quota remove command was
> structured so that if the user passes both -g and -p, it will only ask
> the kernel truncate the group quota file.  This is a strange behavior
> since -ug results in truncation requests for both user and group quota
> files, and the kernel is smart enough to return 0 if asked to truncate a
> quota file that doesn't exist.
> 
> In other words, this is a seemingly arbitrary limitation of the command.
> It's an unexpected behavior since we don't do any sort of parameter
> validation to warn users when -p is silently ignored.  Modern V5
> filesystems support both group and project quotas, so it's all the more
> surprising that you can't do group and project all at once.  Remove this
> pointless restriction.
> 
> Found while triaging xfs/007 regressions.
> 
> Fixes: 79ac1ae4 ("Fix xfs_quota disable, enable, off and remove commands Merge of master-melb:xfs-cmds:29395a by kenmcd.")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  quota/state.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/quota/state.c b/quota/state.c
> index 3ffb2c88..43fb700f 100644
> --- a/quota/state.c
> +++ b/quota/state.c
> @@ -463,7 +463,8 @@ remove_extents(
>  	if (type & XFS_GROUP_QUOTA) {
>  		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
>  			return;
> -	} else if (type & XFS_PROJ_QUOTA) {
> +	}
> +	if (type & XFS_PROJ_QUOTA) {
>  		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
>  			return;
>  	}
