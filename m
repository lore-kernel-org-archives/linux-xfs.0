Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8ECC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 23:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiDKX6Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 19:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiDKX6Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 19:58:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD552C103
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 16:56:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id mp16-20020a17090b191000b001cb5efbcab6so868421pjb.4
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 16:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u4J7Bf/GotxjJfY4hYTghw/TTioM2LYvPTAkJWjY17E=;
        b=HQ+2vciUuGFcRUAADBBBewhLLxx/n8IwutVwi9bDSH5UBx/sMIz11gFenVTKEO5i2V
         Z3KkkM9CsYrzCcapeOzqAPFCFARrC/nGi7vHH0YUZMEyTwShG2fVEKyBuJ+b4TCzPDd6
         szbu08LY1PXwGtFdjtHzkI48ZOaN1iB6bh793hvWxqcO0deFyRSoPQt9LUnPAXwTeeVl
         Tb/JasLYg9PNiFlSaZ65haBXwam6yS94qYrcv5vEzr4MKjqx1+yFqkfPGe4cwK/rfrsj
         +9U3IHhasFilk7p3D90KspNTXQykty6L7GEhgqlF9JxHABSU3bCtlbzBEt8Xnh/InXLg
         0JMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u4J7Bf/GotxjJfY4hYTghw/TTioM2LYvPTAkJWjY17E=;
        b=ISCJhocEQFh/5aA9U4T/1AwLfJQs5HeUh4Mx9HlvPZgFpZE0qPm6VZ8p3ni6+3ki7I
         OOLOQAiN7Izi4Djf9XL+qSGhVlAsKKb/7Pn5g88NW9qy1ThJ18Z0526cpP9PWeEi1xba
         rDdewoLI01Sbnq2NqeBIEAVypnISbJYpguAqQ6QegM/AQqadZ1xnMyCzZhSa0m+0OYiW
         qm3tTKXEaUXv7z3R4SogoRQM17lCJgk0ywqSB0F/KBdbf4kU+HQOrmuf99C/0oknM0w7
         uv2zyyIr4e2WQJSiIWEEr3VLUzj/OSe5KJM22UhJpqxAlzk4YZWJgQ3RhmNXcKUR8S1+
         1s3g==
X-Gm-Message-State: AOAM530yjST23VUg5mnI5nBl7T/pWqPvTbazhlZNRw+HB1bKZU/bgy2D
        CilfhZ0sRN6VT+CHZjJ0nZ9QM961iA5cWtqZqufOsw==
X-Google-Smtp-Source: ABdhPJwz526LJSdeFPj6/c7PsF49maypY+wjW8NyQ8pIICoB0k38/TF9Lk5dkB3kd2++yFgVX8lzKCKbNtcxf9v/5dw=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr34383349pll.132.1649721368525; Mon, 11
 Apr 2022 16:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-5-jane.chu@oracle.com>
 <Yk0i/pODntZ7lbDo@infradead.org> <196d51a3-b3cc-02ae-0d7d-ee6fbb4d50e4@oracle.com>
 <Yk52415cnFa39qil@infradead.org>
In-Reply-To: <Yk52415cnFa39qil@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 11 Apr 2022 16:55:58 -0700
Message-ID: <CAPcyv4gfF4AhxD_vqCS9CTRraj8GAMDYQ7Zb411+FvxhF4ccOw@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write dev_pgmap_ops
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jane Chu <jane.chu@oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 6, 2022 at 10:31 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Apr 06, 2022 at 05:32:31PM +0000, Jane Chu wrote:
> > Yes, I believe Dan was motivated by avoiding the dm dance as a result of
> > adding .recovery_write to dax_operations.
> >
> > I understand your point about .recovery_write is device specific and
> > thus not something appropriate for device agnostic ops.
> >
> > I can see 2 options so far -
> >
> > 1)  add .recovery_write to dax_operations and do the dm dance to hunt
> > down to the base device that actually provides the recovery action
>
> That would be my preference.  But I'll wait for Dan to chime in.

Yeah, so the motivation was avoiding plumbing recovery through stacked
lookups when the recovery is specific to a pfn and the provider of
that pfn, but I also see it from Christoph's perspective that the only
agent that cares about recovery is the fsdax I/O path. Certainly
having ->dax_direct_access() take a DAX_RECOVERY flag and the op
itself go through the pgmap is a confusing split that I did not
anticipate when I made the suggestion. Since that flag must be there,
then the ->recovery_write() should also stay relative to a dax device.

Apologies for the thrash Jane.

One ask though, please separate plumbing the new flag argument to
->dax_direct_access() and plumbing the new operation into preparation
patches before filling them in with the new goodness.
