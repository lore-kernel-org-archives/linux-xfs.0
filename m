Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C379EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 09:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACCAA6108E
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Oct 2021 09:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJUKBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Oct 2021 06:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhJUKBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Oct 2021 06:01:17 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61234C06161C
        for <linux-xfs@vger.kernel.org>; Thu, 21 Oct 2021 02:59:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id w19so453810edd.2
        for <linux-xfs@vger.kernel.org>; Thu, 21 Oct 2021 02:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zAc7MCPcjnOMWcTH92N2btuPtEwrdGnFxMKQTFJ+EvE=;
        b=kgS+bEz3jFeDPu06+J8cTEkzaVCHCL8wkvIJaGz51ctD1R8nn6HB8hl7tvzInblRrw
         sgQ4v42fpvzMEpGBkTnouXzBsJM1AvgQEbgSk1mBsio8CT7ndo7O1bpB5+ht+6fN/F9r
         S5yKZz01/57ROvzP57YS6BSKuc/2PCjlKfO2qweQTy5FrU07tzsp4aB7hz2q9Ng+VtZc
         YBrCSdjJsLEQWyUw1BCyOZSRxNSltnSUPwRG/5rrYljyeAIuA39uXFJRnHsQCA+1SKoL
         5ziiBm+yeXn6kSguRoPGUmnPPQUb6TvERkdM9cjKH/NGS1HJmRnkmMdDIJyQC680KfSA
         VyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=zAc7MCPcjnOMWcTH92N2btuPtEwrdGnFxMKQTFJ+EvE=;
        b=pEOT57hkA8ICwi31gN8pbR4ZPBkZLXp+GUl84LEf3SdrVNvIlU42V8JyB2U3+b1zB/
         oyGLJ7ETZ+HqwPgJEYW4z9PLN70kRmXizfpT2CIJBB0x1TuB+jVrkdci6OvaEcnBhPE+
         ASUXqiU3DFcU0SRzQ6Gy0pN1B/FLSAG2yvBU6Oqjsq38Z/VrJ4clQJsCxFWq+6/98vHB
         d/JN+kL0g8MxBzCXxTil/ul5mqJopiYR+69PKOTn1/vFCTd5doZq+1WrX9K06w0NcjKb
         oLuT1BqMeZwxtNLjN5Xk/5rUixeNVTaarF/z8mDlEEBs3hsK0U+ZpKE8oVUlNLCCrsNQ
         IgaQ==
X-Gm-Message-State: AOAM5339ANQVdnyn/QXDkjUViOF4/uKoP7qz9as6gDQ95mCU65xmvb38
        vRAwKoTRvPrLiiLOClrK6q4ynsXp1rs=
X-Google-Smtp-Source: ABdhPJw0FA74bFQM33LKbL/wVF2zJBlRndJ8S4FnEWGd//YNvi5o2ebYn65TjkSVU1gluLxrIGRQ+Q==
X-Received: by 2002:a50:d8ce:: with SMTP id y14mr6245479edj.92.1634810339950;
        Thu, 21 Oct 2021 02:58:59 -0700 (PDT)
Received: from smtpclient.apple (105.245.6.51.dyn.plus.net. [51.6.245.105])
        by smtp.gmail.com with ESMTPSA id j22sm2265680ejt.11.2021.10.21.02.58.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Oct 2021 02:58:59 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: XFS NVMe RDMA?
From:   Dan Greenfield <dgrnfld@gmail.com>
In-Reply-To: <YXBFaOqjMRN7ucFb@infradead.org>
Date:   Thu, 21 Oct 2021 10:58:58 +0100
Cc:     linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <73FCEB1B-794C-4426-BCF7-0AEA0709FC65@gmail.com>
References: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
 <YXBE5y2cJtAaMfzs@infradead.org> <YXBFaOqjMRN7ucFb@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you Christoph! That=E2=80=99s very cool and makes sense.

Quick Question: would I be correct in assuming that if I mmap()ed each =
8-64MB (chunk) file from XFS, and then did RDMA from the mmap region, =
that it would first be copied from NVMe into DRAM (does this bypass =
CPU?) and *then* be copied across RDMA, rather than directly be copied =
from NVMe by RDMA? Or does O_DIRECT properly allow bypass straight to =
NVMe for RDMA?

For what this #1 entry are doing though, each of the 512 nodes have =
their own separate XFS FS as well as their own separate RocksDB, both =
backed by NVMe. They are doing filesystem ops almost entirely in =
user-mode (no kernel, no FUSE) by intercepting application binaries and =
rewriting syscall instructions into jumps into their user-mode library =
code and doing message passing to RDMA transfers to/from application =
memory from/to remote node=E2=80=99s NVMe. I don=E2=80=99t believe =
they=E2=80=99ve modified XFS, nor using pNFS. I don=E2=80=99t know if =
there=E2=80=99s any other mechanism though other than mmap() and then =
RDMA on that region?

- Dan

> On 20 Oct 2021, at 17:35, Christoph Hellwig <hch@infradead.org> wrote:
>=20
> On Wed, Oct 20, 2021 at 09:33:43AM -0700, Christoph Hellwig wrote:
>> On Wed, Oct 20, 2021 at 12:51:05PM +0100, Dan Greenfield wrote:
>>> Do you have any ideas how they could have been able to utilise RDMA =
so that node A can directly access data chunks stored on XFS on node B? =
Is the only approach to mmap the chunk on node B and then RDMA it =
to/from node A?
>>=20
>> I'm not going to watch a video, but with the pNFS code other nodes =
can
>> access data on an XFS node directly using any SCSI transport.
>> For RMDA that would be SRP or iSCSI/iSER.
>>=20
>> Note that I also have an unfinished draft to support NVMe, which has
>> an RDMA transports as well and someone else could trivially =
reimplement
>> that as well.
>=20
> Oh, and just FYI here are my slides on the pNFS support:
>=20
> =
https://events.static.linuxfound.org/sites/events/files/slides/pnfs.pdf

