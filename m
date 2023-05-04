Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7A9C7EE21
	for <linux-xfs@archiver.kernel.org>; Thu,  4 May 2023 22:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjEDWkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 May 2023 18:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjEDWkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 May 2023 18:40:39 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6324A8A48
        for <linux-xfs@vger.kernel.org>; Thu,  4 May 2023 15:40:38 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so7362925ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 May 2023 15:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683240038; x=1685832038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bSBn9yOinBU8m0yQLrSvbl7PKYZlBg3YhOgvbxEMud0=;
        b=V2OWoWuBY9/BxFN6ZMrayZSPn34VUIMFwLKD1syjt3URVOHsk6eRCzBjJxyS/sTaxh
         0ODMUc6Lrrs3v8zH3Sx/5e/PKEpsPzqFVGY4QckBPaQkZZfaM7pnBgEofNkOYx2I3eMh
         /CUnaPOJFUPSRWZdnUNxTe8x2snVD8PtGIxSGOLogmkrfrhkWite1HB1ZWG+3fFJST9O
         CMCv7TFFrBn2cKtBOmOLW8XQUBS/fB7r1lrmQ3GM1O5nbWEdOmtFcfUJmeIAnUxIbWpn
         3ror2ojs9ATMDgL9RR5K3X4TvFjtnscejsS+p0QkHUHUt2WEuhfGkKNuQs/O+d5WTYRo
         HM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683240038; x=1685832038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSBn9yOinBU8m0yQLrSvbl7PKYZlBg3YhOgvbxEMud0=;
        b=kYn0U1yXcXY0fxm244fL8ht2wd+Jf5W6/ZqDGtcQNdYc8FEj3BR00wAezErkg6vW0J
         R0x+MSNBaxb7UAAznsvy/bSxyElJENJRdcm2GS6FsbW6ArYaQxkK3mvtWpX7TcDJNBBU
         3ibwR2hglc0xdbSWkDXShPDEDxwiL7aOroHDFfGRZ7bsU1z5bi8Xt/XY3h+E6cvF0/9b
         VGdGWXq8PGNLsRo+LfCKo5vY3hHx0VvmpvwcdsVwh2JLKRrlkWn24V31/cMKpZGq9TiP
         /QxkEYEXTWfr5vvVPxopFcYkVuHXA864HlugMCR0GABlBNBRvAkMbejALMDuLRD9T8EF
         A2PQ==
X-Gm-Message-State: AC+VfDwuPkoqq2SLcQamUsp7bwuNtez2HAYTuyzlCq5v/PtY3+NlPI3N
        5UgZ7GsUfTdVmLmpEW7ZoHFKyA==
X-Google-Smtp-Source: ACHHUZ4sldKILzM05M5JtvE1zkTm8BdFnY+an0qc3+Zw6AS4jJ2XEp42XVgNkYwu+sP102Df03J4uQ==
X-Received: by 2002:a17:903:48e:b0:1a6:cb66:681f with SMTP id jj14-20020a170903048e00b001a6cb66681fmr4825434plb.46.1683240037873;
        Thu, 04 May 2023 15:40:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id ix10-20020a170902f80a00b001ab0159b9edsm27390plb.250.2023.05.04.15.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 15:40:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1puhcn-00BPr0-UX; Fri, 05 May 2023 08:40:33 +1000
Date:   Fri, 5 May 2023 08:40:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jejb@linux.ibm.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, paul@paul-moore.com,
        jmorris@namei.org, serge@hallyn.com,
        Prasad Singamsetty <prasad.singamsetty@oracle.com>
Subject: Re: [PATCH RFC 02/16] fs/bdev: Add atomic write support info to statx
Message-ID: <20230504224033.GJ3223426@dread.disaster.area>
References: <20230503183821.1473305-1-john.g.garry@oracle.com>
 <20230503183821.1473305-3-john.g.garry@oracle.com>
 <20230503215846.GE3223426@dread.disaster.area>
 <96a2f875-7f99-cd36-e9c3-abbadeb9833b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96a2f875-7f99-cd36-e9c3-abbadeb9833b@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 04, 2023 at 09:45:50AM +0100, John Garry wrote:
> On 03/05/2023 22:58, Dave Chinner wrote:
> > Is there a statx() man
> > page update for this addition?
> 
> No, not yet. Is it normally expected to provide a proposed man page update
> in parallel? Or somewhat later, when the kernel API change has some
> appreciable level of agreement?

Normally we ask for man page updates to be presented at the same
time, as the man page defines the user interface that is being
implemented. In this case, we need updates for the pwritev2() man
page to document RWF_ATOMIC semantics, and the statx() man page to
document what the variables being exposed mean w.r.t. RWF_ATOMIC.

The pwritev2() man page is probably the most important one right now
- it needs to explain the guarantees that RWF_ATOMIC is supposed to
provide w.r.t. data integrity, IO ordering, persistence, etc.
Indeed, it will need to explain exactly how this "multi-atomic-unit
mulit-bio non-atomic RWF_ATOMIC" IO thing can be used safely and
reliably, especially w.r.t. IO ordering and persistence guarantees
in the face of crashes and power failures. Not to mention
documenting error conditions specific to RWF_ATOMIC...

It's all well and good to have some implementation, but without
actually defining and documenting the *guarantees* that RWF_ATOMIC
provides userspace it is completely useless for application
developers. And from the perspective of a reviewer, without the
documentation stating what the infrastructure actually guarantees
applications, we can't determine if the implementation being
presented is fit for purpose....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
