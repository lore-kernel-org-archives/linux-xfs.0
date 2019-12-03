Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2285C43215
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 21:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71BCC2073F
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 21:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575408087;
	bh=Y/DPWh1Y+1hT3scg5yeiXtEhxvwqjipTM3/frNsQlS4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=DpZmy6ptSbN/DkjR9KUZWWlE76o2uusCXm2McFMa41wIOglfI4VDPKM5ZB2s/C7iz
	 GDC6+S1itwfYhxCG1nro8s4KUsBl2YWnE3cWG0xWRlztCLWzBueE4T8D9ZdtaDZrEU
	 EnXbERnqn06cpznd1ipoorEPPpGpNbR8ubSnGVaQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfLCVV0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 16:21:26 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33120 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfLCVVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 16:21:22 -0500
Received: by mail-lf1-f66.google.com with SMTP id n25so4291007lfl.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Dec 2019 13:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/2Pn+nUwTPiWQNmD6ZcUyBL9YYHx/8hYVUPPzlyrC1w=;
        b=YWt7tCChJawBH2mlGjm75VvKQF1n9lq0PB4WHZENSOIYbPbM+TMiv+A4sz31FIrIF+
         qv6rVeradhmwJ1y3LywV1hVUnY+3sdobJHBMSiCoBi14y0F23F0EVwMMAXxXELbrEtOr
         HkKcuRhQ3sww6TYp8jETEWeDjYOJ+2N3IyHRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/2Pn+nUwTPiWQNmD6ZcUyBL9YYHx/8hYVUPPzlyrC1w=;
        b=a/GSM4YrFMpV5FjN6kOGhA+80bb+WoO5aeT1PY7KD28cY5EgH9gIegIkUy5m97c0Dq
         ly7zySzcCwZSB852zHH5fzbT/3AVTOzDzrYqLM2xFcYWUlCYkOrGCSv8Elbv1fNb2nQF
         Ir+U1IwdLBs/xw39lql81xLQBnqg/vwxcsnLHoLQ9jAVhpemFyGQT2lifPRvTxfd9XR3
         OYg0PunHqK2W3rktFl1o5aQsZVResZvvRhIEWIT1NzKbGznsgLgCEJx9qlvV9IEW/Qqs
         uHoJkmwsH0CI+cKBkQBUIFNkqAPNxS5r4Fjv2CC44x8k/Bt6mIJWxbhQ7+i/CUWsaW+Y
         PNJA==
X-Gm-Message-State: APjAAAVYeI8wmpmfmWRfEuLyEdWQwwhM8j47UxUYZfM06GWo/Paib6yv
        BrE6Vgt325FTyOseIVVPC6yEjfAm7q0=
X-Google-Smtp-Source: APXvYqxaCW+lmVrDw0ZUTR5KWqmwj0NLK1W9AHIVQFmBY28fwDU66+Hf9/Iz8jcaGHrl3UNAALUHZw==
X-Received: by 2002:ac2:5616:: with SMTP id v22mr20687lfd.84.1575408080477;
        Tue, 03 Dec 2019 13:21:20 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id g6sm1944348lja.10.2019.12.03.13.21.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 13:21:18 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id h23so5487101ljc.8
        for <linux-xfs@vger.kernel.org>; Tue, 03 Dec 2019 13:21:17 -0800 (PST)
X-Received: by 2002:a2e:63dd:: with SMTP id s90mr3908645lje.48.1575408077519;
 Tue, 03 Dec 2019 13:21:17 -0800 (PST)
MIME-Version: 1.0
References: <20191203160856.GC7323@magnolia>
In-Reply-To: <20191203160856.GC7323@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 3 Dec 2019 13:21:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh3vin7WyMpBGWxZovGp51wa=U0T=TXqnQPVMBiEpdvsQ@mail.gmail.com>
Message-ID: <CAHk-=wh3vin7WyMpBGWxZovGp51wa=U0T=TXqnQPVMBiEpdvsQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: small cleanups for 5.5
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        cluster-devel <cluster-devel@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 3, 2019 at 8:09 AM Darrick J. Wong <djwong@kernel.org> wrote:
> Please pull this series containing some more new iomap code for 5.5.
> There's not much this time -- just removing some local variables that
> don't need to exist in the iomap directio code.

Hmm. The tag message (which was also in the email thanks to git
request-pull) is very misleading.

Pulled, but please check these things.

           Linus
