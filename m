Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50B1C54EBC
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Jan 2023 08:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjALIn4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Jan 2023 03:43:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238924AbjALInU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2023 03:43:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B294033D74
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2023 00:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673512830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sJ1DLzY6SS8/uPcPkUVmu/oFedCftB/N+XCnRFr9bW0=;
        b=MXzvqRW6Z3WcToht8Y1tOHpGPhY3c51EAoDPR/2dI62BKBNK5/si5pU2P/fOkM+CAWrfmo
        MvjSerr2Ws17VLyOtEp4+6YFdaIO70jiPS+n1daMsTUOzfB25wwL8cW2wswgE2RqPBU3ba
        xvlzGiM9A+Bqv1vPs2H98+cqIgOf4lM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-311-xHQ_fB7NM42CMoPMbaUR9w-1; Thu, 12 Jan 2023 03:40:29 -0500
X-MC-Unique: xHQ_fB7NM42CMoPMbaUR9w-1
Received: by mail-ej1-f70.google.com with SMTP id jg25-20020a170907971900b007c0e98ad898so12174444ejc.15
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2023 00:40:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ1DLzY6SS8/uPcPkUVmu/oFedCftB/N+XCnRFr9bW0=;
        b=kYa8tmFmFOSfFm4a6F6WoUH/kQjGFwDe95U4pB1C1itB8bM598N4O9C+HYvIGdTzEk
         5bblgnWFHEvSeuwd26RGx5LBOPMUXv9ytPD/04HEoAusxDisoGM67FYJGyqbMhBeuGBz
         Rt44Jr3qqXNW+IQGdyWTpr0tk9JxwDT9GOc9B530SCzXBIY8lr/24mrgVKXIm5eFHeBr
         huuReO8YtNhP0wK2fpApuikJWi9IuetdvdXRFjPSgzdw7vvbTmim0w1nn9ehpSjMT9Ip
         utvnnMsqen5AuLhMPni7oaVBPSjHFCo7ARIysMgzk2JfEDc0Bd2/ErMuQW2npW7gcrY8
         Cx8w==
X-Gm-Message-State: AFqh2kpGWrQlK/H9FlO2eCgjDp226CA88JLeHwsY5haf1iLOgAz/l4IL
        x67NojU2bdttKTKogVTlpOVtHy6z2mvRiBS/6uHVVfrYWZ3KK7ms0h8T7aX9IsQx3M0mrusrQMI
        3NjKxNLX8SAgk7zbQ2xmu
X-Received: by 2002:a17:906:9141:b0:7b2:757a:1411 with SMTP id y1-20020a170906914100b007b2757a1411mr72558279ejw.9.1673512828382;
        Thu, 12 Jan 2023 00:40:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtkGUh3Q53qkPZ8VBrWhVNvaf84ui4sY1GVD2HHm6puqJ4nuiHdgAhWg0QMF2pdbhY5I/w3IQ==
X-Received: by 2002:a17:906:9141:b0:7b2:757a:1411 with SMTP id y1-20020a170906914100b007b2757a1411mr72558266ejw.9.1673512828169;
        Thu, 12 Jan 2023 00:40:28 -0800 (PST)
Received: from nixos (2A001110012E8C7F057F4AD255C44D29.mobile.pool.telekom.hu. [2a00:1110:12e:8c7f:57f:4ad2:55c4:4d29])
        by smtp.gmail.com with ESMTPSA id z20-20020a1709067e5400b00809e33ba33dsm7185483ejr.19.2023.01.12.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 00:40:27 -0800 (PST)
Date:   Thu, 12 Jan 2023 09:40:12 +0100
From:   Csaba Henk <chenk@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdocs: add epub output
Message-ID: <20230112084012.dgpn2jfd5otvrjgs@nixos>
References: <20230111081557.rpmcmkkat7gagqup@nixos>
 <20230111221027.GC360264@dread.disaster.area>
 <20230112014401.ifwjtqx4jzbykeep@nixos>
 <Y79oxBdLUovKkn+N@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y79oxBdLUovKkn+N@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23-01-11 17:56:20, Darrick J. Wong wrote:
> Does epub support add more dependencies that I have to install?
> 
> Not opposed, just curious.

The to_epub function in a2x:

https://github.com/asciidoc-py/asciidoc-py/blob/10.2.0/asciidoc/a2x.py#L811-L861

utilizes docbook / xslt tooling. Which tooling is already among asciidoc
dependencies, so nothing in addition is needed.

Another concern that came to my mind is whether epub production will be
supported in all environments which are likely be used to build the docs.
I think we can be reassured fairly safely in this regard, as support for
epub was added in 2009, by the following commit:

https://github.com/asciidoc-py/asciidoc-py/commit/27749467

Regards,
Csaba

