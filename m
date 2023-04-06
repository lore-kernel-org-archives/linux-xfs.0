Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B33C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 16:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239816AbjDFQEU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 12:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjDFQET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 12:04:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F2886B0
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 09:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680797021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nhE+sw2nPXqC1UJ8AXPzZyQsVdsNsrouSAWZ5kkzANM=;
        b=O0k1WQYJuPSNVsZ2HbSwcWOIXQbeaYc8+gqz7zSL7XHD3fiYcyOHN62QgCxRyr4aNZlys9
        +7tT4qbvJh59SSowsGVGU5H8LJwDYFW5XhHiEaME4TzLrkkY1sAXnibDCGW8RuM4Oi3gm3
        bZLuSnPbov2qdUyS/JvtZAA4qfs0iCc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-ZEUecTugNZichBpL9g4Oug-1; Thu, 06 Apr 2023 12:03:39 -0400
X-MC-Unique: ZEUecTugNZichBpL9g4Oug-1
Received: by mail-ej1-f70.google.com with SMTP id de5-20020a1709069bc500b009339c9c32ffso443045ejc.5
        for <linux-xfs@vger.kernel.org>; Thu, 06 Apr 2023 09:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680797018;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nhE+sw2nPXqC1UJ8AXPzZyQsVdsNsrouSAWZ5kkzANM=;
        b=qDSCrbzPSEaf541ZdukEc8laKlJrLyw47SAKhV75XT9x8TVHTSU9FoYHfDSLpNNABe
         /EtY57FiRiHyU4egpPtQojNOJC+VBXeZDfEfZS7CbprG0vQArHBQP7mIvlHa404b+l6j
         qURj8oo4v4WIkgpbUJ5L5vJ0aqNuuNJxamfLdgl99OkUwrJnmvVoWyzI4sY2WtWCFbXU
         bsFwosUOXk+MZIDFzeczufnvWcQNuQEi9AIAv8pqBzrFjwCENnvU4pYs4kropVGXY5vE
         yleK9dSMAoK808kphl0+UVyt3hI1LTkFNe7AEsuysIiVgblyufibiJcRt+oka50AGzaB
         Wmyw==
X-Gm-Message-State: AAQBX9f7AAO82hDyr1chwf7cGWo4rCymS4cq+k0wSRYJ80wLT1wXsw9H
        buRVUkWa78coWG0wm6FplicLH/41JLXIBvZFOxm5ND0+1th84Tap20CHB3WcSrEizVTe3zkMrCB
        h72mwmPXoRRSLetkyX9PpZmFVjL1ruk2NH9vJbEPtvZMuQPY=
X-Received: by 2002:a17:907:7f0b:b0:8b1:7569:b526 with SMTP id qf11-20020a1709077f0b00b008b17569b526mr3699967ejc.11.1680797017899;
        Thu, 06 Apr 2023 09:03:37 -0700 (PDT)
X-Google-Smtp-Source: AKy350bj25JTqlPH4xO7mSRLb2uiNpfWZQ6CHwGpry0pz+NotDKptf776qNa/IjvZu9utWI9ekaWvAw2s40+5EjYFv8=
X-Received: by 2002:a17:907:7f0b:b0:8b1:7569:b526 with SMTP id
 qf11-20020a1709077f0b00b008b17569b526mr3699956ejc.11.1680797017538; Thu, 06
 Apr 2023 09:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230404084701.2791683-1-ryasuoka@redhat.com> <e51e9fb1-ad5c-5cf8-fa04-4e3a10023739@sandeen.net>
In-Reply-To: <e51e9fb1-ad5c-5cf8-fa04-4e3a10023739@sandeen.net>
From:   Ryosuke Yasuoka <ryasuoka@redhat.com>
Date:   Fri, 7 Apr 2023 01:03:26 +0900
Message-ID: <CAHpthZrcegPXhti5tDdb=_nwafWnU-FXmtc6aRU7juowMpOnUQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Use for_each_perag() to iterate all available AGs
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eric,

I failed to reply to you since I got some mistakes.
Let me re-send my reply just in case.

Thank you for reviewing my requests.

> Can you explain what goes wrong if it is zero? Is there a test for this?
>
> If it's a general problem, what if the other 2 callers pass in the variable
> start_agno with a value of 0?

Sorry I couldn't prepare any tests to confirm what happens if it is zero
because it is a kind of general problem.

IIUC, passing zero to for_each_perag_wrap() is not problematic.

As the comment describes, this macro iterates all AG from start_agno through
wrap_agno, then wrap to restart_agno, and then iterates again toward to
start_agno - 1. It looks like some issue occurs when start_agno is zero.
However, for_each_perag_wrap() actually won't wrap if start_agno is zero.

static inline struct xfs_perag *
xfs_perag_next_wrap(
struct xfs_perag *pag,
xfs_agnumber_t *agno,
xfs_agnumber_t stop_agno,
xfs_agnumber_t restart_agno,
xfs_agnumber_t wrap_agno)
{
struct xfs_mount *mp = pag->pag_mount;

*agno = pag->pag_agno + 1;
xfs_perag_rele(pag);
while (*agno != stop_agno) {
if (*agno >= wrap_agno) {
if (restart_agno >= stop_agno) <<<--- HERE
break;
*agno = restart_agno;
}

pag = xfs_perag_grab(mp, *agno);
if (pag)
return pag;
(*agno)++;
}
return NULL;
}

/*
* Iterate all AGs from start_agno through wrap_agno, then restart_agno through
* (start_agno - 1).
*/
#define for_each_perag_wrap_range(mp, start_agno, restart_agno,
wrap_agno, agno, pag) \
for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
(pag) != NULL; \
(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
(restart_agno), (wrap_agno)))
...
#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
for_each_perag_wrap_range((mp), (start_agno), 0, (wrap_agno), (agno), (pag))
...
#define for_each_perag_wrap(mp, start_agno, agno, pag) \
for_each_perag_wrap_at((mp), (start_agno), (mp)->m_sb.sb_agcount, \
(agno), (pag))

OTOH, since we have already a for_each_perag() macro, which just iterates all AG
from 0 and doesn't wrap, I think it is simpler to use for_earch_perag().

Regards,
Ryosuke

