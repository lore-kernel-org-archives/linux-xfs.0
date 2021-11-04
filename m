Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6D3C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 16:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251566113B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 16:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhKDQLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Nov 2021 12:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbhKDQLa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Nov 2021 12:11:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CCAC06127A
        for <linux-xfs@vger.kernel.org>; Thu,  4 Nov 2021 09:08:52 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g184so5822588pgc.6
        for <linux-xfs@vger.kernel.org>; Thu, 04 Nov 2021 09:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yJc11Y8854aO1pDJriycOvwdVvyzfDm/4ES7HzJB+FM=;
        b=IsnPdnBom5LpEFlGcLWkFA9sW7xGG8iOp50ZHuzEB4vQDUSiDguPpZOqfovPfwIarp
         GsKSCbR87dHhdnK+ldotdA9Dbfq2sjEmSbTuQ5UY0613Wk7auCSP74m1QFrpDaW2u/sC
         ZFnFhs5kkVCJMWE6/gQem/FTNxnco9Y30Wvy+SRy6QWFEsRBD/sH0B/4cVB8fQZMJYli
         o/FUeNd9Wa9xTTJyrJOB/sjYPFO8bf/ZCsaOqjq5HfAtKNnJS7+bF/FxfdfxnSgKyRlE
         a8T4w8vcLyfYZYARqfbaz7B2UovGGoPthbHEqZGn0Bv1y/rPFtfapIWXuUDyDAgaUXj3
         4F3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yJc11Y8854aO1pDJriycOvwdVvyzfDm/4ES7HzJB+FM=;
        b=ojoeo2D3Y1lEv1311NGPqbtHrHr2ghoH0w+4oyhMyO8TmialxlgX2UGS/2AW3Xp03D
         NMbJdqmFwbdxIK4kqUpygf6DcKBROKnbztLTg5oRgAta8GVIhqxlqTRfQJ7nyvF1BtiV
         9MkP9i0zq6z+9SEVdATnHRjKdTAsoK4VN5FuRR0V0ytTr3qtJTYM6A9KPM2hBsFKvor+
         YlY/CCF6HJpD5uUdnCNCP17CXRZjy+bAtL8JNw0v2Ze1o4At1wlXA3/y4EhjOSl0u59+
         eGxbHdwxRSNiXfVFrCh33xYqa7zOK73PX3wSTy7zQl/zTOcY7vvQNl+Rf9/yESFisttp
         s0NQ==
X-Gm-Message-State: AOAM531L7D0eLwwsdjkrtosUZPcVurPGLx/xnQDWQitXGIB9XAXN1s+9
        kS+/bYsm9oZakKdrjcdk/m9A0zljkDI40qczXeIOYQ==
X-Google-Smtp-Source: ABdhPJyuzAAG5CU7otzDHpwNiRjP4pLsoDhcZ+jrxhUJJnHdOCa7XkPGXqg6HNGSe8SXKVxET1je/GYiOS8VYyK+gAE=
X-Received: by 2002:a63:6302:: with SMTP id x2mr22207191pgb.5.1636042131973;
 Thu, 04 Nov 2021 09:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20211021001059.438843-1-jane.chu@oracle.com> <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com> <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com> <YXj2lwrxRxHdr4hb@infradead.org>
 <20211028002451.GB2237511@magnolia> <YYDYUCCiEPXhZEw0@infradead.org>
 <dfca8558-ad70-41d5-1131-63db66b70542@oracle.com> <CAPcyv4jLn4_SYxLtp_cUT=mm6Y3An22BA+sqex1S-CBnAm6qGA@mail.gmail.com>
 <YYObn+0juAFvH7Fk@infradead.org>
In-Reply-To: <YYObn+0juAFvH7Fk@infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 4 Nov 2021 09:08:41 -0700
Message-ID: <CAPcyv4jaCj=qDw-MHEcYjVGHYGvX8wbJ_d3kv5nnv7agHnMViQ@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA flag
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jane Chu <jane.chu@oracle.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
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

On Thu, Nov 4, 2021 at 1:36 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Nov 03, 2021 at 11:21:39PM -0700, Dan Williams wrote:
> > The concern I have with dax_clear_poison() is that it precludes atomic
> > error clearing.
>
> atomic as in clear poison and write the actual data?  Yes, that would
> be useful, but it is not how the Intel pmem support actually works, right?

Yes, atomic clear+write new data. The ability to atomic clear requires
either a CPU with the ability to overwrite cachelines without doing a
RMW cycle (MOVDIR64B), or it requires a device with a suitable
slow-path mailbox command like the one defined for CXL devices (see
section 8.2.9.5.4.3 Clear Poison in CXL 2.0).

I don't know why you think these devices don't perform wear-leveling
with spare blocks?

> > Also, as Boris and I discussed, poisoned pages should
> > be marked NP (not present) rather than UC (uncacheable) [1].
>
> This would not really have an affect on the series, right?  But yes,
> that seems like the right thing to do.

It would because the implementations would need to be careful to clear
poison in an entire page before any of it could be accessed. With an
enlightened write-path RWF flag or custom fault handler it could do
sub-page overwrites of poison. Not that I think the driver should
optimize for multiple failed cachelines in a page, but it does mean
dax_clear_poison() fails in more theoretical scenarios.

> > With
> > those 2 properties combined I think that wants a custom pmem fault
> > handler that knows how to carefully write to pmem pages with poison
> > present, rather than an additional explicit dax-operation. That also
> > meets Christoph's requirement of "works with the intended direct
> > memory map use case".
>
> So we have 3 kinds of accesses to DAX memory:
>
>  (1) user space mmap direct access.
>  (2) iov_iter based access (could be from kernel or userspace)
>  (3) open coded kernel access using ->direct_access
>
> One thing I noticed:  (2) could also work with kernel memory or pages,
> but that doesn't use MC safe access.

Yes, but after the fight to even get copy_mc_to_kernel() to exist for
pmem_copy_to_iter() I did not have the nerve to push for wider usage.

> Which seems like a major independent
> of this discussion.
>
> I suspect all kernel access could work fine with a copy_mc_to_kernel
> helper as long as everyone actually uses it,

All kernel accesses do use it. They either route to
pmem_copy_to_iter(), or like dm-writecache, call it directly. Do you
see a kernel path that does not use that helper?

> missing required bits of (2) and (3) together with something like the
> ->clear_poison series from Jane. We just need to think hard what we
> want to do for userspace mmap access.

dax_clear_poison() is at least ready to go today and does not preclude
adding the atomic and finer grained support later.
