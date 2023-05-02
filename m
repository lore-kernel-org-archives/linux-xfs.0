Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A743C77B78
	for <linux-xfs@archiver.kernel.org>; Tue,  2 May 2023 23:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjEBXNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 May 2023 19:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBXNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 19:13:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642EC2118
        for <linux-xfs@vger.kernel.org>; Tue,  2 May 2023 16:13:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b8b19901fso5062953b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 02 May 2023 16:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683069203; x=1685661203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hZdhpA+W6215cUWk9C1zeKd1gMi6vxSdhh7ceU/G3WI=;
        b=k2z3WNM0alAPqrxIAiZWxI/R4iPFHzYjGEXiOXW48p2DVaLqe3M7BI/GuylF0m2lx+
         a5KKrjQ3jz6ItTA5CoMaIZo2dNoMAIlI5aaNchmir9QFQRONFE0/iLF6kfWzU/bksf+D
         J0rL3MRIflq1JECeQprWrW/Y3hlhKx82+dHyiX1f9SfDVOQKoWG2FxBxFfUkEdY+q+MG
         PfLJ2Mb1qjoVuPpluIH5fm9BWiACQ3rqyP1yAfJwW5f7k6ytVfokzXh6RS7lwmEu7cdj
         UgB8P8YksGOSuo4HYoBlqsSjcTQd/bm/Q6RVtQfJgP7kL3/g8zECQwF7R50rN7bK1SjT
         Tvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683069203; x=1685661203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hZdhpA+W6215cUWk9C1zeKd1gMi6vxSdhh7ceU/G3WI=;
        b=eBLJ6v+1osqrLwePIUSNPocjieEGc9ELtUzd/T/nXSu/+CfKsZFNWLbozOTJyKCz3y
         RmdUO05z0EZRiKeNeAcbqrDrmnLU84Eu3h7JTr3TCZTt+4bPAXFGtgqZ7qJUG7sCxETn
         aBnnTH65x1/KniCGpNSBISdwRs4Vm+yLRykkiOBjOALpGD+7ZF+34Zzt6JwHISCElZ9u
         G2tnlCpIZrlyUxMTIprbkeM4HmvkSec6P+V/ICrdZo0pwDZf8KMEcutEFOQjFCyZPqbD
         kYTq4dE2uEP9ZlcL8Md8WXgND9k7K4Yyt1dvmvDk/m+adza36LSOqGYH8K63z+28UgPc
         FQKQ==
X-Gm-Message-State: AC+VfDxcIVYsceaiPjvYx5k/3DCc+CS4FX/RhCxQeGBYNTxYJZyYaqL1
        HYsTDQCsLITuvZTA1SkT8yMg0SFjkkBrZEIpPD/vEg==
X-Google-Smtp-Source: ACHHUZ4XRglCBDD9TUX5knp6Tp3ktS++PuHbxCknQQ1eJ0RUMyrHbFqkav/dwcDuNPOXaDZAbcoFMQ==
X-Received: by 2002:a05:6a20:a3a2:b0:f5:cf7d:fcac with SMTP id w34-20020a056a20a3a200b000f5cf7dfcacmr18497463pzk.37.1683069202749;
        Tue, 02 May 2023 16:13:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id d17-20020aa78691000000b00640f895fde9sm12657108pfo.214.2023.05.02.16.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 16:13:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptzBO-00AdIr-7s; Wed, 03 May 2023 09:13:18 +1000
Date:   Wed, 3 May 2023 09:13:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Mike Pastore <mike@oobak.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Corruption of in-memory data (0x8) detected at
 xfs_defer_finish_noroll on kernel 6.3
Message-ID: <20230502231318.GB3223426@dread.disaster.area>
References: <CAP_NaWaozOVBoJXtuXTRUWsbmGV4FQUbSPvOPHmuTO7F_FdA4g@mail.gmail.com>
 <20230502220258.GA3223426@dread.disaster.area>
 <CAP_NaWZEcv3B0nPEFguxVuQ8m93mO7te-bZDfwo-C8eN+f_KNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP_NaWZEcv3B0nPEFguxVuQ8m93mO7te-bZDfwo-C8eN+f_KNA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 02, 2023 at 05:13:09PM -0500, Mike Pastore wrote:
> On Tue, May 2, 2023, 5:03 PM Dave Chinner <david@fromorbit.com> wrote:
> 
> >
> > If you can find a minimal reproducer, that would help a lot in
> > diagnosing the issue.
> >
> 
> This is great, thank you. I'll get to work.
> 
> One note: the problem occured with and without crc=0, so we can rule that
> out at least.

Yes, I noticed that. My point was more that we have much more
confidence in crc=1 filesystems because they have much more robust
verification of the on-disk format and won't fail log recovery in
the way you noticed. The verification with crc=1 configured
filesystems is also known to catch issues caused by
memory corruption more frequently, often preventing such occurrences
from corrupting the on-disk filesystem.

Hence if you are seeing corruption events, you really want to be
using "-m crc=1" (default config) filesystems...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
