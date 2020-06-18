Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC20C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 12:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0998F2070A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 12:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eRUd0HWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgFRMhy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 08:37:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38708 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729864AbgFRMhw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 08:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592483871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eG358ofoUnmsLE/Y5rjQIbnjgCn65iK1IVr7NWl3TcA=;
        b=eRUd0HWws5O2RmkGUQ5rfskPnPPR5lO0lFtAMlETP5aJBolQJy9OQvmdp8rebDndp+uttu
        sed8p/jkskw4B9rZ/l3X1btia8uW/FzEd5Sxb1A+bS1ePS2+onhfFrtS+tMcgTzKgbNQ/A
        quq5IVaLhZQRdADIYdhvaaE+GTtwTu4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-F0-_oypGO--tErqPqRl4JA-1; Thu, 18 Jun 2020 08:37:49 -0400
X-MC-Unique: F0-_oypGO--tErqPqRl4JA-1
Received: by mail-oi1-f200.google.com with SMTP id a17so2626659oid.19
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jun 2020 05:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eG358ofoUnmsLE/Y5rjQIbnjgCn65iK1IVr7NWl3TcA=;
        b=TzloUn2DVLMaXc5XjeyBqYvM4LW2ruwXvX8hVW8w4YgTXat7UteYYqNKhDgJmk8YMq
         goSkYhGkQzmMtxGr0xdzhtt5z4J/k+uXxFOttXBLqpXvkHzwI1q0eZ/kCFx3b9NCK8Ya
         4r6iMSVO4TMk8xH9hcVSY9wXgEeaVGh2CVVLWiHYe0HyaXOdnw2aS4fC1rBfYfiZusrS
         wfvzRV6nVnWjtqX3haqAF9Y77h+iVE2tHVR06UlE9CkSiP1UIqfddvQ3wDLopffWYkR4
         YbBL56hbLUYxdutBWO3kZLxThtzZ9xoTmyPVmaMCPrWo1Lw4gBTTwtKdGh9x7mXLQXIx
         AAGg==
X-Gm-Message-State: AOAM533AOJXWS6KfXX6iachnnkxibq3IxwB57OECPESKi77e1dDF7Dje
        FMmXsjnoman704nUtj+oOeqAjkF7OJy+xrA0qWIN7vyzabaGmcPeujNbv0gJAfs1y8ZXgddiSZD
        HDqJsfa/yWH8IL8eYPXoonjeFzi2+fjYtel0C
X-Received: by 2002:a4a:d1ca:: with SMTP id a10mr3811829oos.31.1592483868759;
        Thu, 18 Jun 2020 05:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLwUtT1EDG5M+CYqt7D1khEZwMXhLHQ9HprBeCqCod5nLvYnyxPsw1MOMrXkwBZTHrtsIKoJzZUv37sqjz46s=
X-Received: by 2002:a4a:d1ca:: with SMTP id a10mr3811816oos.31.1592483868548;
 Thu, 18 Jun 2020 05:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200615160244.741244-1-agruenba@redhat.com> <20200618013901.GR11245@magnolia>
 <20200618123227.GO8681@bombadil.infradead.org>
In-Reply-To: <20200618123227.GO8681@bombadil.infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 18 Jun 2020 14:37:37 +0200
Message-ID: <CAHc6FU5x8+54zX5NWEDdsf5HV5qXLnjS1SM+oYmX1yMrh_mDfA@mail.gmail.com>
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
To:     Matthew Wilcox <willy@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bob Peterson <rpeterso@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 18, 2020 at 2:32 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Wed, Jun 17, 2020 at 06:39:01PM -0700, Darrick J. Wong wrote:
> > > -   if (WARN_ON(iomap.offset > pos))
> > > -           return -EIO;
> > > -   if (WARN_ON(iomap.length == 0))
> > > -           return -EIO;
> > > +   if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0)) {
> >
> > Why combine these WARN_ON?  Before, you could distinguish between your
> > iomap_begin method returning zero length vs. bad offset.
>
> Does it matter?  They're both the same problem -- the filesystem has
> returned an invalid iomap.  I'd go further and combine the two:
>
>         if (WARN_ON(iomap.offset > pos || iomap.length == 0)) {
>
> that'll save a few bytes of .text

That would be fine by me as well. Christoph may have wanted separate
warnings for a particular reason though.

Andreas

