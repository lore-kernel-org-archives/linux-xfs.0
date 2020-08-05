Return-Path: <SRS0=76Cg=BP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432A7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Aug 2020 20:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14BD122B42
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Aug 2020 20:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLdpXk/H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHEUMT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:12:19 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56146 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726640AbgHEQZe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Aug 2020 12:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596644702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RDiNTwaajX9EstP2+rkOoaOqP4Sp0ty/xDldPk1nRuY=;
        b=ZLdpXk/HNS+AUi3ROo21rtg5Qv/XEfMrWtwgHBP6n1uUNof4vHLTDb87x3rxT0koc07SI1
        KTy/QnlzYkehHheLsKET1MfkI4cCZ3DuAAVbypP255ovHcsjVT2UagoKVgj5mgELRtEPhL
        jo0xtTQdhi26UO7nuMhsfxoSWEsvsFk=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-m-niOmh1OL6WJ_sYmQRKNw-1; Wed, 05 Aug 2020 11:54:43 -0400
X-MC-Unique: m-niOmh1OL6WJ_sYmQRKNw-1
Received: by mail-oo1-f71.google.com with SMTP id v21so20595759ooq.12
        for <linux-xfs@vger.kernel.org>; Wed, 05 Aug 2020 08:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDiNTwaajX9EstP2+rkOoaOqP4Sp0ty/xDldPk1nRuY=;
        b=S6Z9j5v0D2h/WxqL3jbIroXJSsF4oOZiV5DOjnsNx2YQBrhFqRIUWo+r2nu1jyKIwi
         s0FQoiZjjwUfVCGqczB2ALQPjrgdaXuwioWxISNCii21teipqWLVLYpRg0kIdNfDr7mr
         t2iDDnVkDGL6hc/Po/HH5UtgPj98wiKdZHVyPSROabGrrghzIErDAasxT+XlXMeikq1V
         CwuxEiHVuXQpKf/p6v2HPbmPWL62mvUQqYZCh4nNIy0jjbrCHf+WxZ8GE9xZSJg6yo64
         ognuh3GpyeeXvV5NXeEVIyitIOx2tkIuy/mfdPs56HFqg0eLyqx3KCMQ7FUINXLhv9i1
         NNGw==
X-Gm-Message-State: AOAM533a8n7o4NLuk6TvPvnlSFybu40OPfRm0a82gPH0jZoppPK+HxEV
        OxtQzXJwGHV6/g4VeG4J4HevxaextdwPGGadtzYBuY57I9Oza6Bk8dPM7PipKpjNq2kzFvipjqr
        QVASDj6rxZyb4Pa6RVh7Je2JT2VFTu6P7wPr/
X-Received: by 2002:a9d:3784:: with SMTP id x4mr3040059otb.95.1596642882736;
        Wed, 05 Aug 2020 08:54:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFNuf696slwlPSZJynKjLvYPlN0RCiKIOzOVmS4vUbpxiRMAJuurwOtGRZDzCz52Sm2DXwT3decGCiphYpc3o=
X-Received: by 2002:a9d:3784:: with SMTP id x4mr3040047otb.95.1596642882501;
 Wed, 05 Aug 2020 08:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153214.GA6090@magnolia>
In-Reply-To: <20200805153214.GA6090@magnolia>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 5 Aug 2020 17:54:31 +0200
Message-ID: <CAHc6FU6yMnuKdVsAXkWgwr2ViMSXJdBXksrQDvHwaaw4p8u0rQ@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.9-rc1
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, riteshh@linux.ibm.com,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Aug 5, 2020 at 5:40 PM Darrick J. Wong <djwong@kernel.org> wrote:
> ----------------------------------------------------------------
> Andreas Gruenbacher (1):
>       iomap: Make sure iomap_end is called after iomap_begin

that commit (d1b4f507d71de) contains the following garbage in the
commit message:

    The message from this sender included one or more files
    which could not be scanned for virus detection; do not
    open these files unless you are certain of the sender's intent.

    ----------------------------------------------------------------------

How did it come to that?

Thanks,
Andreas

