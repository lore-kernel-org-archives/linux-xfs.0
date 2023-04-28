Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9BEC77B60
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 06:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjD1G5n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Apr 2023 02:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjD1G5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2023 02:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7BA198
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 23:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B4C464141
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 06:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D99C433EF;
        Fri, 28 Apr 2023 06:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682665060;
        bh=8OASmgtA4mU03PH6Vw+K9w/MNhOKHqIZABamwqughlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tv1h5KdEC5BXLt+s/L1Vk/ua+4KfPMNHPLMDpkYSYJHMIhuxOboUZvgncuLv3iz2+
         5d8JbOxxDrp5mudfUOCM6PaDzAaB9c6ukHKBJoQfh9ge/fJzR8XlEF3b5kyyL0qkAe
         zFEUPEZR/b9AGpXUBblouVrmHlmrmr0Z0JC1kfzR2dW213iVCwrvnHp9pEPgAKMzny
         IW0f0h1q7tAVI9trIs47e8PQWBKx3QLVw/fdASSt2rAI8Nt5girnLXY3mMS+azJCbD
         Ckehq1xxGm3srY5Atd3mcwabJOfnCshCc0ojeiVS+6gieQxMMz/CfoKmpy9dcpcPQm
         9GP1M8PsfYwTA==
Date:   Fri, 28 Apr 2023 08:57:36 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_db: fix broken logic in error path
Message-ID: <20230428065736.2kdhl7t6zoapedui@andromeda>
References: <dVNtpBd6-O_AvMmCUgAc-vlNbr0x-1IgIQEPpoWYEipz8Jor5TfX6Z4vsKsLU3R38WCua0jJqVmmgSL_Rp62lA==@protonmail.internalid>
 <20230427190233.GC59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427190233.GC59213@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 12:02:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> smatch complains proceeding into the if body if leaf is a null pointer:
> 
> check.c:3614 process_leaf_node_dir_v2_int() warn: variable dereferenced before check 'leaf' (see line 3518)
> 
> However, the logic here is misleading and broken -- what we're trying to
> do is switch between the v4 and v5 variants of the directory check.
> We're using @leaf3 being a null pointer (or not) to determine v4 vs. v5,
> so the "!" part of the comparison is correct, but the variable used
> (leaf) is not.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks correct.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  db/check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/check.c b/db/check.c
> index 964756d0..fdf1f6a1 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3452,7 +3452,7 @@ process_leaf_node_dir_v2_int(
>  				 id->ino, dabno, stale,
>  				 be16_to_cpu(leaf3->hdr.stale));
>  		error++;
> -	} else if (!leaf && stale != be16_to_cpu(leaf->hdr.stale)) {
> +	} else if (!leaf3 && stale != be16_to_cpu(leaf->hdr.stale)) {
>  		if (!sflag || v)
>  			dbprintf(_("dir %lld block %d stale mismatch "
>  				 "%d/%d\n"),

-- 
Carlos Maiolino
