Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44250C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345547AbiFMTBr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346583AbiFMTAz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:00:55 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D34C457B6;
        Mon, 13 Jun 2022 09:27:57 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v25so7911755eda.6;
        Mon, 13 Jun 2022 09:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ecbCGDm5rpI5jVUz/6v/mWvooe4Rz5r0NY/UldMSsC8=;
        b=NnA1iu382wjTbbKjTooXvv8Zm8WoiifhJIfi4CGZxqlnQLY5fm4pkSx1TJOKuFf45S
         DyE1IrQERfGIwP5/E6kmKNAW/SNN9VuElHeqlsp96ph552Gs47MNyBIUfslAS00nUECj
         VVl76foxx86OLXIzjQN+SIAFAzpYr2QKEuUdSoEsmPsqdO7MCoj41SXWwE6vya1ozrue
         0AcA38PrQJgdtW2nDdgye/O2iKsKF2iTzkTE/Yx4E5U+DtVtanHrjH1GipOJNGfG405l
         Im8J+FZBRpvfDVW18Mjp49O2FYuC9unyFqx0l53q93WYKfWkNAefIMXbyKGEQZJ/Iyoy
         JHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ecbCGDm5rpI5jVUz/6v/mWvooe4Rz5r0NY/UldMSsC8=;
        b=1o9fLOoFZ4kOkECh6ocwinUbJ4d5KnJ2JqEQhfPb7oa+TpJGykG25ojZoYlwfHaLPc
         V0eUr79WzL8KGYx0CO42+6/08GkEoifYMoZa+dmhPjK+eWEvt1Qr7TRbvr2nimwAsBz2
         ugXVLgg1FO0qU1k43gbRbuqiAev2/NvBCTybKFThLTW3LN9xavMm7akYqZxwsCtPgfea
         GeKfFMWHbOZAr5he9oJJoIDkTY008A6f83EQKx/bMYmI17YFHbQqnE7vQXxZoNiZfJQy
         rl6vbcoU8AhXrjgh4qHYJAPGgMM/IfvF86i9F3oFhch8y4wmXTauluvIBI9mKqL45b7Z
         01BA==
X-Gm-Message-State: AOAM5306fzmH1s7uNJp8VJa3cDk1XDYFMS83CdZ3me7FB4L33swJ/l9M
        TTYnHUxRQyIxjaoqAZfcUbokoAUeKZiTLHA1zmg=
X-Google-Smtp-Source: AGRyM1s0d0c3KdwHKocTgcEh9VlSBkWzdotxU/TJBlrBjUjl5K2Pf9nr2x783P6x9j7Cu5oKbYjGeYXhFjTZfF9fTKU=
X-Received: by 2002:a05:6402:4301:b0:42d:e8fb:66f7 with SMTP id
 m1-20020a056402430100b0042de8fb66f7mr577087edc.229.1655137675949; Mon, 13 Jun
 2022 09:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220612213227.3881769-1-willy@infradead.org> <20220612213227.3881769-3-willy@infradead.org>
 <YqcInB4IHXEM7jpC@pc638.lan> <202206130919.BA3952B@keescook>
In-Reply-To: <202206130919.BA3952B@keescook>
From:   Uladzislau Rezki <urezki@gmail.com>
Date:   Mon, 13 Jun 2022 18:27:44 +0200
Message-ID: <CA+KHdyUi+Lz_hD8XTcdphkLRpC=980G-kbLbMePEgb4mj784Eg@mail.gmail.com>
Subject: Re: [PATCH 2/3] usercopy: Cast pointer to an integer once
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>
> For the future, please put your tags ("Reviewed-by") on a separate line
> or the workflow tools (b4, patchwork, etc) won't see it. :)
>
OK. Thanks :)

-- 
Uladzislau Rezki
