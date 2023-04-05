Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B5C76188
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Apr 2023 15:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbjDEPqp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 11:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbjDEPqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 11:46:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BE06EB9
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 08:46:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id ek18so142241154edb.6
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680709574; x=1683301574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ghVXTJmT9jRdSxcT/cdZ7E2XYsC95tHfVG+bDyFICG4=;
        b=O35aIrZ0wXmYYhtcsAlHyxgf+FaVwb6b4sWrOxk5xr//HKS6nyIy/o6smWbWQb3Fju
         7kmY2ZmyXF8WX0zxJTGTwV/i2SAAQSCkfz4zn9dHLoxjuozrOnFECBGtEnRx0djO8Ddt
         /7YC+zZzapg+3nWM8XjFToFoQ7KzLhAazrWjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680709574; x=1683301574;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ghVXTJmT9jRdSxcT/cdZ7E2XYsC95tHfVG+bDyFICG4=;
        b=sgvXoPh2B8NWWMWCj4VmZo2hv86QnuCC7CSMZQ7pPTsBg4htSiBY70/xhJO/1/MEej
         cMcacc6JndyTl+s5BtASwNvQRhkbGCyUgKifCyis9Wfk+6u1qkHrDOumwELuwsJra9iO
         vet0ofZfxoeAYmFI/vssYz4GpBP+a4X3t0RKu/p2cgJlihuYcs1fw3BoC9NKpVPJTD4+
         y03qhia7nCIvfWI8rLlPNON+kBJoWmQIe6qD/8EpeXg09bDeTSpcuHwsbFhAgABZSIlu
         M9UiYq2hyYFFkFfBIDJPEvsMGAGNkX27/JhM2aKAOhaAgeqyf+5LY/s+jwKJoEs8APe/
         mlNA==
X-Gm-Message-State: AAQBX9cBlYejBWAfmeNDLTEIB4b0260WXpZyimF3lY/F4Mj+I3DqwPuI
        0D8Eh6NcHeYoRT5tRNbuQRHmGVofY61Q9coCVzCPGA==
X-Google-Smtp-Source: AKy350ZpWE/9avq2CUiV9PqEB4upcQCfN5GURRkR251Qfgy1+Py9bg2HNkecYL/QSSrlNL6oqchPpA==
X-Received: by 2002:a17:906:a194:b0:92a:8067:7637 with SMTP id s20-20020a170906a19400b0092a80677637mr2920015ejy.61.1680709573775;
        Wed, 05 Apr 2023 08:46:13 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00928de86245fsm7493709ejb.135.2023.04.05.08.46.12
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 08:46:12 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-935558f9f01so45700066b.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Apr 2023 08:46:12 -0700 (PDT)
X-Received: by 2002:a50:950d:0:b0:502:227a:d0da with SMTP id
 u13-20020a50950d000000b00502227ad0damr1447574eda.2.1680709572344; Wed, 05 Apr
 2023 08:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
 <168062802637.174368.12108206682992075671.stgit@frogsfrogsfrogs>
 <ZC1R4IRx7ZiBeeLJ@infradead.org> <20230405153002.GE303486@frogsfrogsfrogs>
In-Reply-To: <20230405153002.GE303486@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Apr 2023 08:45:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wii36=6xYi2wyqD=Vjipcw471akEjJSmfKBD4h4hjST3g@mail.gmail.com>
Message-ID: <CAHk-=wii36=6xYi2wyqD=Vjipcw471akEjJSmfKBD4h4hjST3g@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfs: stabilize the tolower function used for ascii-ci
 dir hash computation
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 5, 2023 at 8:30=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> It *seems* to operate on ISO 8859-1 (aka latin1), but Linus implied that
> the history of lib/ctype.c is lost to the ages.  Or at least 1996-era
> mailing list archives.

I'm pretty sure that the *intent* at the time was Latin1, so if the
table matches that and there aren't any bugs, I think we can just
document it as such.

I just don't know why we decided to actually do the conversion from
7-bit tables to 8-bit ones. That is shrouded in the mists of time, but
it's unquestionably true that we were fairly Latin1-centric back then.

We got better. Slowly.

               Linus
