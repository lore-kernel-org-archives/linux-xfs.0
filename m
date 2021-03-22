Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B164C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 03:46:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD9861973
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 03:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCVDq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Mar 2021 23:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVDqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Mar 2021 23:46:21 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B787C061574;
        Sun, 21 Mar 2021 20:46:21 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id t16so8019619qvr.12;
        Sun, 21 Mar 2021 20:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=yCgNbVIvbudUC75gTwrY6lp/6YIs5gvQkvTcBrMzs/4=;
        b=LOiForbwlAFzpmYpNtLVCNzU7G+sI6Gxiou2uuWS7t64yj0QNxtfRdzUsirtTtBLwT
         HIpHz+jSxgUX7WiWuDpE4a7wvHNABNwS7kF0aQcCPyWzpV0CyOj4LbSg6YGb8b6KxJ5R
         XGi80s57xkq7iM3oupGqD+wa2cI4BDMPYCnXF1vh9NZkDd/ysfUypRj/XkQq15qCuy0b
         gYvGHQXi7DuxDz74ZX/V69X2nXeapCNjxwZUWHCZs5FrmUQwmdIu6uOurJzPY7vL4gbG
         kkRFUg4jyoN4XDKCek5CW9bz/jNYN4rADwmfY7M7LXKQr7IJC4QpaBrU8Ip0XQC/tgH7
         du9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=yCgNbVIvbudUC75gTwrY6lp/6YIs5gvQkvTcBrMzs/4=;
        b=gaIPCbIqhqL4xHM+IlY6l3N+6QdrIKZ5UJTB4xF/nUfTbtZYCsVlQPBIxYwX39D8D3
         7BPkKYY+Yt73ipMPp0VNPpUNK+SDKlwkt8AQ9Ppcvca/kR8n1or588eQt59KAgsnEytX
         pW1i+qg++nsbvja4t7oZH0OLprCc0MX/13aebvXxm8v1Pa7feO3ye0v1AXdzyhq60DKX
         +Ntn5875s8daqteYQt/cs8DVIWB5Q74QAWW/Upyn7L3mir6JMhLgO8h4sj3Say47t0J1
         kS8DxRzu+8V6WYqiPXOEr/9g3FK2PpAjD4803ir1y3gyJd1zp6iwbVF6nu4iNPWTd/DF
         zQjA==
X-Gm-Message-State: AOAM533hoGo8P9vBHay4f3L6Ra70N08ooXW6t4/qdmsOOhG7K6C7izhk
        6GsufFRt/hvj3M9lkX1Q0VInAMGuHwLhr3z8
X-Google-Smtp-Source: ABdhPJzP2u9IR0lCmuisGscpFibbhexOu6oZGNfv95I5YGf9fS9/bbuU9oVkHQWTfm1O6VVWZziBHw==
X-Received: by 2002:a0c:ef81:: with SMTP id w1mr151864qvr.0.1616384780359;
        Sun, 21 Mar 2021 20:46:20 -0700 (PDT)
Received: from ArchLinux ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id g21sm10129136qkk.72.2021.03.21.20.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 20:46:19 -0700 (PDT)
Date:   Mon, 22 Mar 2021 09:16:09 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Rudimentary spelling fix
Message-ID: <YFgTAcZrVwPGgWEM@ArchLinux>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210322024619.714927-1-unixbhaskar@gmail.com>
 <6d410ec3-438d-9510-d599-bb8b825a6d3e@infradead.org>
 <20210322033316.GB22100@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MLnT8l+raFVSWvgW"
Content-Disposition: inline
In-Reply-To: <20210322033316.GB22100@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--MLnT8l+raFVSWvgW
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 20:33 Sun 21 Mar 2021, Darrick J. Wong wrote:
>On Sun, Mar 21, 2021 at 07:52:41PM -0700, Randy Dunlap wrote:
>> On 3/21/21 7:46 PM, Bhaskar Chowdhury wrote:
>> >
>> > s/sytemcall/systemcall/
>> >
>> >
>> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>> > ---
>> >  fs/xfs/xfs_inode.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> > index f93370bd7b1e..b5eef9f09c00 100644
>> > --- a/fs/xfs/xfs_inode.c
>> > +++ b/fs/xfs/xfs_inode.c
>> > @@ -2870,7 +2870,7 @@ xfs_finish_rename(
>> >  /*
>> >   * xfs_cross_rename()
>> >   *
>> > - * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
>> > + * responsible for handling RENAME_EXCHANGE flag in renameat2() systemcall
>> >   */
>> >  STATIC int
>> >  xfs_cross_rename(
>> > --
>>
>> I'll leave it up to Darrick or someone else.
>>
>> To me it's "syscall" or "system call".
>
>Agreed; could you change it to one of Randy's suggestions, please?
>
Sent out a V2. pls check.
>--D
>
>> --
>> ~Randy
>>

--MLnT8l+raFVSWvgW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmBYEwEACgkQsjqdtxFL
KRXdegf9HnbRtry5WJRZjIirl9JovQEclZJxSUbxz4NY94Kg+/G2eI8FXn0a9f+X
7EnwCPp8JQYO5d6djJ/Yi9zHB739Tm/5gFH7zy5A5mABbJlIPe4Z+S9YqdfUknRT
xzT5srS31CQIB7VPvJJIzd+fDGZgGANlWRjyUArY9A0BshqCkeFINm6RymFAu0Te
G4AxiFd9EqDxCNdzG5UNP92zxtFkS99ypq5I8gm87/T7dG7P2XXVGuLralZiSAHt
grMWCtVDjxx8hgL+iiRtFgSvUjqkq86zTLxYT02uxpBi4Ut2v5eDghF9a+5pYTT9
+7qUaqPbcXUOvhM44PBfEMogN1sh/Q==
=yBq7
-----END PGP SIGNATURE-----

--MLnT8l+raFVSWvgW--
