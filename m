Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D45BC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 02:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiKOCyT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 21:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiKOCyS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 21:54:18 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CB21180E
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 18:54:16 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o7so12104218pjj.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 18:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c3PM7ByOr9Qyqn4QqCLjG9ZKEDtp92oZLDa4V53nOuM=;
        b=VU6GIsmpCB0DNOn45n77EjNEug+Zd7xzahZ9iFW1ck0qKXiUxlKmHAJVz+bon11GMj
         kI41BASYkxwdhqP6haOVLrVK4ZDpDB1Vk5az/PL9JFtgyf8fWm84xmlqByFpB6CKO8Jh
         AK1Fl2Yev8IygFjjbNrxaGN6YbDHBfoH6mtQtpAzRDw9dg+qTzfsc+VEk/2ajZ5SZUki
         M9bgiZiLSaO0d+YPoZOjr/73ZfYLDX984yrEPfSxOhJ+rC80ECkMEdBoeyesi1cTT1qV
         kwcdTEcjSA2H0JSAy1RQvEMNHPCVshC0H7AyBGnJ90MbDQrqqSEvKnrbv9xxxUCNSH1z
         wK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3PM7ByOr9Qyqn4QqCLjG9ZKEDtp92oZLDa4V53nOuM=;
        b=UxIo492peDn4E9bwFEHXDsjWfixsNZP2QdqEDZunZCoU356sY4HCotJJ3SEt/BrRIb
         YGg4WcJfDG+3C+pSyMgxx7ouKcvctA0f1pkt4uw87KtevilAIrnvzm7ARmQrsZBrDtat
         BExx9T30GpOrwYYkj1RLiQcgK+6s2qs59IB6aAEfyC2En/0mr/H7JUCBrmzAWjfvz2Jo
         rxYAEDwsJsbvhbEKgOl9QSBkP5dGQSxALdngwdL+ey0RBkLByzisZjWs58nM0SGe0JdD
         Z+O9+D/CzwpcmDxSCeqpsuZST0jneP86pTbcVxkGOIc8ZNak8jIj8GcpeNu3N3i6utES
         whxw==
X-Gm-Message-State: ANoB5pkgeI6fdUIqFl8IqCh5vghO23gpUrotliBwjvwUeKbcq1ORpR/G
        gbMoOW6NFJ4pPzUXqlw46aF1qw==
X-Google-Smtp-Source: AA0mqf4s+UY/OUCjRjl6yDbAOiNSaOqI5iqlJs3584KqSVY4X9JMQrptWs2DXBwCybLNUq2t58M1Qw==
X-Received: by 2002:a17:903:230c:b0:186:8376:209f with SMTP id d12-20020a170903230c00b001868376209fmr1946726plh.161.1668480856290;
        Mon, 14 Nov 2022 18:54:16 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id ju13-20020a170903428d00b001870dc3b4c0sm8361715plb.74.2022.11.14.18.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 18:54:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oum5U-00ELVs-NX; Tue, 15 Nov 2022 13:54:12 +1100
Date:   Tue, 15 Nov 2022 13:54:12 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v23.3 4/4] xfs: don't return -EFSCORRUPTED from repair
 when resources cannot be grabbed
Message-ID: <20221115025412.GT3600936@dread.disaster.area>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479567.1083393.7668585289114718845.stgit@magnolia>
 <Y2mwyQ8VD3zX4goX@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2mwyQ8VD3zX4goX@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 07, 2022 at 05:28:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we tried to repair something but the repair failed with -EDEADLOCK,
> that means that the repair function couldn't grab some resource it
> needed and wants us to try again.  If we try again (with TRY_HARDER) but
> still can't get all the resources we need, the repair fails and errors
> remain on the filesystem.
> 
> Right now, repair returns the -EDEADLOCK to the caller as -EFSCORRUPTED,
> which results in XFS_SCRUB_OFLAG_CORRUPT being passed out to userspace.
> This is not correct because repair has not determined that anything is
> corrupt.  If the repair had been invoked on an object that could be
> optimized but wasn't corrupt (OFLAG_PREEN), the inability to grab
> resources will be reported to userspace as corrupt metadata, and users
> will be unnecessarily alarmed that their suboptimal metadata turned into
> a corruption.
> 
> Fix this by returning zero so that the results of the actual scrub will
> be copied back out to userspace.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v23.3: fix vague wording of comment
> v23.2: fix the commit message to discuss what's really going on in this
> patch.
> ---
>  fs/xfs/scrub/repair.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
