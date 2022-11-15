Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DB8C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 03:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiKODN2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 22:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiKODNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 22:13:23 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E28BF69
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:13:22 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c2so11921849plz.11
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 19:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zHzujr2Nc13A2hYoy3pbEIgGNNAN9gyDumhPf64eN/w=;
        b=hhPheOmxJR4BIO5T158aaX1lcOeVoUSMO5EpG6cT7T3FTMwpBZEDNAruXk4X9ov2Ml
         GDMSGcSswJKiZFe8ev0LuSaN5HKtzAhuKzh9bM9L86YBIvouIBDuJZm/a6YB5BYIRHZf
         966RSI0WG7WbMY5U1+5tbTTrL1lmy/vqoQKzUlc/RHLHlZbCzD30kN//bhpYWEtrg2/P
         5TG4FGw5pp1b60W76MuQOkvwjFrVS5hJfPPydqNL8R/ECucaRMbS76r95FGClDYvDpkx
         O+h79Cilg38qdAeC/J1jRz/hhf/69IuQ7vPl1pM6csFPIJKGyJVRWpCk11WouNRvyXJ4
         xtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHzujr2Nc13A2hYoy3pbEIgGNNAN9gyDumhPf64eN/w=;
        b=2cpB2bxTDMj2F0p3bJn2uQLz/n/K7yaMy2auj24YeowR9Po41nNzayBgHrNn3sL4XB
         tttcuzvBNl4aC9SAsBkVYfjRQ72dVKu8Ei8vIUi5efps4i4lv7314KkRVaa1y2WCWq6p
         +j9XOjXHV6INh9K+SqLI5UQCJgKgA18AoJsDOlC6aEGTE5IyeRHVNGG5nE+7AImH6hWa
         G5jiwf1sy2UTkLB9DKsak+DkW0MIqwoDtf90bTwBUAOB0m5Vr0djsSIqCX1YUhdr7eTn
         9StyhIlIPny678VOMewfSXPn3L7cyZh7Wnx3riWzMmWfeKUQotKbbFDQo3IdYe6kZhYh
         hFzw==
X-Gm-Message-State: ANoB5pn2JXF4A1wAG82JJ3FVfNvSdjS+0fklQ6SNLmE/ZL4I0QnlgDXB
        ewCQYmbqrSzpuuT4n66sZI5kZA==
X-Google-Smtp-Source: AA0mqf6FCEL6Ikua2cLCTnYe6lHk1siWyB67189uyMoTc93zBtq0+LVtk5qig+h66QFskLYhjExmuw==
X-Received: by 2002:a17:902:d191:b0:174:a0e6:428 with SMTP id m17-20020a170902d19100b00174a0e60428mr2062659plb.124.1668482001983;
        Mon, 14 Nov 2022 19:13:21 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id i188-20020a6254c5000000b0056e0ff577edsm7455052pfb.43.2022.11.14.19.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 19:13:21 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oumNy-00ELuv-P6; Tue, 15 Nov 2022 14:13:18 +1100
Date:   Tue, 15 Nov 2022 14:13:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: manage inode DONTCACHE status at irele time
Message-ID: <20221115031318.GW3600936@dread.disaster.area>
References: <166473482923.1084685.3060991494529121939.stgit@magnolia>
 <166473482943.1084685.12751834399982118437.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473482943.1084685.12751834399982118437.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Right now, there are statements scattered all over the online fsck
> codebase about how we can't use XFS_IGET_DONTCACHE because of concerns
> about scrub's unusual practice of releasing inodes with transactions
> held.
> 
> However, iget is the wrong place to handle this -- the DONTCACHE state
> doesn't matter at all until we try to *release* the inode, and here we
> get things wrong in multiple ways:
> 
> First, if we /do/ have a transaction, we must NOT drop the inode,
> because the inode could have dirty pages, dropping the inode will
> trigger writeback, and writeback can trigger a nested transaction.
> 
> Second, if the inode already had an active reference and the DONTCACHE
> flag set, the icache hit when scrub grabs another ref will not clear
> DONTCACHE.  This is sort of by design, since DONTCACHE is now used to
> initiate cache drops so that sysadmins can change a file's access mode
> between pagecache and DAX.
> 
> Third, if we do actually have the last active reference to the inode, we
> can set DONTCACHE to avoid polluting the cache.  This is the /one/ case
> where we actually want that flag.
> 
> Create an xchk_irele helper to encode all that logic and switch the
> online fsck code to use it.  Since this now means that nearly all
> scrubbers use the same xfs_iget flags, we can wrap them too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ok, I can see what needs to be done here. It seems a bit fragile,
but I don't see a better way at the moment.

That said...

> diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
> index ab182a5cd0c0..38ea04e66468 100644
> --- a/fs/xfs/scrub/parent.c
> +++ b/fs/xfs/scrub/parent.c
> @@ -131,7 +131,6 @@ xchk_parent_validate(
>  	xfs_ino_t		dnum,
>  	bool			*try_again)
>  {
> -	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_inode	*dp = NULL;
>  	xfs_nlink_t		expected_nlink;
>  	xfs_nlink_t		nlink;
> @@ -168,7 +167,7 @@ xchk_parent_validate(
>  	 * -EFSCORRUPTED or -EFSBADCRC then the parent is corrupt which is a
>  	 *  cross referencing error.  Any other error is an operational error.
>  	 */
> -	error = xfs_iget(mp, sc->tp, dnum, XFS_IGET_UNTRUSTED, 0, &dp);
> +	error = xchk_iget(sc, dnum, &dp);
>  	if (error == -EINVAL || error == -ENOENT) {
>  		error = -EFSCORRUPTED;
>  		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
> @@ -253,7 +252,7 @@ xchk_parent_validate(
>  out_unlock:
>  	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
>  out_rele:
> -	xfs_irele(dp);
> +	xchk_irele(sc, dp);
>  out:
>  	return error;
>  }

Didn't you miss a couple of cases here? THe current upstream code
looks like:

.......
237         /* Drat, parent changed.  Try again! */
238         if (dnum != dp->i_ino) {
239                 xfs_irele(dp);
240                 *try_again = true;
241                 return 0;
242         }
243         xfs_irele(dp);
244
245         /*
246          * '..' didn't change, so check that there was only one entry
247          * for us in the parent.
248          */
249         if (nlink != expected_nlink)
250                 xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
251         return error;
252
253 out_unlock:
254         xfs_iunlock(dp, XFS_IOLOCK_SHARED);
255 out_rele:
256         xfs_irele(dp);
257 out:
258         return error;
259 }

So it looks like you missed the conversion at lines 239 and 243. Of
course, these may have been removed in a prior patchset I've looked
at and forgotten about, but on the surface this looks like missed
conversions.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
