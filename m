Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_DBL_ABUSE_MALW autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72A4C2D0DB
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858312082E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 13:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QiyQsE3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgA3Nnc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 08:43:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbgA3Nnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 08:43:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580391810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zrhEjh7Usx2Sur3j32z7XTjjURhy9DMxcxHibtbO6OQ=;
        b=QiyQsE3io8XeXp0IvdVgw1nXx6RRxxNOcofgaA43ZYJGbQHzQjCksOn5BtcUnyafPR13GR
        EJUis4jqVd1YhVwjvXA2RG4OgVON3N0PJxyFNfjhMKNPJGLbvJh1Wjsit6mFwUAwipYfcB
        CvxleAEE2zmRW8Hy/oWalx9axuu2FZw=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-JXccWQALMly3vHQPfOZGxg-1; Thu, 30 Jan 2020 08:43:28 -0500
X-MC-Unique: JXccWQALMly3vHQPfOZGxg-1
Received: by mail-vk1-f198.google.com with SMTP id e25so1285033vkm.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jan 2020 05:43:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zrhEjh7Usx2Sur3j32z7XTjjURhy9DMxcxHibtbO6OQ=;
        b=qtIb6vdOZH6pluBb25WtQ960Tvh7pHN6G6c48RxUq5pVJQOXtuQLyLufyeQL0ReyO/
         ZSzP+dltdrmkYsJ0QnlvnlRu8jamUrkSZuvBWX5pBZgpYTN+5gTVr+E3bqHUc2dUNXQT
         umAwS1Vh9MIHmP5ILxkftvnYKKwoTxP4B+0ZEhG9+4hhKwiOYXk5mSUIAJb90+6zN8QX
         vYzWu5LSjSpp6/66K7JUpyrtnMhoOh8Oyx4if1qejFZRhu7WnDzNAhV9wF2yMIg00Cd/
         h0zxmlhPpTybKFsdNqNs6pIcyU1bJID/aChFp4qMSv7EM6UCYynaV6+iA+OX/+a09yeg
         B+0g==
X-Gm-Message-State: APjAAAXIm9okmLQ36lvmUHi/pP6AH+6DCwOCMOrenwMpRDP+TkxhxDf9
        +PhaGpRGBx8rzzxgYrQIJe/HjEgEg0lixxoyxETHcPEM1fz2hsjPBnmwVEtQ0oKmVwfhQZlcyWB
        6D9lr9aEMlCUmRiEkHwqameRdj4tz+/KBZJVz
X-Received: by 2002:a67:e954:: with SMTP id p20mr3255615vso.3.1580391808403;
        Thu, 30 Jan 2020 05:43:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUvp8qGHSdwE17B6N0E2EBVEHb/BfrvWV/BM1U4VLJQSfVnZvgmFJmCP9Hi2g1hj7H6eXeWDLGDVVizz46UV4=
X-Received: by 2002:a67:e954:: with SMTP id p20mr3255597vso.3.1580391808188;
 Thu, 30 Jan 2020 05:43:28 -0800 (PST)
MIME-Version: 1.0
References: <20200128145528.2093039-1-preichl@redhat.com> <20200128145528.2093039-5-preichl@redhat.com>
 <20200130074503.GB26672@infradead.org> <CAJc7PzUmpRP0-MG49kO5XqZKfM-o4SpYtUKpXC3LC_3Yi2htZg@mail.gmail.com>
 <20200130133135.GA21809@infradead.org>
In-Reply-To: <20200130133135.GA21809@infradead.org>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Thu, 30 Jan 2020 14:43:17 +0100
Message-ID: <CAJc7PzX=fdF5x7M6hbbN7jquta7TG8SZswJORVUJv4=-VQMXcg@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: replace mr*() functions with native rwsem calls
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

OK, thank you for your opinion. :-)

On Thu, Jan 30, 2020 at 2:31 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Jan 30, 2020 at 09:57:02AM +0100, Pavel Reichl wrote:
> > the changes are divided into three patches so the changes are really
> > obvious and each patch does just one thing...it was actually an extra
> > effort to separate the changes but if there's an agreement that it
> > does not add any value then I can squash them into one - no problem
> > ;-)
>
> Well, they make the change a lot less obvious.  After we have some form
> of patch 1, mrlocks are just a pointless wrapper.  Removing it in one
> go is completely obvious - splitting it in 3 patches with weird
> inbetween states is everything but.
>

