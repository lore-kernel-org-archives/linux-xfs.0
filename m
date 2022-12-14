Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC746C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Dec 2022 10:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbiLNKYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Dec 2022 05:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiLNKYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Dec 2022 05:24:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7712C62F8
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 02:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671013448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9yG5JV06r9TcNN4oFhlXP0Fq7y0VXR4zsj82aFUNl6c=;
        b=FlroUzgKAp8uYkxm/xZiNKA8/MzDzy7atT0m4RU84boHpCy5FdRhR24jkT3FeTY9kZTfWN
        wdg4SWD2YfhNGxGYDOr4e2/ujDSlbUygW7LfT4wVGiyKhrSxIHX3dQsehmsVqt9kLdrYNQ
        yiMk1sbCOwNkVhXMwDLKi4HFC+hwNSo=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-261-wkgIQyYyNS-y_Cv_y6EGbg-1; Wed, 14 Dec 2022 05:24:07 -0500
X-MC-Unique: wkgIQyYyNS-y_Cv_y6EGbg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-3b48b605351so204794257b3.22
        for <linux-xfs@vger.kernel.org>; Wed, 14 Dec 2022 02:24:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9yG5JV06r9TcNN4oFhlXP0Fq7y0VXR4zsj82aFUNl6c=;
        b=bqflKl4KQ/f0x6VOG6qfe+KRq/dCl4HRSSZIx9xAmbMjQO115KvxvfumVuToMzRpIF
         j3lMkJ+3BXLsaYjhg/E8F8g3HGEJ0crzMJCtMJSmWitdc2MPdNutnuK5LlP0/4Ujy07v
         JsyAr7zPuXcE7j7ejU/QBGPNEAIwjUJJSuje8iqc/8eQvVDKy8p5ssf48cR5oloUzKHS
         lW8/94o/YJqXJQT7EJJlX9T/BUHFLBQl7rUpMu5zu7PflWUz8T+/oyyZwvbW8VEP/iRG
         8FVGVRfuyGwTcpsoVzhxhNogRGcd11SuU/QvWJQqcCwECWH5b8sgXAfUm9wgOcKKIVqk
         6QQQ==
X-Gm-Message-State: ANoB5pmJ8ZMUFpit215bnCgonY87qsl6PR1+vRbgma9C5oVlLbiBmFZP
        CqwsYuje3ywiybfM57+Bw3rceDtd30RLo2Wj2meplzYLFvXtp1vF470iNt3ORSRKUqnrrf7SeBH
        QIvm6HOjV6wQNNganOCcqYPAnWfac3nUHUMVx
X-Received: by 2002:a25:909:0:b0:6f6:e111:a9ec with SMTP id 9-20020a250909000000b006f6e111a9ecmr48384781ybj.259.1671013446802;
        Wed, 14 Dec 2022 02:24:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf61cW0VEZXZNysLUpNNresP+dckKKxSg1BOV8+R05IGkzjNCFGZ/0C6A9iUp0+CkXmSutXnr6PHEpDQw0QN8Ys=
X-Received: by 2002:a25:909:0:b0:6f6:e111:a9ec with SMTP id
 9-20020a250909000000b006f6e111a9ecmr48384777ybj.259.1671013446592; Wed, 14
 Dec 2022 02:24:06 -0800 (PST)
MIME-Version: 1.0
References: <20221213194833.1636649-1-agruenba@redhat.com> <Y5janUs2/29XZRbc@magnolia>
 <Y5l9zhhyOE+RNVgO@infradead.org>
In-Reply-To: <Y5l9zhhyOE+RNVgO@infradead.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 14 Dec 2022 11:23:55 +0100
Message-ID: <CAHc6FU6_RduhNAmA3SgDN74Zux9OZtyRg-bUU4c3YGgO8tm9+Q@mail.gmail.com>
Subject: Re: [PATCH] iomap: Move page_done callback under the folio lock
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 14, 2022 at 10:07 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Dec 13, 2022 at 12:03:41PM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 13, 2022 at 08:48:33PM +0100, Andreas Gruenbacher wrote:
> > > Hi Darrick,
> > >
> > > I'd like to get the following iomap change into this merge window.  This
> > > only affects gfs2, so I can push it as part of the gfs2 updates if you
> > > don't mind, provided that I'll get your Reviewed-by confirmation.
> > > Otherwise, if you'd prefer to pass this through the xfs tree, could you
> > > please take it?
> >
> > I don't mind you pushing changes to ->page_done through the gfs2 tree,
> > but don't you need to move the other callsite at the bottom of
> > iomap_write_begin?
>
> Yes.

I assume you mean yes to the former, because the ->page_done() call in
iomap_write_begin() really doesn't need to be moved.

> And if we touch this anyway it really should switch to passing
> a folio, which also nicely breaks any in progress code (if there is any)
> and makes them notice the change.

Okay.

> That being said, do you mean 6.2 with "this window"?  Unless the gfs2
> changes are a critical bug fix, I don't think Linux will take them if
> applied after 6.1 was released.

Yes, I really mean the merge window that is currently open.

Thanks,
Andreas

