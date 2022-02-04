Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7774EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Feb 2022 05:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbiBDFRW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232647AbiBDFRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Feb 2022 00:17:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F32C06173D
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 21:17:21 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id oa14-20020a17090b1bce00b001b61aed4a03so5123421pjb.5
        for <linux-xfs@vger.kernel.org>; Thu, 03 Feb 2022 21:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ADbV2ue0euhPpU9doft99rslDDTP7SctadFXHagiPcw=;
        b=iXDtyFJP5WtiAy0xBjR8o34yPHnEQRbyQYdWa57M1Yeo0LLgXvIX15A5LJEQ6AAc0C
         M+oj+BBkthciCSEr5D9A/ZPzjoo9IIfQFDH0g6ZSAjDLbvXegqkjTKRVnHrXRbGMQEEN
         +uq4Go8PgIlUO6ptZ8qiEyy7lRQ63LkMf5Hbti84XU/dyIXgmK77j3fQBCKKVDrAh+xO
         mE1q/7xS6/eVN8s0FriHvE3+QFjHjDzE7jCGDL6JqpiP8nZ27q+Tlb9grC04zikPvOBu
         wpSKHQDMCq5J5McJk+EXZJKVWLLnSE8X19QK2JBXj1syqjawR+/fY5z7lPlbuRCKdASu
         /pBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ADbV2ue0euhPpU9doft99rslDDTP7SctadFXHagiPcw=;
        b=OxyR0IeuHjlQH9ufnRtHKvQpEQsHcpNxvwMzfNYYoskBhMhoTEogDArVeTHQmDZdwJ
         5fXsY+8QeEGMkWa1Iq+xD4wwljdRId95PLDd78wUfM1mTBGZhbjHe6k7S/ttNHvM+R6B
         idly8BjbcVafUTUDIFNSNa1wK6BISe09ALRnGfxyrjk5BRDPmpOhk70Jt2KR/h0Zsk14
         MIPslkCFuqCStXy+7MPncSRqvsEcZZ0ck52ALWBGxHu43QCR5Sw39b7yyFDepLEWatuh
         8D8Oz8AqSQG5LH8sdwsG+aKF2z8pmfLOgtkdh0WHKgVpJZexAddrWuzbf/HeaBoPQtCa
         gscQ==
X-Gm-Message-State: AOAM533mO8H2gicgeap9w+AlmdbH9nWVp3Yv3jSzXUR5Xa/SwQ+3yVpE
        RvVE2BYtBohWOh6a+I5WXzONr1iJ7Pzkdsa4+D807A==
X-Google-Smtp-Source: ABdhPJxe0WhiE5t6uv14wKW/F80lHdFsDU+VqJ0ecIJJh7mLBCyPclSFFi4XvO8Vld3qiSEwvpeHFisH+3f0GowxwMU=
X-Received: by 2002:a17:902:b20a:: with SMTP id t10mr1357273plr.132.1643951840594;
 Thu, 03 Feb 2022 21:17:20 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com> <20220128213150.1333552-3-jane.chu@oracle.com>
 <YfqFuUsvuUUUWKfu@infradead.org> <45b4a944-1fb1-73e2-b1f8-213e60e27a72@oracle.com>
 <Yfvb6l/8AJJhRXKs@infradead.org>
In-Reply-To: <Yfvb6l/8AJJhRXKs@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 3 Feb 2022 21:17:08 -0800
Message-ID: <CAPcyv4i99BhF+JndtanBuOWRc3eh1C=-CyswhvLDeDSeTHSUZw@mail.gmail.com>
Subject: Re: [PATCH v5 2/7] dax: introduce dax device flag DAXDEV_RECOVERY
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
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 3, 2022 at 5:43 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Feb 02, 2022 at 09:27:42PM +0000, Jane Chu wrote:
> > Yeah, I see.  Would you suggest a way to pass the indication from
> > dax_iomap_iter to dax_direct_access that the caller intends the
> > callee to ignore poison in the range because the caller intends
> > to do recovery_write? We tried adding a flag to dax_direct_access, and
> > that wasn't liked if I recall.
>
> To me a flag seems cleaner than this magic, but let's wait for Dan to
> chime in.

So back in November I suggested modifying the kaddr, mainly to avoid
touching all the dax_direct_access() call sites [1]. However, now
seeing the code and Chrisoph's comment I think this either wants type
safety (e.g. 'dax_addr_t *'), or just add a new flag. Given both of
those options involve touching all dax_direct_access() call sites and
a @flags operation is more extensible if any other scenarios arrive
lets go ahead and plumb a flag and skip the magic.
