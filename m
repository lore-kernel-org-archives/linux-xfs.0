Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BABA612EC
	for <linux-xfs@vger.kernel.org>; Thu,  4 Apr 2024 07:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712215960; cv=none; b=uNI2hjGqMg67918Us+EjzigIiXOak8s68OXTRipyuwhoTD8ITpXqslxKB92iKL2mjL5mzpFSzHGW94uBKjIJDxzv6T0jwE1VhF41VIPMCbCmzX30GgZACXa1tmt9KivYNwpJYoOhtqhgJRKXx9x1rXxeWi/NAJojzORZ2n3CdO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712215960; c=relaxed/simple;
	bh=+AJ/jxDXbkkA6YX4UAFKVWP3Ymf+pVVpxj/39riMwBs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gg3IKDy0TBC2tSf4tFj0weqk1N4VInBf8mqqR19MxpSgCK/zr5CyQ1yDIJyjtwnWsXLuAb1cvfm0lJwTO84clZ5t+lph+M6L321itvZy0Hwo4+5BXgx63XrjtUD54L4/m5yLO4yREXr6GoXH3iXx8El8qmfl527WWpjcXVu/Z1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qL1WQSG+; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qL1WQSG+"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a4e34d138f9so89458266b.2
        for <linux-xfs@vger.kernel.org>; Thu, 04 Apr 2024 00:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712215956; x=1712820756; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Vv1p+RJN8SH4JBxojGl8pZ97ohWKJHxu7WwKK9Pf4k=;
        b=qL1WQSG+V98baSo8plwcjGQq7vTt0+lKcSP8aOOQOe8ZaumDiuPfUgPXL9mBSAqnhv
         vZ2Xo4DQAWVzHLmgwEMhizI0PwPaBJI9MxX93zEBQUFBhKd4cjsWSaXK9NX6JFOzNczh
         HdNoj6EHjLB/jmf4KyEwVy8I6bEJB9bNom+1ho+pDie5/qOUwXPTMeoWckGo8iP4wTDu
         s5ERMadiHgs+R8GzmWRP3OuHCsTXLrmiWFIcJDSSWlxLk5mDwcdh0XhoeOwcV9JA5rX5
         KCmSmIQyeWxmD/9qPJQQOzcghaHsvhYY0h+KAJyR7Sqg/XZTZY+In//2U2vI1LfOehhh
         /SRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712215956; x=1712820756;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Vv1p+RJN8SH4JBxojGl8pZ97ohWKJHxu7WwKK9Pf4k=;
        b=e7ERjQiSBZP5YD8IyLtqHpd1gvCmQuS6Qpm7qbLj0C759hRWRnlxFZ2Gom4u2Rjq48
         QPndKD0I4dwOQLyaENVppFD/AHBJRSi8mCdGVm5epZfqmg+b2noBgYQTQDjekOKiuGEg
         kONbnJL8XGjyRhuIqyqgLd7zUS9c/ESl0sB30ndEgsR4SrX+LCsycTRs9rDou853gIQn
         0G06KU9GsR6HgFx+qbeJijv8Z+z3sot339CWuk0ZjvOY58mT2I9uO0QkCdS9hjK6JqXR
         P347GbTS9fA4ASOCKABs3V8UQerEyhyAh/bLJmFlQjVIywzG3/AzRfJunqbwu/X2gtNn
         hnIA==
X-Forwarded-Encrypted: i=1; AJvYcCVLCdi3y3ny5HTY5Vq1s8G4Q8zUq9lhf5rbAmAwfLFGITbG+Ez8qpL/swEn6R3eReF27OFR3+76/bQEBGu2ynzJ9mAwYk6LXXIS
X-Gm-Message-State: AOJu0Yzi8XRu/CuYiC7nFoI/TQZEslESdM7DUdlJBNBLt3cxpjI68C8N
	tdQhv02pm3bXb+8u0EZ9FjpJgRrQabad6ZArlXHyNb7tNEqYsThLgqWyrA8bNqM=
X-Google-Smtp-Source: AGHT+IFJgvzF9ygaiCsV7pwRcgGsfB+3wkavmoj5Dy2AAbEMFKsACzUItMw9j6cAABh20Jo8cHyNOw==
X-Received: by 2002:a17:906:ccd2:b0:a47:4b39:ba1c with SMTP id ot18-20020a170906ccd200b00a474b39ba1cmr944376ejb.39.1712215956428;
        Thu, 04 Apr 2024 00:32:36 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id s18-20020a170906501200b00a474d2d87efsm8675976ejj.139.2024.04.04.00.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 00:32:36 -0700 (PDT)
Date: Thu, 4 Apr 2024 10:32:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: [bug report] xfs: repair free space btrees
Message-ID: <4e8b2fc3-838a-458e-b306-2f8a0062ba76@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Darrick J. Wong,

Commit 4bdfd7d15747 ("xfs: repair free space btrees") from Dec 15,
2023 (linux-next), leads to the following Smatch static checker
warning:

	fs/xfs/scrub/alloc_repair.c:781 xrep_abt_build_new_trees()
	warn: missing unwind goto?

