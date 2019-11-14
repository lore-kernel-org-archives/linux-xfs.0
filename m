Return-Path: <SRS0=4PMG=ZG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0514C432C3
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 05:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBBD220723
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Nov 2019 05:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SuC8AwQd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfKNF0N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Nov 2019 00:26:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33309 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725601AbfKNF0N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Nov 2019 00:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573709170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1VgPYGe072zeFg1eUMJL939fGIeIs+XCxKq9YuhKJU=;
        b=SuC8AwQdtLICZh4sSvBDoOHqnQvqB0fC9/6hKsg/ocpKrUH0u8YsGCSIQ69qn04WMthQRX
        olWWLEDsD/wO6U3++3fwRwaaD0bZ0Rh0Z5P3pVn+IxStqFygnoqoF087TYAdJ9Ym2n2sU/
        LHaC/MDu6+qQN9vC4h3MpQ1Azd6DEZo=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-ZsPV7NiXOFCw3gZwqMGoAw-1; Thu, 14 Nov 2019 00:26:09 -0500
Received: by mail-ua1-f70.google.com with SMTP id l2so1161773uan.22
        for <linux-xfs@vger.kernel.org>; Wed, 13 Nov 2019 21:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J1VgPYGe072zeFg1eUMJL939fGIeIs+XCxKq9YuhKJU=;
        b=poDXaohiZtIsGz5xpsbIW2/DAFZYknrZNQCWhNAOmGvCyErGTHQVagyskGVsZkhbTa
         +1t0NMpJ1ygEvLmQosXETAiLeG8ImV7Y4YhWGlfNNcocFChUSvci7HPMxnYfW5ohSx5P
         RYuax9lHYtisZcTdJzsisswokjRl771N4T8aQGTOeXkxwvFzCrZPqG2L6Jq7ph83wpzm
         /otZ0EeUuXnDRHbDGsOd8ftwCoKR6ho90CLTwn5hxquudt7+H8KP1E1v6tQ2nIqPoqg0
         +V3kHF+RyFfd14Ojcki45VlfDUcvD1dggzno43mzt7e5NTDsFX6rdIm+yGBVQUjm7IUP
         Xogg==
X-Gm-Message-State: APjAAAWgOAEQZq46ePhnIBa0d0sHgvkfuux/svr3W91Zqw/xQI/Uwkcp
        UVvf55waUHNfw5Kkle7WzqxQbetIzDav1RifEvCpAotaD5gSIaT5OfOg5LMlRmKLR95SRnINaiu
        VVT9lUg9MDEYTbdMw5OZmOCPqRkWR5wDALSyd
X-Received: by 2002:a1f:944a:: with SMTP id w71mr4185939vkd.60.1573709168635;
        Wed, 13 Nov 2019 21:26:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDKUfBAMjZK+fW1+QytruPQC8E3PGKohrnFNGEimR0keKu6sr+U68jXM7UaS5l6dtHLU5/DZLVp1jm1xHRto0=
X-Received: by 2002:a1f:944a:: with SMTP id w71mr4185928vkd.60.1573709168405;
 Wed, 13 Nov 2019 21:26:08 -0800 (PST)
MIME-Version: 1.0
References: <20191112213310.212925-1-preichl@redhat.com> <20191114012811.GW4614@dread.disaster.area>
In-Reply-To: <20191114012811.GW4614@dread.disaster.area>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 14 Nov 2019 06:25:57 +0100
Message-ID: <CAJc7PzXuXkA33FuBSoMBxOV9k0jWVKP9LtNC+oFYwp8SvZxm8g@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] xfs: remove several typedefs in quota code
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
X-MC-Unique: ZsPV7NiXOFCw3gZwqMGoAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

sure, I'll do whatever you guys suggests me to do.

I believe that by change log you mean just a textual description of
code changes which should be part of the cover letter, right?

I didn't do change log so far because I was just following the points
you gave me during the review process, but I understand that since
there were 2 reviewers I probably should have done some change
summary.

Thanks!

On Thu, Nov 14, 2019 at 2:28 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Nov 12, 2019 at 10:33:05PM +0100, Pavel Reichl wrote:
> > Eliminate some typedefs.
>
> Hi Pavel,
>
> Can you keep a change log in the series description so that we know
> what has changed between versions? it makes it much easier for
> reviewers to re-review the series if they know what has changed
> since last time they looked at it.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

