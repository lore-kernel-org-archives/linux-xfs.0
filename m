Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4252FC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 16:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26B2960F24
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 16:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhKAQPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232655AbhKAQPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 12:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635783176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+G6SzjVTR+LCyYNlG0zbcp2+gduPxDNU+2Zc+nwBRpo=;
        b=OSGCzH7a9iwXipiTHXUGo0ViW4DQj+HOpxAD9jdj6SQT3OMsIMINUJqLIoxrv37CEdPivy
        BBYalGl+Hf/j1rPWI5ToSbwXQmb4zIXtemJC726Rt+HykiFddlTIctqsfIt08KH+Wtk5NW
        nmF8FM6EQKMZHFJ7vPOmuIz1BuWLhjk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-jChEWbO1OrOM66Ier0TDQQ-1; Mon, 01 Nov 2021 12:12:55 -0400
X-MC-Unique: jChEWbO1OrOM66Ier0TDQQ-1
Received: by mail-qv1-f71.google.com with SMTP id e10-20020a0cd64a000000b0038422ec2242so16679157qvj.19
        for <linux-xfs@vger.kernel.org>; Mon, 01 Nov 2021 09:12:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+G6SzjVTR+LCyYNlG0zbcp2+gduPxDNU+2Zc+nwBRpo=;
        b=ufiutE8T6B5w+MmMuBa4FRmCpDndd836AzDnBq/RD6/fdOxS5XJBROn02ZExL+oynV
         TWtoIpwjrjczKyiZMaCWDy5fW5UJ/6Ii785RQqzwSd/9Qzo/RK34/zx0oj7fAqpGKDj5
         QbZdWJ36ZCYhVrX/1jq/tUxil95N7ABtVhjemvHGLkCATVkYOr82VuOTMMR31JFLVwX0
         fM2rBnVDMW1SIvmOc/+xgTdz6VLqpTOMEGzZb0vieETVk8Y7dpzs2S52FzbfqM57LvsX
         p8OSNE18cmIjrR0sivVvBv2Juv3MaiPejl2pG6lG6kJueu1iYO3wUEwjhobE9XhLwXtB
         f6cA==
X-Gm-Message-State: AOAM532sAuzG2x8pBWTwP+Rvh4rIjDPH3+sUZOP033f4S7jHyB8WjgVJ
        LemxQ6WH2WxS4TB8D6BcY47SYZLmRNPDoLGDsOqaV2jx/+fxThK1qnzufrUf7Z0IOq0Jjl4lYyF
        roIc6UjskHgHHfln6S30=
X-Received: by 2002:a0c:e708:: with SMTP id d8mr23264804qvn.62.1635783175445;
        Mon, 01 Nov 2021 09:12:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/H7B1fdn7PP13//AwKmpta1av9FRTtOajPRoBskVHgoJcCnXd+0D44u/s4udzcALoTqA+Rw==
X-Received: by 2002:a0c:e708:: with SMTP id d8mr23264758qvn.62.1635783175189;
        Mon, 01 Nov 2021 09:12:55 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id v16sm167031qtw.90.2021.11.01.09.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:12:54 -0700 (PDT)
Date:   Mon, 1 Nov 2021 12:12:53 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 01/11] dm: make the DAX support dependend on CONFIG_FS_DAX
Message-ID: <YYASBVuorCedsnRL@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-2-hch@lst.de>
 <CAPcyv4hrEPizMOH-XhCqh=23EJDG=W6VwvQ1pVstfe-Jm-AsiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hrEPizMOH-XhCqh=23EJDG=W6VwvQ1pVstfe-Jm-AsiQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 27 2021 at  4:53P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > The device mapper DAX support is all hanging off a block device and thus
> > can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
> > of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
> > be built under CONFIG_FS_DAX now.
> 
> Looks good.
> 
> Mike, can I get an ack to take this through nvdimm.git? (you'll likely
> see me repeat this question on subsequent patches in this series).

Sorry for late reply, but I see you punted on pushing for 5.16 merge
anyway (I'm sure my lack of response didn't help, sorry about that).

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks!

