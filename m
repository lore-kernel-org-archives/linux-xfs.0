Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85EFC10F1B
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 07:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiLUHJf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 02:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUHJe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 02:09:34 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6568014031;
        Tue, 20 Dec 2022 23:09:33 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id i188so7958259vsi.8;
        Tue, 20 Dec 2022 23:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MCEvZma3OnQaIelclFm2HbvVeCz2Orbe0R01dadB9Nw=;
        b=k9LJOIRhdzrc2IVyMM8Ual3gH9tqKKp9GH6rhbJPLWmcUs2CdkH7rdxzSODiScI3Rk
         73UaLIiVCOUUEhGfgnfYv+WImsAOXQUweIC8Obt8FMkyNGEmlix5zJm0I5GrlzN6mxz1
         j3VtF2e3Ytl6h+R7VLswt0+dpWfbZN8CHyGrYXiMdiaNxzvv1GZneLe6TTekrGH8j01v
         xDESBdHkJ+VYuXwlI5NIzqRkPTRIQlegJ5z7DrWG8hRqiIeWLpMbxy8FFoAUtTxJflKe
         WUaVZ/IMOW+vlYzKdQHWr8We56YbblKhOGkNRa3dKMnm7zQUoxHPQvAao+gd+6FDhn0M
         DesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MCEvZma3OnQaIelclFm2HbvVeCz2Orbe0R01dadB9Nw=;
        b=ectNI3JWdFkfdP742/s4EG4zlHcP13Pu8wEKrB6uLjJDakf8D0/9iGARBvWvJve545
         XYdVjR3/hNDLFc80xhuZ6Bbolo+67ktjY2+XkavzHuT9mjRGmeIIO/kaPsMnkOaPoZNr
         ynUsSC8kiiY24CInUD1ct95238aPZGmUi5hhMMcZWLlCA3yX8SdRxTDiYNg0Z0g1Vf1/
         ByL27rzAk6rDrutfYUOglbSLPshAkv082fGyZ0WQdgshay1hoOorhKiYcQOhcw27hKKH
         1IwCrHX72a5bzyOU1fVYF749iwWVmeGEK0OGAGVScV39/wnZGrYi10IFzZ6txGP4dV0B
         3hpQ==
X-Gm-Message-State: AFqh2kq+Lhs4lK+YzpeuOSQS3k4+Or/50LdLs/tlSQg3XhdkYY+HOPg9
        dm/jzXcZ4UXQAltTn7hH5Ttb/K+VSQsr0S6VmUVpowctp14=
X-Google-Smtp-Source: AMrXdXsQNgxPsJ8Nz8ibTJvKK0zvHhtIXd4r1NBDykw6I03sF1m86tPqwGhiV2mH7C7JmIOU2MPBTscp0ldxELPoN8A=
X-Received: by 2002:a67:f942:0:b0:3b1:48c:8218 with SMTP id
 u2-20020a67f942000000b003b1048c8218mr88833vsq.71.1671606572490; Tue, 20 Dec
 2022 23:09:32 -0800 (PST)
MIME-Version: 1.0
References: <167158210534.235429.10062024114428012379.stgit@magnolia> <167158211644.235429.5374511574924758421.stgit@magnolia>
In-Reply-To: <167158211644.235429.5374511574924758421.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 21 Dec 2022 09:09:19 +0200
Message-ID: <CAOQ4uxgB1xXTcLTbU=0px_R0Ewc6nJpNiikcx+j8TA5PYHoVEg@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfs: regression test for writes racing with reclaim writeback
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 21, 2022 at 2:38 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> This test uses the new write delay debug knobs to set up a slow-moving
> write racing with writeback of an unwritten block at the end of the
> file range targetted by the slow write.  The test succeeds if the file
> does not end up corrupt and if the ftrace log captures a message about
> the revalidation occurring.
>
> NOTE: I'm not convinced that madvise actually causes the page to be
> removed from the pagecache, which means that this is effectively a
> functional test for the invalidation, not a corruption reproducer.
> On the other hand, the functional test can be done quickly.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/925     |  123 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/925.out |    2 +
>  2 files changed, 125 insertions(+)
>  create mode 100755 tests/xfs/925
>  create mode 100644 tests/xfs/925.out
>
>
> diff --git a/tests/xfs/925 b/tests/xfs/925
> new file mode 100755
> index 0000000000..29490370bb
> --- /dev/null
> +++ b/tests/xfs/925
> @@ -0,0 +1,123 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 925
> +#
> +# This is a regression test for a data corruption bug that existed in iomap's
> +# buffered write routines.
> +#

Please mention the kernel fix commit when writing a new test for
a bug fix.
Otherwise, it is hard for LTS xfs maintainers to figure out how to
test the backported fix.
For example, if LTS maintainers run this test on LTS kernel it won't
run because of the missing debug knob, so we need to make an
effort to make sure that there is test coverage if we decide to backport
the data corruption fix series.

My preference is using the _fixed_by_kernel_commit macro, because
it is always better to standardize information needed by tools.
If the printed $seqres.hints are a nuisance to some developers, I can easily
turn off printing of $seqres.hints by default and make that print opt-in, but
the collection of $seqres.hints files can only help analyse test failures on
LTS kernels.

Thanks,
Amir.
