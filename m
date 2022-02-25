Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECBFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 21:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiBYVpq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 16:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiBYVpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 16:45:44 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE6561EF35A
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 13:45:11 -0800 (PST)
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 88FED88;
        Fri, 25 Feb 2022 15:44:16 -0600 (CST)
Message-ID: <fa5f8501-5b28-d38c-538d-21d63c621911@sandeen.net>
Date:   Fri, 25 Feb 2022 15:45:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 07/17] xfs_db: fix nbits parameter in fa_ino[48] functions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263813341.863810.8110691166064894260.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <164263813341.863810.8110691166064894260.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:22 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Use the proper macro to convert ino4 and ino8 field byte sizes to a bit
> count in the functions that navigate shortform directories.  This just
> happens to work correctly for ino4 entries, but omits the upper 4 bytes
> of an ino8 entry.  Note that the entries display correctly; it's just
> the command "addr u3.sfdir3.list[X].inumber.i8" that won't.
> 
> Found by running smatch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/faddr.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/faddr.c b/db/faddr.c
> index 81d69c94..0127c5d1 100644
> --- a/db/faddr.c
> +++ b/db/faddr.c
> @@ -353,7 +353,8 @@ fa_ino4(
>  	xfs_ino_t	ino;
>  
>  	ASSERT(next == TYP_INODE);
> -	ino = (xfs_ino_t)getbitval(obj, bit, bitsz(XFS_INO32_SIZE), BVUNSIGNED);
> +	ino = (xfs_ino_t)getbitval(obj, bit, bitize(XFS_INO32_SIZE),
> +			BVUNSIGNED);
>  	if (ino == NULLFSINO) {
>  		dbprintf(_("null inode number, cannot set new addr\n"));
>  		return;
> @@ -370,7 +371,8 @@ fa_ino8(
>  	xfs_ino_t	ino;
>  
>  	ASSERT(next == TYP_INODE);
> -	ino = (xfs_ino_t)getbitval(obj, bit, bitsz(XFS_INO64_SIZE), BVUNSIGNED);
> +	ino = (xfs_ino_t)getbitval(obj, bit, bitize(XFS_INO64_SIZE),
> +			BVUNSIGNED);
>  	if (ino == NULLFSINO) {
>  		dbprintf(_("null inode number, cannot set new addr\n"));
>  		return;
> 
