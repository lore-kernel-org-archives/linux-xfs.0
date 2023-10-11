Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB0ACD6E5C
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 11:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbjJKLNA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 07:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjJKLM7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 07:12:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BF9B0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697022734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/kEmWjWgOxRFcJRKEBCxKJxRrv3vBV4YFppvO0WCp44=;
        b=Q0dkqsfrYyBI2Q6gYOxcH21d7TPLWIjeujraI32HFr/GbS14M2mZeitZDhJ02TvPKJhyop
        JG9b6ZA6XDnWWEH7pMSpwL2GQUZ5SZ5tfxtoaIZjMEBQg4zeeUQNQBOLiczNNu8e8DSqgy
        3Fqt/UkjXA2M5tfaFOCnpMPhaIhlf60=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-bNRlBgYsPSSVpWz8JS3RwA-1; Wed, 11 Oct 2023 07:11:53 -0400
X-MC-Unique: bNRlBgYsPSSVpWz8JS3RwA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae70250ef5so92884366b.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 04:11:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697022712; x=1697627512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/kEmWjWgOxRFcJRKEBCxKJxRrv3vBV4YFppvO0WCp44=;
        b=R9Xjgxc25/SHK/bJDqJ9PUSwKea4sl7WS2hJQ25R8eglf2yJov5pcsSheKgXfQnK6V
         XX1E1DFm7CtCc4vSwci753DRcvXfkvtLPRZSwOZu8Hm6PNSE/aj2ikbtEQOvZbr6FAFq
         neuKg6JCLDqtPt1M6UrqF9jLGIXR1qmqZpnJAGB1LYze+ptaMQL6vTseq5TXe0JJsMJX
         9rSV6I0sJMaWqLKjM1wHvDA7ioR4rd7+C25GcLkmgOaKq/iL8asbk1DZWIEX5oHASDeq
         DyxzhQpA2k67zca847RqOE+vJ+laihmKsp4Z+FIj3vCTdZW06IJauxLUUCisRvrVGlLJ
         9KvQ==
X-Gm-Message-State: AOJu0Yw/rLArPYeiej4kni2AJoRvZb91nEIOUnxy08MwiuOaTzP/Kz6/
        ILIUcpee/iw37e8i2eFGQxgcUpQL2pSl04SR/+/hnpp3UQ0DGTL4dQWlQfYjICrQitvDq88pF7B
        wI+meYUWmSQLpa+rQa48=
X-Received: by 2002:a17:907:9454:b0:9ae:65d6:a51f with SMTP id dl20-20020a170907945400b009ae65d6a51fmr15512258ejc.18.1697022712109;
        Wed, 11 Oct 2023 04:11:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDgARfv/UqsKe2KQ66ychyLoGXLKXNYM7/TA5AoU9zv4vYFkvlQ37nunw7fm1lqRnWkTGQkw==
X-Received: by 2002:a17:907:9454:b0:9ae:65d6:a51f with SMTP id dl20-20020a170907945400b009ae65d6a51fmr15512240ejc.18.1697022711783;
        Wed, 11 Oct 2023 04:11:51 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id cb22-20020a170906a45600b0099ce025f8ccsm9668390ejb.186.2023.10.11.04.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 04:11:51 -0700 (PDT)
Date:   Wed, 11 Oct 2023 13:11:50 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 06/28] fsverity: add drop_page() callout
Message-ID: <jimlghyfxeyapqcm4jomf5wkwtz3ufcarlb4j2v3kbjxusn4iq@khjabsipk6rc>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-7-aalbersh@redhat.com>
 <20231011030646.GA1185@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011030646.GA1185@sol.localdomain>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-10 20:06:46, Eric Biggers wrote:
> The changes from this patch all get superseded by the changes in patch 10 that
> make it drop_block instead.  So that puts this patch in a weird position where
> there's no real point in reviewing it alone.  Maybe fold it into patch 10?  I
> suppose you're trying not to make that patch too large, but perhaps there's a
> better way to split it up.

Yes I was trying to make it easier to review. I will try to split it
differently :)

-- 
- Andrey

