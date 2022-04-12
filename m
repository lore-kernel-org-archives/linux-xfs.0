Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8A6C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 09:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiDLKAm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbiDLJmc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 05:42:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E3A861A2A
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 01:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649753274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8j73F4KYuVNfbOqQ2tBdzOoEal08IKt31ONBAxqG4sg=;
        b=gTVqUSfddj9Pt5s/AyJbDkU0n5ua9Al69SWr7CeCNwtyjM4WxbMqcbRqKE5RtvtCnTnw6m
        8aFDVcdWh3NGXwnc0hJDA9jriKXoi13V5Brzw+mHoy0I/RtT/Oe7sc3VYmkRUpXzYhxbPN
        flhZUs/8LEeYpyu0PC1zYL37HqQdMOI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-3WZOH4kYMV6QXS2sSIlrKA-1; Tue, 12 Apr 2022 04:47:53 -0400
X-MC-Unique: 3WZOH4kYMV6QXS2sSIlrKA-1
Received: by mail-qv1-f69.google.com with SMTP id eo15-20020ad4594f000000b004443ac37d09so6244676qvb.0
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 01:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8j73F4KYuVNfbOqQ2tBdzOoEal08IKt31ONBAxqG4sg=;
        b=8JNu8Dz3uvyrTWpaRWAANgzzmxxPF7OCdh3R6T5+Fiz1gQ6yAvpJIPsksBWvZmzcQ9
         1pqFhPm1KwHtPQwFqiExmp8z6oAVan+p87c85wVTib7QW47utjthhLQxkzlsQme2MkEJ
         kdJGDW5YeIWJ3+6o8JQale6qoNdWJUijIlMzrIR4XH9SgnYZn9U9ImsPlSS/V6KV2aRw
         kcqMTE67AS/h1AGuTgZBeZx9M5k1RJs8oN9yyJot8Idi6cOcAjLhVhFOTsn1yKcpcwto
         dRpWuoXI7AA6jCGXe1d+drn4WdLmvuC2I70sIOgsncbCHEgRn1utVLrCLGZw/9sCrXW1
         sP2Q==
X-Gm-Message-State: AOAM531hts7QnqLoEaldtwLaXxXhQoHdZp9mNPGZ0xUsLBy+Nm/vi0K8
        maI5A/xSZHEkKUO/5BcpPM1fsk6N1tTQeLxzU95T5TuACF3uZuB9VlX1JQLOOhity5ZiEl863vd
        wd1Q68pSi3ynttBEvK17c
X-Received: by 2002:a05:6214:21ec:b0:444:8356:4cb9 with SMTP id p12-20020a05621421ec00b0044483564cb9mr1378352qvj.38.1649753272862;
        Tue, 12 Apr 2022 01:47:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyy+SlCJK3RCU/EQ3mZGoiWXT4ngJymuEpc0IEV51Ns3s0EKcjxChSNXx4Y+Tyz5JiltqcFcw==
X-Received: by 2002:a05:6214:21ec:b0:444:8356:4cb9 with SMTP id p12-20020a05621421ec00b0044483564cb9mr1378345qvj.38.1649753272653;
        Tue, 12 Apr 2022 01:47:52 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f12-20020a379c0c000000b0069a048e7f0bsm9535301qke.76.2022.04.12.01.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 01:47:51 -0700 (PDT)
Date:   Tue, 12 Apr 2022 16:47:46 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] xfs/507: add test to auto group
Message-ID: <20220412084746.th3gapgutwspf6rb@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <164971765670.169895.10730350919455923432.stgit@magnolia>
 <164971766805.169895.12082898167045363438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971766805.169895.12082898167045363438.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:54:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add this regression test to the auto group now that it's been quite a
> while since the fix patches went upstream.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/507 |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/507 b/tests/xfs/507
> index aa3d8eeb..b9c9ab29 100755
> --- a/tests/xfs/507
> +++ b/tests/xfs/507
> @@ -4,13 +4,17 @@
>  #
>  # FS QA Test No. 507
>  #
> +# Regression test for kernel commit:
> +#
> +# 394aafdc15da ("xfs: widen inode delalloc block counter to 64-bits")
> +#
>  # Try to overflow i_delayed_blks by setting the largest cowextsize hint
>  # possible, creating a sparse file with a single byte every cowextsize bytes,
>  # reflinking it, and retouching every written byte to see if we can create
>  # enough speculative COW reservations to overflow i_delayed_blks.
>  #
>  . ./common/preamble
> -_begin_fstest clone
> +_begin_fstest auto clone
>  
>  _register_cleanup "_cleanup" BUS
>  
> 