fs/xfs/scrub/alloc_repair.c
    702 STATIC int
    703 xrep_abt_build_new_trees(
    704         struct xrep_abt                *ra)
    705 {
    706         struct xfs_scrub        *sc = ra->sc;
    707         struct xfs_btree_cur        *bno_cur;
    708         struct xfs_btree_cur        *cnt_cur;
    709         struct xfs_perag        *pag = sc->sa.pag;
    710         bool                        needs_resort = false;
    711         int                        error;
    712 
    713         /*
    714          * Sort the free extents by length so that we can set up the free space
    715          * btrees in as few extents as possible.  This reduces the amount of
    716          * deferred rmap / free work we have to do at the end.
    717          */
    718         error = xrep_cntbt_sort_records(ra, false);
    719         if (error)
    720                 return error;
    721 
    722         /*
    723          * Prepare to construct the new btree by reserving disk space for the
    724          * new btree and setting up all the accounting information we'll need
    725          * to root the new btree while it's under construction and before we
    726          * attach it to the AG header.
    727          */
    728         xrep_newbt_init_bare(&ra->new_bnobt, sc);
    729         xrep_newbt_init_bare(&ra->new_cntbt, sc);
    730 
    731         ra->new_bnobt.bload.get_records = xrep_abt_get_records;
    732         ra->new_cntbt.bload.get_records = xrep_abt_get_records;
    733 
    734         ra->new_bnobt.bload.claim_block = xrep_abt_claim_block;
    735         ra->new_cntbt.bload.claim_block = xrep_abt_claim_block;
    736 
    737         /* Allocate cursors for the staged btrees. */
    738         bno_cur = xfs_bnobt_init_cursor(sc->mp, NULL, NULL, pag);
    739         xfs_btree_stage_afakeroot(bno_cur, &ra->new_bnobt.afake);
    740 
    741         cnt_cur = xfs_cntbt_init_cursor(sc->mp, NULL, NULL, pag);
    742         xfs_btree_stage_afakeroot(cnt_cur, &ra->new_cntbt.afake);
    743 
    744         /* Last chance to abort before we start committing fixes. */
    745         if (xchk_should_terminate(sc, &error))
    746                 goto err_cur;
    747 
    748         /* Reserve the space we'll need for the new btrees. */
    749         error = xrep_abt_reserve_space(ra, bno_cur, cnt_cur, &needs_resort);
    750         if (error)
    751                 goto err_cur;
    752 
    753         /*
    754          * If we need to re-sort the free extents by length, do so so that we
    755          * can put the records into the cntbt in the correct order.
    756          */
    757         if (needs_resort) {
    758                 error = xrep_cntbt_sort_records(ra, needs_resort);
    759                 if (error)
    760                         goto err_cur;
    761         }
    762 
    763         /*
    764          * Due to btree slack factors, it's possible for a new btree to be one
    765          * level taller than the old btree.  Update the alternate incore btree
    766          * height so that we don't trip the verifiers when writing the new
    767          * btree blocks to disk.
    768          */
    769         pag->pagf_repair_bno_level = ra->new_bnobt.bload.btree_height;
    770         pag->pagf_repair_cnt_level = ra->new_cntbt.bload.btree_height;
    771 
    772         /* Load the free space by length tree. */
    773         ra->array_cur = XFARRAY_CURSOR_INIT;
    774         ra->longest = 0;
    775         error = xfs_btree_bload(cnt_cur, &ra->new_cntbt.bload, ra);
    776         if (error)
    777                 goto err_levels;
                        ^^^^^^^^^^^^^^^^
    778 
    779         error = xrep_bnobt_sort_records(ra);
    780         if (error)
--> 781                 return error;
                        ^^^^^^^^^^^^^
Should this be a goto err_levels?

    782 
    783         /* Load the free space by block number tree. */
    784         ra->array_cur = XFARRAY_CURSOR_INIT;
    785         error = xfs_btree_bload(bno_cur, &ra->new_bnobt.bload, ra);
    786         if (error)
    787                 goto err_levels;
    788 
    789         /*
    790          * Install the new btrees in the AG header.  After this point the old
    791          * btrees are no longer accessible and the new trees are live.
    792          */
    793         xfs_allocbt_commit_staged_btree(bno_cur, sc->tp, sc->sa.agf_bp);
    794         xfs_btree_del_cursor(bno_cur, 0);
    795         xfs_allocbt_commit_staged_btree(cnt_cur, sc->tp, sc->sa.agf_bp);
    796         xfs_btree_del_cursor(cnt_cur, 0);
    797 
    798         /* Reset the AGF counters now that we've changed the btree shape. */
    799         error = xrep_abt_reset_counters(ra);
    800         if (error)
    801                 goto err_newbt;
    802 
    803         /* Dispose of any unused blocks and the accounting information. */
    804         xrep_abt_dispose_reservations(ra, error);
    805 
    806         return xrep_roll_ag_trans(sc);
    807 
    808 err_levels:
    809         pag->pagf_repair_bno_level = 0;
    810         pag->pagf_repair_cnt_level = 0;
    811 err_cur:
    812         xfs_btree_del_cursor(cnt_cur, error);
    813         xfs_btree_del_cursor(bno_cur, error);
    814 err_newbt:
    815         xrep_abt_dispose_reservations(ra, error);
    816         return error;
    817 }

regards,
dan carpenter
