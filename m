Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1F1C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D95225AB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389865AbhAKRt1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:49:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389863AbhAKRt1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 12:49:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610387280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+HlN/PqY4GJPaaoKZ4/mGd4P1cRZjy2uaErxSn8YxUg=;
        b=XnIe9OQMD3bMMuy2nbUk0v0+DOUzD+T6ovx0zpO3ksYGn1S7i12TieCBaqQkx9Lz5Gejzx
        NPNb2x6crm6fs9msqXAJKIflHHpG9DG5msGQ9tUFPM34hdyPVvkvBxW3/LzG5GhiTyrPlf
        lHxUyY9rvGfLdVip0+Vv3/C2o0wks6Q=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-2AZxoOx7M0-odtmQhlfoPg-1; Mon, 11 Jan 2021 12:47:59 -0500
X-MC-Unique: 2AZxoOx7M0-odtmQhlfoPg-1
Received: by mail-pj1-f70.google.com with SMTP id v5so19799pjt.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 09:47:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+HlN/PqY4GJPaaoKZ4/mGd4P1cRZjy2uaErxSn8YxUg=;
        b=FAyxfrgvmmGmQgTkODRAfe9akl8TaQBsuUwxw50TkkzQHnQz5IpbclKUKKpA5u0vOi
         Wf6oAbxKXwkx4sxBgDKbOh+3A1mdow3EeKA5C3RGxrsBT4uDIyjeHMJJAhDa7O2Hzph8
         8rj+yMNUzlczfVsakQj9IKoFGnCMLY27YO4KNrrx7baHdyBA9W2bkLhLRH49ApC9a0sL
         ImlEj7PWCVKztpNxG9KUCIgDi48n487novPEvZzwRdYYL7gNNhzBiTK+aU0Cw9SCGYcz
         MiEduckzR1SP/P7pjPXuB1WIrmxa6TtpRlblkJFQWe/QHQThtEdRfld6bkF2ck4Nl8Wu
         BFOA==
X-Gm-Message-State: AOAM531mHpo2Htmfc27VRAb8VnZ0lyysNMtiEZTkKhfqUCPabasQb9uf
        920yKX1pDdwbNluSL9wZn4/+S2LqZXU9zxPUMTQCr/AG/cmsXNg46E1G6/Z+daxBV7D1KGa8PGX
        2kedTvAJle2XmYCqdzZga
X-Received: by 2002:a17:902:ac98:b029:da:cd0f:b6a4 with SMTP id h24-20020a170902ac98b02900dacd0fb6a4mr831292plr.71.1610387276786;
        Mon, 11 Jan 2021 09:47:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuRb+yTQMjsZT6HLStO9pHNrYS075GGjeSTYXi8dGfDTA2PoXw20HZMCcmaFeIbMqdSylBRw==
X-Received: by 2002:a17:902:ac98:b029:da:cd0f:b6a4 with SMTP id h24-20020a170902ac98b02900dacd0fb6a4mr831274plr.71.1610387276509;
        Mon, 11 Jan 2021 09:47:56 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b1sm8058pjh.54.2021.01.11.09.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:47:55 -0800 (PST)
Date:   Tue, 12 Jan 2021 01:47:45 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v3 3/4] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <20210111174745.GA1213845@xiangao.remote.csb>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-4-hsiangkao@redhat.com>
 <20210111173249.GC848188@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210111173249.GC848188@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:32:49PM +0000, Christoph Hellwig wrote:
> > +	xfs_mount_t		*mp,
> 
> Please use the struct type here.

Sigh... sometimes still forget to modify after copy & paste from
somewhere... Will fix tomorrow.

> 
> > +	/*
> > +	 * Write new AG headers to disk. Non-transactional, but need to be
> > +	 * written and completed prior to the growfs transaction being logged.
> > +	 * To do this, we use a delayed write buffer list and wait for
> > +	 * submission and IO completion of the list as a whole. This allows the
> > +	 * IO subsystem to merge all the AG headers in a single AG into a single
> > +	 * IO and hide most of the latency of the IO from us.
> > +	 *
> > +	 * This also means that if we get an error whilst building the buffer
> > +	 * list to write, we can cancel the entire list without having written
> > +	 * anything.
> > +	 */
> 
> Maybe move the comment on top of the whole function, as it really
> explains what the function does.

Ok. Will update tomorrow too.

Thanks,
Gao Xiang

> 

