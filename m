Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA5EC05027
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 23:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBFXO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 18:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjBFXOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 18:14:55 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258382701
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 15:14:55 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id ge21-20020a17090b0e1500b002308aac5b5eso6948625pjb.4
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 15:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VbGL10hhb9anaCnMCA6Yc3hehzHaEA4Rz59h+jA52IA=;
        b=2j7oCiQe+fdqkcBtJSPOHHu2H1SRXOwHlyVCTs7BHI3RodNhQrkj3UaVh3LQIlYwTQ
         pUZsOS47DfeRgcNrg+Ba7LGbxDtAR2lqyR7GWMB3fxBSl0x65ztpViP50YJ/Fh/LgnT6
         4lxlavV/OZm0l+sEWSIOkTv4sYSLT9TJeVaa8jgumG4CM5Vjf928HtnvI8CpyQgRIMC9
         AjtoGR0MrsfdkmdSEC1frzHVrOvAVZd3c6Nh+X1PcCHNxUq57DLitKcHkkF7GKZHvqzQ
         lI3BAgzOpl9hI6qMg6XMqjWljBVhP+pED0gFCheYX2R6mceAgLSlsGA0siJPAtmxo8Rx
         Sh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VbGL10hhb9anaCnMCA6Yc3hehzHaEA4Rz59h+jA52IA=;
        b=3iJPqK66lnSkF6NEoS6RRONaz5Y7wQtCwcN+C17wDQ/VZai99VuJemsgfj0IX+X8KR
         TahiAG+jInioC5a923iTGBrt7CWz8lhi6gXreIwLTOs4nXMuEMolzndQC0HyDO+mWvUN
         pIZ0S6PWaJJP9yxrIn68QicKYiPzWbWOmZlw+6Fg0RN/THfiSs60m2BCA+nQv8rZlrmY
         7FC0aStl/L+sC8PWgMI0evtjQzA0kdLtG7q2VtE12jUTy0Cjxj4hqKf78of8+HWAYyIu
         /gkKdPRqxtDZyvPcp8Rn9Rs57Bp/JxbQC+5utIyt9Ki//yJGrHBIWskqcIdHese9IWRF
         SmQg==
X-Gm-Message-State: AO0yUKWzeBADhmiTXM/8fVCH43YyToGuEMc3jdS89O5QR2ZL/hHM6ZhL
        14FsBXL6pzPbmkQTHN6WzqxHpa8pVUH8XKXE
X-Google-Smtp-Source: AK7set9wtos3ijgdYF60fZQbMVdsoDZU//5OgdqQdOD7JLhzwDBWVxwzzR8EXEZ6WAPoxJu/o6JU2Q==
X-Received: by 2002:a05:6a20:8426:b0:be:b137:9d1c with SMTP id c38-20020a056a20842600b000beb1379d1cmr1200129pzd.37.1675725294643;
        Mon, 06 Feb 2023 15:14:54 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id l9-20020a63be09000000b004f01a88e135sm6531907pgf.85.2023.02.06.15.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:14:54 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAhH-00CDwj-M5; Tue, 07 Feb 2023 10:14:51 +1100
Date:   Tue, 7 Feb 2023 10:14:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 14/42] xfs: introduce xfs_for_each_perag_wrap()
Message-ID: <20230206231451.GX360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-15-david@fromorbit.com>
 <1a182bbf59367d391ead1069a2299853467bb882.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a182bbf59367d391ead1069a2299853467bb882.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 23, 2023 at 05:41:09AM +0000, Allison Henderson wrote:
> On Thu, 2023-01-19 at 09:44 +1100, Dave Chinner wrote:
> > @@ -3218,21 +3214,21 @@ xfs_bmap_btalloc_select_lengths(
> >         }
> >  
> >         args->total = ap->total;
> > -       startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
> > +       startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
> >         if (startag == NULLAGNUMBER)
> > -               startag = ag = 0;
> > +               startag = 0;
> >  
> > -       while (*blen < args->maxlen) {
> > -               error = xfs_bmap_longest_free_extent(args->tp, ag,
> > blen,
> > +       *blen = 0;
> > +       for_each_perag_wrap(mp, startag, agno, pag) {
> > +               error = xfs_bmap_longest_free_extent(pag, args->tp,
> > blen,
> >                                                      &notinit);
> >                 if (error)
> > -                       return error;
> > -
> > -               if (++ag == mp->m_sb.sb_agcount)
> > -                       ag = 0;
> > -               if (ag == startag)
> > +                       break;
> > +               if (*blen >= args->maxlen)
> >                         break;
> >         }
> > +       if (pag)
> > +               xfs_perag_rele(pag);
> >  
> >         xfs_bmap_select_minlen(ap, args, blen, notinit);
> >         return 0;
> Hmm, did you want to return error here?  Since now we only break on
> error in the loop body above?

Yup, good catch Allison, that needs fixing.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
