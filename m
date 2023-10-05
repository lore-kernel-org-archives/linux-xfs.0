Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A2AE9270F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbjJEOgo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbjJEOej (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:34:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF686526B
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 06:52:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD2AC32797;
        Thu,  5 Oct 2023 12:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696509302;
        bh=flPvSU9mvpVbZwYFgd3yOmXqgZpbe2UTiMf8XhVKmZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SpPZ9/i9YnL+tJJbaiXrI+KTfL8ALz7QZvcfFJ/OAi3wAdQSANzl1/dyqwbyvQoyY
         9uwquZ+PfZZ71C7zvRMJXNlhdG5GFaQCqhbBE5C6DlvsReVq4L0lDzNzuRTyHt2+P2
         P7/YlUAbsKu8GtJtCFWaGJFBabSGRe+dMrKEoFbSpgfF0cU7Zq7GTehzwGA1LuV+Uz
         vDxNM9mkY3vWbTR8vqjd985USsDuw0DuVOiGn2huguHnwe1w4w0CMGAdXxkBiOY3UG
         Ary5E+BaOeOihSgOs+AfA4sNm9MOo5Zhj/pdryNeJik3LaiBLwXDSHR9UiarUhG7VL
         0IZhB0Kz9k2Xg==
Date:   Thu, 5 Oct 2023 14:34:58 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] libfrog: don't fail on XFS_FSOP_GEOM_FLAGS_NREXT64
 in xfrog_bulkstat_single5
Message-ID: <20231005123458.m5wmqa7unwoxsjwa@andromeda>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <NF8rVwlXGIHrvtDGbhB883YSSmB9e5S4z8J5TkeebTXOqW5RK6Fe7rg78kd5YjVZhwXUvmrxgmkdTaK1HlRkbw==@protonmail.internalid>
 <169454758720.3539425.12997334128444146623.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454758720.3539425.12997334128444146623.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:39:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This flag is perfectly acceptable for bulkstatting a single file;
> there's no reason not to allow it.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Carlos

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  libfrog/bulkstat.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 0a90947fb29..c863bcb6bf8 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -53,7 +53,7 @@ xfrog_bulkstat_single5(
>  	struct xfs_bulkstat_req		*req;
>  	int				ret;
> 
> -	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
> +	if (flags & ~(XFS_BULK_IREQ_SPECIAL | XFS_BULK_IREQ_NREXT64))
>  		return -EINVAL;
> 
>  	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
> 
