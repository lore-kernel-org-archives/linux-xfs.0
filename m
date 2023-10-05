Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A26EE92702
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjJEORy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjJEOQE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:16:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42CB10C
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 19:55:52 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-690bd8f89baso384686b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 19:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696474552; x=1697079352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fbRnfHICVwHrDg628wHflzUySS+QzkRafnuB/gdtgwk=;
        b=I/x0ZwZP6IoiHk3i3mUmUJCwX/NSnPplJpBiRFs5FbYgtFCNstxvw3uh+aAp/V2QpP
         g/JgxFfJ3o7YdsN29EiXWU1FNENCk6fcTe5YzqSUWG7K5ujxEw5E2R2Vlt8O3j7x39HQ
         01up4barDQtVfLO9zPR4IpTynI+31eju6LZFgE4rwKGEMgfRDU2GL7FZYeSzPJdEKOGG
         vAYYMn+XbMQCKjkArtMdvALfhm8zSLKNjXWtfvyjASJ2zwUKwOHRpEfROvXwoNBEi8zb
         KXccNcEIKGyjwiSoPopOqn5CXr1fRLjQLhnMQexKL+HP/ptVhta8PjaQK2ETaw9EzSOx
         ktVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696474552; x=1697079352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbRnfHICVwHrDg628wHflzUySS+QzkRafnuB/gdtgwk=;
        b=hgYUlAz+XqvPehrwjkHz5k70C3ltcyZElwHTUmtCYOMYJdHs6dlOOn+9rbyuKuvSNc
         cGKrtz9kyaCwQ6JD+t8T1dX9nOeF1/1tmtTxB5o4mt4WmA95sxjd3xotJXZiqZ5oACxY
         zMUQWm/8A9pDaM9JbUov95qNF9uXokyxQhGPklZmo1Z+ZcAbmYtHvlyKtqxLzdJ+Smxs
         XV1bOvVF8BwUeGgsZsjULG2xZD6RYQV5PCrLkLOJNAiUJsJOG6aeb/5OqFw9E7ksSktP
         mhkA89VMK7TnIBMcepOv29fnRBsW9MMbesWECQNluXejn0anPprNy63OAw06oSFeL8Ng
         HSvA==
X-Gm-Message-State: AOJu0YyqIEHXLR8GVmXr88jE9p3RE8JoJonmVIzF4cnXHrg/e7kgols1
        VnytodmGgcELM1YpBeOS9G/h6nPy6Qr9cl8C7Ps=
X-Google-Smtp-Source: AGHT+IHNblWMByQuXi08yy8IUT/JmFoDKBHoGiXcMYY6krJ6BKucFletPce81AiindYxxqskbuI1+w==
X-Received: by 2002:a05:6a21:1f16:b0:152:1ce8:ce3a with SMTP id ry22-20020a056a211f1600b001521ce8ce3amr3516699pzb.18.1696474552213;
        Wed, 04 Oct 2023 19:55:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id t12-20020aa7938c000000b0064d74808738sm236425pfe.214.2023.10.04.19.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 19:55:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoEWi-009bdV-2f;
        Thu, 05 Oct 2023 13:55:48 +1100
Date:   Thu, 5 Oct 2023 13:55:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: don't append work items to logged
 xfs_defer_pending objects
Message-ID: <ZR4ltN86f0JFw6MD@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059164.3312911.8148982456892861553.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059164.3312911.8148982456892861553.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:31:22PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When someone tries to add a deferred work item to xfs_defer_add, it will
> try to attach the work item to the most recently added xfs_defer_pending
> object attached to the transaction.  However, it doesn't check if the
> pending object has a log intent item attached to it.  This is incorrect
> behavior because we cannot add more work to an object that has already
> been committed to the ondisk log.
> 
> Therefore, change the behavior not to append to pending items with a non
> null dfp_intent.  In practice this has not been an issue because the
> only way xfs_defer_add gets called after log intent items have been
> committed is from the defer ops ->finish_item functions themselves, and
> the @dop_pending isolation in xfs_defer_finish_noroll protects the
> pending items that have already been logged.
> 
> However, the next patch will add the ability to pause a deferred extent
> free object during online btree rebuilding, and any new extfree work
> items need to have their own pending event.
> 
> While we're at it, hoist the predicate to its own static inline function
> for readability.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   48 ++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 12 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
