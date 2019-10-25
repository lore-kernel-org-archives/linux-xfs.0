Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447F8CA9EBC
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B5D12054F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 16:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ps7SzcvE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393746AbfJYQBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:01:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2393710AbfJYQBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 12:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572019308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EP5qblkusiEcXZpdykXqW8unTQm8baBVazRuy5+5weM=;
        b=Ps7SzcvERXvv1YySdnNnL0lr8qlqD+RA1GzIaWqF5729zj0+n0gCBdDSPSQANbn4tzJHlp
        YXKtxc5oTCAjWU0Bwi959h7uCI4KSW3OAzS/DNKoy0/aa4dyElD3ACmgfEm6EIejNXup4W
        iJTKUgwaNGKjh+UStJriJd5mJxkQ5bs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-61qUxOUePcS9wxneZE-vjg-1; Fri, 25 Oct 2019 12:01:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6066047B;
        Fri, 25 Oct 2019 16:01:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF3C419C7F;
        Fri, 25 Oct 2019 16:01:43 +0000 (UTC)
Date:   Fri, 25 Oct 2019 12:01:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH 4/4] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20191025160141.GG11837@bfoster>
References: <cover.1571926790.git.kaixuxia@tencent.com>
 <7d7257620da4bacbeda3d7c9bf84e2be3fbc597a.1571926791.git.kaixuxia@tencent.com>
MIME-Version: 1.0
In-Reply-To: <7d7257620da4bacbeda3d7c9bf84e2be3fbc597a.1571926791.git.kaixuxia@tencent.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 61qUxOUePcS9wxneZE-vjg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 10:20:51PM +0800, kaixuxia wrote:
> There is ABBA deadlock bug between the AGI and AGF when performing
> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> sure the rename() call works well.
>=20
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/generic/579     | 56 +++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/generic/579.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 59 insertions(+)
>  create mode 100755 tests/generic/579
>  create mode 100644 tests/generic/579.out
>=20
> diff --git a/tests/generic/579 b/tests/generic/579
> new file mode 100755
> index 0000000..95727f3
> --- /dev/null
> +++ b/tests/generic/579
> @@ -0,0 +1,56 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> +#
> +# FS QA Test No. 579
> +#
> +# Regression test for:
> +#    bc56ad8c74b8: ("xfs: Fix deadlock between AGI and AGF with RENAME_W=
HITEOUT")
> +#
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1        # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +        cd /
> +        rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/renameat2
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +_require_scratch
> +_require_renameat2 whiteout
> +
> +_scratch_mkfs > $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount >> $seqres.full 2>&1
> +
> +# start a create and rename(rename_whiteout) workload. These processes
> +# occur simultaneously may cause the deadlock between AGI and AGF with
> +# RENAME_WHITEOUT.
> +$FSSTRESS_PROG -z -n 150 -p 100 \
> +=09=09-f mknod=3D5 \
> +=09=09-f rwhiteout=3D5 \
> +=09=09-d $SCRATCH_MNT/fsstress >> $seqres.full 2>&1
> +
> +echo Silence is golden
> +
> +# Failure comes in the form of a deadlock.
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/generic/579.out b/tests/generic/579.out
> new file mode 100644
> index 0000000..06f4633
> --- /dev/null
> +++ b/tests/generic/579.out
> @@ -0,0 +1,2 @@
> +QA output created by 579
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 6f9c4e1..21870d2 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -581,3 +581,4 @@
>  576 auto quick verity encrypt
>  577 auto quick verity
>  578 auto quick rw clone
> +579 auto rename
> --=20
> 1.8.3.1
>=20

