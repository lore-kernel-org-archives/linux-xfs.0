Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEDBC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 10:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 742B62078A
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 10:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOh5Jfmx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHQKRY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 06:17:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56483 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbgHQKRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 06:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597659442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZdFKZoU3CuYymLed3uggvmMQZr6TYYUxwOugqqyi+w=;
        b=SOh5JfmxWqXYu5DYATf4nJLHoqDF46rbudRx2/kMONlTozINdC4QlKoBB92xFKGKf91IBK
        A0OQM5m6+UCPvy1VhXfj7wRQOxIDOFWMVR+PR5cl3tQGMFfJIvkDVwzRI4hEzS/7S+GjAl
        kb6KffbP6EqrEI075DG0zzzdjXYAa+w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-Om7ZU7PGPFyGOeRiamW78A-1; Mon, 17 Aug 2020 06:17:20 -0400
X-MC-Unique: Om7ZU7PGPFyGOeRiamW78A-1
Received: by mail-wr1-f69.google.com with SMTP id r14so6861768wrq.3
        for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2020 03:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=nZdFKZoU3CuYymLed3uggvmMQZr6TYYUxwOugqqyi+w=;
        b=SIKV1K9j4h/WPdt4zxBROK8exDb1qxh0R55ez0+uQQIkRYx40+rSNHA779xRz/HzT7
         bKRt4myJyjGMq/sQbJMasvAS54DkJq6RnBajtCZxDK894Y8k6BYP4EsZJ8kABlzLU+ky
         do+1EklTqDkUobUc6435rJSdLuRtxa6YdsqinbBny9KgkZoUmlcvDYEichrfvCFV+E93
         /fypJPbia7KgeuZTEXjVPFzqC7ywannVrj24cN623eLzRKPr0tRm3/w3pZBwmNbUlmz8
         yvmWw7WfLOp4y9jyxvKPfUMghpi/NqooJirGVUaHUmEmLjEHXxRVOkZqSRhp2nHYNHFL
         uZ9w==
X-Gm-Message-State: AOAM531pviNJImmQ4jKCd3LWKjhyQWBEn2XMdPjjR7VIQUSodB4bZAZt
        wzdkouL+WX20SvoB0FSgQZBnhhGMRT6hFSIHWKFZWop9ADD8t3z1BStvNNG2DFyEWTTCVBhslQR
        VGc+Qp6QrvkimhuyX6Km3
X-Received: by 2002:a1c:a3c4:: with SMTP id m187mr13470962wme.43.1597659439063;
        Mon, 17 Aug 2020 03:17:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzU248yJcjFSCihmvHmouZyVQEzT9FLQ2AG9qlG/gOjO6nIc2+Am1HP6mvvEj1a5TQ6pys4w==
X-Received: by 2002:a1c:a3c4:: with SMTP id m187mr13470946wme.43.1597659438872;
        Mon, 17 Aug 2020 03:17:18 -0700 (PDT)
Received: from eorzea (ip-86-49-45-232.net.upcbroadband.cz. [86.49.45.232])
        by smtp.gmail.com with ESMTPSA id v15sm29895736wrm.23.2020.08.17.03.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 03:17:18 -0700 (PDT)
Date:   Mon, 17 Aug 2020 12:17:16 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Get rid of kmem_realloc()
Message-ID: <20200817101716.mmcgbdpkimc6wvl7@eorzea>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
References: <20200813142640.47923-1-cmaiolino@redhat.com>
 <20200817065533.GG23516@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817065533.GG23516@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 17, 2020 at 07:55:33AM +0100, Christoph Hellwig wrote:
> Both patches looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> although personally I would have simply sent them as a single patch.

Thanks Christoph. I have no preference, I just submitted the patches according
to what I was doing, 'remove users, nothing broke? Remove functions', but I
particularly have no preference, Darrick, if the patches need to be merged just
give me a heads up.

Cheers.

> 

-- 
Carlos

