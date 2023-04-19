Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F4FC77B73
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Apr 2023 22:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjDSWeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Apr 2023 18:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbjDSWea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2023 18:34:30 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68437DA5
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 15:33:53 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-555d2810415so3979087b3.0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Apr 2023 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1681943571; x=1684535571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZrPULhZIKJV34C2bhX8PcgMIHgEG0C+dg13xBQhh0w=;
        b=RabHNL6ucg+lrMOckK/Oltz0iwTzIrfM/rRefbYg4xK+nunYtDPeTThL+qEcZMVUzX
         F29FUiKRy0FX8zVKkA7jvuxoNQguwUdHhTj3HthyuhsAxPyAs8gcPlh1XJ+/Ugh8LshW
         LjuagDciyaotozTcgqUEaTAxuGqFr4dU6COGjXtR1HRS9JESHLXOknBTXGSddrwgEfkw
         7nFKeObF/8FxRPfas2o3OKEMQYD0UFIZrYvxmnuzPLNi8cqflrqOkfff7LMN6sKjEZ/X
         uecSKVGVefGpO6eXQxn8LEVxw6sajs6YdJZTmnCNVUiq7KK1bEnwfnecnNbhWH0Y4DkU
         ZnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943571; x=1684535571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ZrPULhZIKJV34C2bhX8PcgMIHgEG0C+dg13xBQhh0w=;
        b=bEyFNfMMeF70HQ2FVPBX7Yq4n3PUDv5jUCcYvPhJ/wHomawgwnv9NJmBCJJLDoKLQg
         Gw5A8oKNja0imVaZqw8LeoH99xBCO9JIQEWS3BpqD9GTmKV7pAIzgYOaVFk4o/LME61s
         KlkwZfP9UEIjdR5CvVspYnxvELLkHBEtu73aMJ22xXaOvu26r+KLCLc01RYEtydR9YQS
         xh9e/ZSptoKCt+OCrrhLPEhUO0iVsRQCpDiiRsBwpsVCjvrMv7Ngl+uuF32YbUe43ms9
         rFNUQLWH7lKoqY0LAhCFH8Cyt8AEyXmObmovUc9sqVPg3MbZUcgK0LM1liclHYJEe7da
         tuVg==
X-Gm-Message-State: AAQBX9eYTXJhV61ksBlZT5Z8p0+19xxgNXTdHwHVJWHwffDfbZ3MG1i0
        eUDPXGTbM7VonqZ+ASFZlNAn9zLh0OCzSP76rts=
X-Google-Smtp-Source: AKy350Yn+z+rdiDG8ySW4WCMw+0zQ/ws73YT2f1f1XxWKOrSMbU2byidZa3yVOwPBeUzkNz7+7uMJA==
X-Received: by 2002:a17:902:654a:b0:1a8:1c9a:f68 with SMTP id d10-20020a170902654a00b001a81c9a0f68mr3322962pln.36.1681942790785;
        Wed, 19 Apr 2023 15:19:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id ji2-20020a170903324200b001a4ee6ec809sm11964287plb.46.2023.04.19.15.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppG9T-005QFi-2w; Thu, 20 Apr 2023 08:19:47 +1000
Date:   Thu, 20 Apr 2023 08:19:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Linux XFS Development <linux-xfs@vger.kernel.org>,
        Linux Documentation <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation: xfs: Extend table marker on deprecated
 mount options table
Message-ID: <20230419221947.GU3223426@dread.disaster.area>
References: <20230419094921.27279-1-bagasdotme@gmail.com>
 <20230419151536.GM360895@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419151536.GM360895@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2023 at 08:15:36AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 19, 2023 at 04:49:21PM +0700, Bagas Sanjaya wrote:
> > Sphinx reports htmldocs warning on deprecated mount options table:
> > 
> > /home/bagas/repo/linux-kernel/Documentation/admin-guide/xfs.rst:243: WARNING: Malformed table.
> > Text in column margin in table line 5.
> > 
> > ===========================     ================
> >   Name                          Removal Schedule
> > ===========================     ================
> > Mounting with V4 filesystem     September 2030
> > Mounting ascii-ci filesystem    September 2030
> > ikeep/noikeep                   September 2025
> > attr2/noattr2                   September 2025
> > ===========================     ================
> > 
> > Extend the table markers to take account of the second name entry
> > ("Mounting ascii-ci filesystem"), which is now the widest and
> > to fix the above warning.
> > 
> > Fixes: 7ba83850ca2691 ("xfs: deprecate the ascii-ci feature")
> > Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 
> Looks good.  Dave, could you take this through the xfs tree whenever you
> push the duplicate #include fixes, please?
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Applied.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
