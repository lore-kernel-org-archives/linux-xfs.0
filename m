Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF63CEB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 21:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjFUV7A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjFUV7A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 17:59:00 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F56B1AC
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 14:58:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b505665e2fso89355ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 14:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687384739; x=1689976739;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yF+AevMsf0bJfIemNaAR6PbEIyeyrfMBFVJNdRfabZI=;
        b=nmzJ3HAH0KX5EMFwxpHJ1mFosAb3TtOhgmdr1OhcSirKL3Z2pnnBK1LoAhaEoPHIqt
         SHobq2L8K7R+mM5B+hbGay9XmnzSo14D4/TJoM1D/AAPfu8lqFZJL2s5U1oULFUZ4r90
         /8sCAogYdacM/JT89wVgZtutw1mfSBJbuuE2lRONb8xhMr/IJTXJ5PvMmczpcre6QcaQ
         bpVCxyHCBDAqv7Xw5zEeINF5mWhbN4sAfkeMRsM9UF7fgemR4mnacBtlXZV3C6PMvSvL
         hLffTT3QfGO1vyGkM8/OdmlTXF9rppJF+QB+I0lpD7b4JmW/9r3XT9VcAtN4g7BoJEUw
         E84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687384739; x=1689976739;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yF+AevMsf0bJfIemNaAR6PbEIyeyrfMBFVJNdRfabZI=;
        b=UL8zu+zBEVu5JVuO8V19UaLug0fGM5O8a0znzHCaaWVFn4TKmO5PoNSeYCwHWkIG6L
         06wzgHmqAHEWC38OgD1jRA2rQIYS993bRqLUGAFpcnuKmsprvElF352o7rq8FvpI4W8S
         GH1b7rZzDSRniy5Qp8M9E3KBQc6rQFz5ZROVbEyC0iPiO1lOkA4DUFOlFZL4kmXpB8Px
         Z6l/6Yr0dSGU099L0vPHQvKJ/qDVZFg9ftnMEYQ7O/ULKEOcKsajrJW32SY4qjQjRNsF
         RySBzs6c8a9I1usXnoM/r2cxfj4xuW/waDIFdVrlwcdkczZoroBDiZJgNphEflE2X8vf
         bZmg==
X-Gm-Message-State: AC+VfDypPN7EuVGSr6I/rTDC2SNlr5NwY2FGU+DvqAF8ISHz0iMvZFi7
        RaF2FvR6BoMvs/jggDFFlTp8ocsrEfkRiWC/geg=
X-Google-Smtp-Source: ACHHUZ6kSrD0J83vnMEpwZMQdiFv2a/mRO7myWw65HYBsZU2rhIQt5FkB6HaiwBA4QQrvMHYJzvG3w==
X-Received: by 2002:a17:902:d485:b0:1b2:22cd:9827 with SMTP id c5-20020a170902d48500b001b222cd9827mr30134832plg.1.1687384738921;
        Wed, 21 Jun 2023 14:58:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id jn9-20020a170903050900b001b3d44788f4sm3994506plb.9.2023.06.21.14.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 14:58:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qC5qp-00Ebh4-35;
        Thu, 22 Jun 2023 07:58:55 +1000
Date:   Thu, 22 Jun 2023 07:58:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Lars Wendler <polynomial-c@gmx.de>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] po/de.po: Fix possible typo which makes gettext-0.22
 unhappy
Message-ID: <ZJNyn817MpCB3nbr@dread.disaster.area>
References: <20230621105520.17560-1-polynomial-c@gmx.de>
 <a08995aa-2003-be8f-dab1-6d8ed6687e12@applied-asynchrony.com>
 <20230621135608.25db01bb@chagall.paradoxon.rec>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230621135608.25db01bb@chagall.paradoxon.rec>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 21, 2023 at 01:56:08PM +0200, Lars Wendler wrote:
> Am Wed, 21 Jun 2023 13:29:03 +0200
> schrieb Holger Hoffstätte <holger@applied-asynchrony.com>:
> 
> > On 2023-06-21 12:55, Lars Wendler wrote:
> > > diff --git a/po/de.po b/po/de.po
> > > index 944b0e91..a6f8fde1 100644
> > > --- a/po/de.po
> > > +++ b/po/de.po
> > > @@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
> > >   #: .././estimate/xfs_estimate.c:191
> > >   #, c-format
> > >   msgid "%s will take about %.1f megabytes\n"
> > > -msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
> > > +msgstr "%s wird etwa %.1f Megabytes einnehmen\n"
> > 
> > I don't see the difference..?
> > Both the added and removed line are the same.
> > 
> > -h
> 
> I suppose depending on the font, it's quite hard to distinguish the two
> lines.

I didn't see it, and the commit message doesn't explain anything,
either. Pointing to a bugzilla somewhere does not make a valid
commit message....

> The removed line contains "%.lf" with a lowercase letter L.
> The added line contains "%.1f" where the lowercase letter L was replaced
> with the digit 1.

... whereas this explains what the bug being fixed is, and allows the
reviewer to see the subtle change being made. i.e. you just wrote
the commit message that should have been in the patch in the first
place. :)

Can you please resend the fix with the commit message updated?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
