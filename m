Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8683C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 12:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 681CC21D7F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 12:51:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ejv1Iaxe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKLMv5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 07:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgKLMv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 07:51:57 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D11C0613D1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 04:51:56 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i7so4100507pgh.6
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 04:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6P8CH300eAB1fASzSpZTbw+sEYZ0bvfF7KOk0y4iHb8=;
        b=Ejv1IaxeE6OJ+ryOvfx08NsMYAEAuy2uowm544hpsESZSzR8SOxImmNXoxUfTmADqa
         10pB8du0FMeIW5fIwy5FqP8uh3Rvr50DVcHTuYst7/je18SuEbNx8TG8mUwUjz3ZnHTR
         ExmK7VEplEZmf488gtSpYKQvH5UY41JmnFbArLLynziWRdbaj2XQ+4qRFWmkRwsboBz9
         z40mriaktPQ2glelK6Ac4vI0NXrTM9j9Yo8YIRpRzQPFhSdDrwEjJMa+KKDFZzLJ7kWX
         9FgnmJqJNtLsBE1KYqKwy8IyAbiRlMg4U06ZGBdoZDnygCuXsj6zGLoBJI/jpodQ6yux
         6bcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6P8CH300eAB1fASzSpZTbw+sEYZ0bvfF7KOk0y4iHb8=;
        b=KKFJt085TQ6sdZDc6uaVGMfSMWBXcDbVZwIfgGClDKnwXNUlWwBH6noox9FOF8vDvG
         KBIcAkg2Y7fD9mK20g+FFTuR2VvVDpED2FR/QQ9Ltw4LdruqApcJYnFgWPulcxYUC2rg
         WfHH9EenmUOHbGCPNZBbF4JgJEsZXQ9451+cKa36CEjaQhFOfNK2Yx1m1X+tUbh5KvM7
         g2zEak1TNi2u/0bzoqHHlIfLl4ZQHryydvQ6lJgbApfvPVlCiyAYEdBjRAWwKJkN3HwB
         uy4RIB7AFrSXvXb51UMRPWoKR8XgWZFzQQhDn1+gr3VawcDqBydJTLPW2wDvght/YP7k
         pNsQ==
X-Gm-Message-State: AOAM533xg0unPENlfxoYHq+gJHS7G6EdJiH5btoi3LK6D3du0HbMZWB3
        w8Ywx0tJ4GrLCr6tdBv+9Ew=
X-Google-Smtp-Source: ABdhPJxfH8dWySuve0RIdMvAsO85sDPXslwnSMCbYy/jbgL827U7MlMHiaEUlIptD6jSlzoyPzsRBA==
X-Received: by 2002:a63:4c24:: with SMTP id z36mr11603579pga.432.1605185515620;
        Thu, 12 Nov 2020 04:51:55 -0800 (PST)
Received: from garuda.localnet ([122.179.88.142])
        by smtp.gmail.com with ESMTPSA id f4sm6715707pjs.8.2020.11.12.04.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 04:51:54 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/4] xfs: fix brainos in the refcount scrubber's rmap fragment processor
Date:   Thu, 12 Nov 2020 18:21:52 +0530
Message-ID: <3965877.p3O8HGrD7x@garuda>
In-Reply-To: <160494585913.772802.17231950418756379430.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia> <160494585913.772802.17231950418756379430.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 9 November 2020 11:47:39 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix some serious WTF in the reference count scrubber's rmap fragment
> processing.  The code comment says that this loop is supposed to move
> all fragment records starting at or before bno onto the worklist, but
> there's no obvious reason why nr (the number of items added) should
> increment starting from 1, and breaking the loop when we've added the
> target number seems dubious since we could have more rmap fragments that
> should have been added to the worklist.
> 
> This seems to manifest in xfs/411 when adding one to the refcount field.
> 
> Fixes: dbde19da9637 ("xfs: cross-reference the rmapbt data with the refcountbt")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/refcount.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index beaeb6fa3119..dd672e6bbc75 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -170,7 +170,6 @@ xchk_refcountbt_process_rmap_fragments(
>  	 */
>  	INIT_LIST_HEAD(&worklist);
>  	rbno = NULLAGBLOCK;
> -	nr = 1;
>  
>  	/* Make sure the fragments actually /are/ in agbno order. */
>  	bno = 0;
> @@ -184,15 +183,14 @@ xchk_refcountbt_process_rmap_fragments(
>  	 * Find all the rmaps that start at or before the refc extent,
>  	 * and put them on the worklist.
>  	 */
> +	nr = 0;
>  	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
> -		if (frag->rm.rm_startblock > refchk->bno)
> -			goto done;
> +		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
> +			break;

In the case of fuzzed refcnt value of 1, The condition "nr > target_nr" causes
"nr != target_nr" condition (appearing after the loop) to evaluate to true
(since atleast two rmap entries would be present for the refcount extent)
which in turn causes xchk_refcountbt_xref_rmap() to flag the data structure as
corrupt. Please let me know if my understanding of the code flow is correct?

>  		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
>  		if (bno < rbno)
>  			rbno = bno;
>  		list_move_tail(&frag->list, &worklist);
> -		if (nr == target_nr)
> -			break;
>  		nr++;
>  	}
>  
> 
> 


-- 
chandan



