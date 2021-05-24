Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEDFC2B9F8
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 11:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A96461248
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 11:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhEXL7V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 07:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32648 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232664AbhEXL7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 07:59:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621857472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gBjUa2nRpQaREb20KJBh+QSbceI06cH7v6nabFDej5s=;
        b=StK7uUhurmzdLvQmg8abBkZQXL6P7w4FBezyaRhNlW/tPsAPZCSWHUdjW9bd1nc/crzGTV
        uzufzjQq7DeBEI9ILhXX2gkCeHIJWawS1N5rhWnZJH3gx7PNUr+LvvkEPmhbfEa908eBY6
        wOWjLGFsoznNKxJiSBngW1NUbtVCGtg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-j3ymnIoWNOulSOHf5vWIbQ-1; Mon, 24 May 2021 07:57:50 -0400
X-MC-Unique: j3ymnIoWNOulSOHf5vWIbQ-1
Received: by mail-qt1-f199.google.com with SMTP id z9-20020a05622a0609b02901f30a4fcf9bso19648675qta.4
        for <linux-xfs@vger.kernel.org>; Mon, 24 May 2021 04:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gBjUa2nRpQaREb20KJBh+QSbceI06cH7v6nabFDej5s=;
        b=exAA73F6Szz6EVwg+BzBXLTEcIExR2jMg6wc1sEsil1jGffW81H3LkVotr8L1jXB5H
         qOkkeaYEknUleJmVgrliXiYADhx9XMGeI7WQhMVCqVurnoK/Gn8zIz1WkvHR0fETTPZF
         ttuJ4IA6q4hXnWSjiacEe6a9Z3kjaB0om2GuxLv+FuZLfoy77fYGwc8FkYNHFqqsZl9D
         sfcDUVhF2g3DLJ2eqkxwPG6JO7LnPFRwz6pEA0mUDMr9siF+ZWiGB5VsBd4hT31fPp75
         BsSZ77GtIGgQlLpRv6XJ9d+cM1aW17YWSmU6kwrAIMFMyWEb/j/SKlomdygBfcha9dPW
         AuBQ==
X-Gm-Message-State: AOAM532z1QWkJczEZ4421zbn/n/VVJ7gFwh3oR8vnMbdaJirSl9NIHcW
        2MgzXPatmrbz4llOKPtF/wzhUWfAyWrnGcwFPsP39p+jCncBNd9L6XJ9xJKCUsBgz3xT/w/5a0K
        4ldp5qlfuDw4bdJ2ZGBIf
X-Received: by 2002:ac8:4b65:: with SMTP id g5mr26923003qts.99.1621857470374;
        Mon, 24 May 2021 04:57:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBCBqseIt59+zUqt1o7nZHyGZvBbkwn5pbUOW6+M5xCIus8gENm21ONFHmm0JTEzJubX+y6A==
X-Received: by 2002:ac8:4b65:: with SMTP id g5mr26922994qts.99.1621857470212;
        Mon, 24 May 2021 04:57:50 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id l10sm10482883qtn.28.2021.05.24.04.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 04:57:49 -0700 (PDT)
Date:   Mon, 24 May 2021 07:57:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] iomap: resched ioend completion when in
 non-atomic context
Message-ID: <YKuUvHB6HUyQ6TWD@bfoster>
References: <20210517171722.1266878-1-bfoster@redhat.com>
 <20210517171722.1266878-2-bfoster@redhat.com>
 <YKi2hwnJMbLYtkmb@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKi2hwnJMbLYtkmb@T590>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 22, 2021 at 03:45:11PM +0800, Ming Lei wrote:
> On Mon, May 17, 2021 at 01:17:20PM -0400, Brian Foster wrote:
> > The iomap ioend mechanism has the ability to construct very large,
> > contiguous bios and/or bio chains. This has been reported to lead to
> 
> BTW, it is actually wrong to complete a large bio chains in
> iomap_finish_ioend(), which may risk in bio allocation deadlock, cause
> bio_alloc_bioset() relies on bio submission to make forward progress. But
> it becomes not true when all chained bios are freed just after the whole
> ioend is done since all chained bios(except for the one embedded in ioend)
> are allocated from same bioset(fs_bio_set).
> 

Interesting. Do you have a reproducer (or error report) for this? Is it
addressed by the next patch, or are further changes required?

Brian

> 
> Thanks,
> Ming
> 

