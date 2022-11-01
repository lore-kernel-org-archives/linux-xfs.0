Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F586C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 23:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiKAXlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiKAXll (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 19:41:41 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF231CB3B
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 16:41:40 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k15so6829662pfg.2
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 16:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4xgkii8jSu0EuMOE0qVeZX+9TY+W/OOOJNxTckyg5W0=;
        b=bpbIP00PF/zk8aze6rCewDOkVaXsc3lVrNa/4O/H72JhI7q3ZikVZBbRkDbsweNQ2y
         28ZOMOjP+GgyM4c1FbO9ykuqEm7WhRB7kopnKJwBKIUyPQekGIHZYW0fDirKNwXgFWdz
         qhGMrYi66ZIqdYfsQaAzJg15jHsnHI2GvKNEh3UnFNuQY5AjPGV51FI4GmdkKG4Kc5+4
         BqJfJ+TBYBZCS86mOf/x14qEOC1QIW1esFYV0EdDkhVXZ54JWS58akGI6G5ZQkXfNn4J
         2QpJOmSY5XLAvwauAB/P7V12Gs5LzdxPmaZiXKnGlLKL87r3J/YVG6V6xlNoAw5hfrDH
         p7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xgkii8jSu0EuMOE0qVeZX+9TY+W/OOOJNxTckyg5W0=;
        b=1O68yWr1KV1c9NT0sxOtd8QC5IC0G2IucT4mI98OjoSuYGlKc8wkHujvtsGT1uaUmT
         hA17HyiPujHl/2nq5H4TUXZn9Uz2NqOi0pdo1k13xL1pyp2UHsf7yt1eKgImNm4sX6Wo
         tituklE01GaAFMnS5am2ZXOLBSlkym/EvhVAt6sxRAqPCcUrOZCryPjcgUTfTMbfRCMU
         stUqCJ20Ck6DqvSZ7y14kk/jwSPSIsIOESzMTBZePPHeVLvpit3yeZBg5i6ZaTB4l3nH
         IlwthYFlOzNPBOTU/Km66ovl06UqSnSsGxqhlFYw7SMLjIB0EG3jjiFBC3CSRWivDGhE
         u32A==
X-Gm-Message-State: ACrzQf0pNuif/q7weO63n+uHj4axDTfu4HGcBUWyekK7LY/LVH6zdaX4
        vO5RTBvdsBugRHIezUSCrPkSxw==
X-Google-Smtp-Source: AMsMyM7eX9Iathn3mVbguwExoRTxDnvukklnKjuPC2KWpvPHjGIvqDwVNFSklIg0bPNDbgA6xotl0Q==
X-Received: by 2002:a63:8449:0:b0:46e:ecba:c46d with SMTP id k70-20020a638449000000b0046eecbac46dmr19697140pgd.310.1667346100309;
        Tue, 01 Nov 2022 16:41:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id z185-20020a6265c2000000b0056d7cc80ea4sm4301301pfb.110.2022.11.01.16.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 16:41:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq0sy-009AT5-Tk; Wed, 02 Nov 2022 10:41:36 +1100
Date:   Wed, 2 Nov 2022 10:41:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: check btree keys reflect the child block
Message-ID: <20221101234136.GP3600936@dread.disaster.area>
References: <166473481246.1084112.5533985608121370791.stgit@magnolia>
 <166473481277.1084112.2602696039943979101.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481277.1084112.2602696039943979101.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When scrub is checking a non-root btree block, it should make sure that
> the keys in the parent btree block accurately capture the keyspace that
> the child block stores.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/btree.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)

Looks sensible.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
