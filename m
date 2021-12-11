Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1A3C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 00:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345451AbhLKAXf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 19:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345484AbhLKAXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 19:23:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B24C061714
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 16:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0600CE2E03
        for <linux-xfs@vger.kernel.org>; Sat, 11 Dec 2021 00:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBA2C00446;
        Sat, 11 Dec 2021 00:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639181995;
        bh=K7znI5oUCSxX7qqF1EziSRExA/O5MoTwepMQ8XHSwmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pu9e2hSSSkaLFkC5tg7K7pv4TxX+e1f76QbWdSJaCaUtwuiWZcDOpbapqRd99Mwve
         KFFlHFgQBPWIG2cQxiSxDdSRBdH7IZ5ZpFCna/6LWxEKVzOrFLnBbm0FDCb9sPvpvr
         ghYSxXgjenC4wO0JkDKE4j+sGYdk6ExSvMrE3yphSF9/JMjoHiZ2zFQH/x7gmXC5gj
         C28Hx49UzNFRei5bcCGs+xLj67ipmU+hPokbaXYTzgTE1XL87HARvaUO+hqs3hHGEN
         z3x4xFhYE6dCGZhCSTEjznR50hYQXfq5XOfM2Eduz4LpTeEXlGG/L9xvS/hW9aDIqv
         XOkVZTNBmGH3w==
Date:   Fri, 10 Dec 2021 16:19:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] mkfs.xfs(8): remove incorrect default inode
 allocator description
Message-ID: <20211211001954.GB1218082@magnolia>
References: <1639167697-15392-1-git-send-email-sandeen@sandeen.net>
 <1639167697-15392-3-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639167697-15392-3-git-send-email-sandeen@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 10, 2021 at 02:21:35PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> The "maxpct" section of the mkfs.xfs manpage has a gratuitous and
> incorrect description of the default inode allocator mode.
> 
> inode64 has been the default since 2012, as of
> 
> 08bf540412ed xfs: make inode64 as the default allocation mode
> 
> so the description is wrong. In addition, imaxpct is only
> tangentially related to inode allocator behavior, so this section
> of the man page is really the wrong place for discussion.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  man/man8/mkfs.xfs.8 | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index a7f7028..a67532a 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -568,22 +568,15 @@ can be allocated to inodes. The default
>  is 25% for filesystems under 1TB, 5% for filesystems under 50TB and 1%
>  for filesystems over 50TB.
>  .IP
> -In the default inode allocation mode, inode blocks are chosen such
> -that inode numbers will not exceed 32 bits, which restricts the inode
> -blocks to the lower portion of the filesystem. The data block
> -allocator will avoid these low blocks to accommodate the specified
> -maxpct, so a high value may result in a filesystem with nothing but
> -inodes in a significant portion of the lower blocks of the filesystem.
> -(This restriction is not present when the filesystem is mounted with
> -the
> -.I "inode64"
> -option on 64-bit platforms).
> -.IP
>  Setting the value to 0 means that essentially all of the filesystem
> -can become inode blocks, subject to inode32 restrictions.
> +can become inode blocks (subject to possible
> +.B inode32
> +mount option restrictions, see
> +.BR xfs (5)
> +for details.)
>  .IP
>  This value can be modified with
> -.IR xfs_growfs(8) .
> +.BR xfs_growfs (8).
>  .TP
>  .BI align[= value ]
>  This is used to specify that inode allocation is or is not aligned. The
> -- 
> 1.8.3.1
> 
