Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031C1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 08:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D64A261090
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Oct 2021 08:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbhJ0I0M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhJ0I0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Oct 2021 04:26:12 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54161C061745
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 01:23:47 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s1so7359549edd.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Oct 2021 01:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VwO8BKe4L8WW+PxIi8rcMOq5fP2jPxN3gl9+0kE9I7A=;
        b=GqloTNuYndxvN66FCzgQqGL07Y5BGKQcG712/7wxGnqRDU+LuCE8FvtmZFsnxjLGHf
         wMZMX0c0kNQJNHm8rnVPvDH8iL5/Uwy2pkqMM89GsnUSklhZ4GT8z3kUq31mNlLnDJ0P
         vA3nbM7RhxZEilIWOfHeyTmtS9DsqPExLhd2rEVRgQO/cVKPYsbvJfpJGLW2fQDiMHic
         D4bCSLfK/fgUI7poIpsnKHTmZVAQblOMq6Y33tJQdFR6X8YocGVg/1VtUsRd/shfeS4d
         2Z4cYmwQ1AxcmDss44J0wvr7LPetP4LUKTblA5cOH/0l35+mVD7lNZQfI5WIL18LkRMm
         NVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=VwO8BKe4L8WW+PxIi8rcMOq5fP2jPxN3gl9+0kE9I7A=;
        b=DllLtlEF//5VmP/dC41f2KJzo4WqD7H/yL/0qDkoSOnLAAOpoL8MBtthN8KSt5nKZ5
         Dk8VWh+cE+y8ZmY8ukkaTN850TWKRvS+iRJkumgxZqrtBZEMPJFYdazxx2zuDPo7s+Et
         B3fUxCw0W2toc1BP3jeSvi7uk40a28Fo+lfcoOSjtkiztOrB6kryCDnbj7kkZTp/+Ffu
         6UC/TzywvpDcAvlTX5hQR+JQu010KpC/Zp8B4VIPxyUYjXaS17tx21HRgjcUrYX9oc7j
         +5ryxpo4sn/K5w6FnBhaiWIiJETty7RHRE4L8bJIzno58bbnJBNzIeaD3thK4ecFmyJ5
         MZZQ==
X-Gm-Message-State: AOAM531s5Y7BLeSqiCqYEGyCf3ewvetM0lYpr/s2kZMbiJiAxowqcCWF
        FYa4QFFmDqswmFGHMbHjU7+LSJ11TKI=
X-Google-Smtp-Source: ABdhPJzFgAl1316zBzT+YCqfnSZThOOW1TNSce4n45Poro2LVq3Z5jWPPMhvnl9Pn7nnnk/TAgfK0A==
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr42923275edb.262.1635323025948;
        Wed, 27 Oct 2021 01:23:45 -0700 (PDT)
Received: from smtpclient.apple (97.245.6.51.dyn.plus.net. [51.6.245.97])
        by smtp.gmail.com with ESMTPSA id i6sm10145893ejd.57.2021.10.27.01.23.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Oct 2021 01:23:45 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: XFS NVMe RDMA?
From:   Dan Greenfield <dgrnfld@gmail.com>
In-Reply-To: <YXBFaOqjMRN7ucFb@infradead.org>
Date:   Wed, 27 Oct 2021 09:23:42 +0100
Cc:     linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3CBB4EC9-5953-4276-8219-DA8B10ABB05F@gmail.com>
References: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
 <YXBE5y2cJtAaMfzs@infradead.org> <YXBFaOqjMRN7ucFb@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you again Christoph for your earlier answer.

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

