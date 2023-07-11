Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F187EB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 23:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbjGKXzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 19:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjGKXzm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 19:55:42 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A499B1734
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 16:55:36 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-66767d628e2so4380120b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 16:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689119736; x=1691711736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0yEdqgAlQqicqxLd9wSAo1pTlf2YVbL5CFZjevhVFgw=;
        b=i6kvjiBbbHiDrMGFLItn0/g2xe5OPU95X8iLxlrMcjFQJKK/90+Edi6h+NoEKWNp2N
         8bMsTxQqG++8ZGSda5ejWEGI4UdFlI84drJp+VvQkq+G2gANuFkmHPCkY0Lu4fbph98Z
         zA3TN4ixt6bKvCkr3ha6yCNihAgsGoqGEGsPbCZN1xPMC5MAR+S2z4LAJu/tCIKR2HtI
         R0drz9b4v16m5R0RSWHBEDrcxQ33uJnbVGpfKcD/pQuZ4FvcSe36aK4Dlz3m5Xb47RJQ
         pp5Ni3tkHgCLnlmEyBDfRGK8kfZQpNgvb4k9AeJSHAuBWwEuTbwB8dEGSCzhUa3gh4aw
         9eMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689119736; x=1691711736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yEdqgAlQqicqxLd9wSAo1pTlf2YVbL5CFZjevhVFgw=;
        b=KqOx2ysjJo+L0XDAy54kWy0SkJ8bu8ySQ6+thGeIX5qOxMXxJhsM/oDE7zwZr8GSCx
         LQe7MhILILjxFm8nAK5UT2mzR1FVWY9yWGgKV/dta0ZX+god9eB0o4fukxrH99IAx2LB
         ecZy+PNRMQIIxnI4W/2olBLdoN+QUpFyXO37wSm1AKNyIf4h6TM7GUaxmPeRUNlMfekK
         zEGuJ/5wIxqIHJbLpT/ybueZvUJhCTPOY9HLESbyV1/CVbRRPlSQ9iJmitpLCGEz6n42
         OzrwSm3aABOkawKWGc8I2eFmr07yaFQXDDzPuQcTU4TCaYv3aMJKphNHAeTKjOe+05lG
         KE9A==
X-Gm-Message-State: ABy/qLZK012jOBi2ZCLXDPnZtTfgJAARTXD8HjTzPvoO0nkayAxS1Svq
        qCtY6I9cicNPKVFDk1QQ1RCnkQ==
X-Google-Smtp-Source: APBJJlFLTHgIn7pdD8UAAu8lHSuBILlC56kGDFMAw1Uy0p6HpXcVdREZ7su1kGjza39Ic2IFmDhWHw==
X-Received: by 2002:a05:6a20:840d:b0:12f:bca:c2c6 with SMTP id c13-20020a056a20840d00b0012f0bcac2c6mr17392564pzd.35.1689119736112;
        Tue, 11 Jul 2023 16:55:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id jh6-20020a170903328600b001b8b26fa6a9sm2536130plb.19.2023.07.11.16.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 16:55:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJNCf-004ynf-0E;
        Wed, 12 Jul 2023 09:55:33 +1000
Date:   Wed, 12 Jul 2023 09:55:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] misc: remove bogus fstest
Message-ID: <ZK3r9Q1vLrRnfPE/@dread.disaster.area>
References: <DNb0uIBsmTk-4VL37ZmBH-nqyWm2cSqdM-Zd_bAXcZPV1pCBQsbvInqpO9Y-wscHogOqvlrjO_98ujQlmB6EEg==@protonmail.internalid>
 <20230709223750.GC11456@frogsfrogsfrogs>
 <20230711132454.y4jmjlwyuhxmeylc@andromeda>
 <20230711145441.GB108251@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711145441.GB108251@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 07:54:41AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 11, 2023 at 03:24:54PM +0200, Carlos Maiolino wrote:
> > On Sun, Jul 09, 2023 at 03:37:50PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Remove this test, not sure why it was committed...
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/999     |   66 -----------------------------------------------------
> > >  tests/xfs/999.out |   15 ------------
> > >  2 files changed, 81 deletions(-)
> > >  delete mode 100755 tests/xfs/999
> > >  delete mode 100644 tests/xfs/999.out
> > 
> > Thanks for spotting it. I'm quite sure this was a result of my initial attempts
> > of using b4 to retrieve the xfsprogs patch from the list, and it ended up
> > retrieving the whole thread which included xfstests patches.
> > 
> > Won't happen again, thanks for the heads up.
> 
> Well I'm glad that /one/ of us now actually knows how to use b4, because
> I certainly don't.  Maybe that's why Konstantin or whoever was talking
> about how every patch should include a link to a gitbranch or whatever.

If all you want to do is pull stuff from the mailing list, then all
you need to know is this command:

'b4 am -o - <msgid> | git am -s'

This pull the entire series from the thread associated with that
msgid into the current branch with all the rvb/sob tags updated. I
-think- this has all been rolled up into the newfangled 'b4 shazam'
command, but I much prefer to use the original, simple, obvious
put-the-pieces-together-yourself approach.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
