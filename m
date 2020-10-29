Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3970C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32FC12076A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:40:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CAaEgyNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgJ2Rkb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgJ2Rkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 13:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603993230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uHmhmkw2EkiMd2xFWUeXs7qFzWJ7GiwP0EHcPBUwCGc=;
        b=CAaEgyNa5FUQeguvXCVRiSCECmNZ6dkvC/AjfLj9kWH7SHOYE4T6umYxGfDnChSSRD2Yyz
        u15wa4EHhErltDgC4+xQXj0zQAqtX9rv6Kf1ARqoqImMD8puFRc8q2akmXKrukUFFuv10x
        B9WDYuule5oMUlmnbSdgFj2I+WsYeg8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-PpBcwhv6NPyJC9uMTCwaRg-1; Thu, 29 Oct 2020 13:40:26 -0400
X-MC-Unique: PpBcwhv6NPyJC9uMTCwaRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F343803651;
        Thu, 29 Oct 2020 17:40:25 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE5375DA2A;
        Thu, 29 Oct 2020 17:40:24 +0000 (UTC)
Date:   Thu, 29 Oct 2020 13:40:23 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test inobtcount upgrade
Message-ID: <20201029174023.GC1660404@bfoster>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
 <160382542877.1203756.11339393830951325848.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382542877.1203756.11339393830951325848.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:03:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we can actually upgrade filesystems to support inobtcounts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs        |   16 ++++++++++++
>  tests/xfs/910     |   72 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/910.out |    3 ++
>  tests/xfs/group   |    1 +
>  4 files changed, 92 insertions(+)
>  create mode 100755 tests/xfs/910
>  create mode 100644 tests/xfs/910.out
> 
> 
...
> diff --git a/tests/xfs/910 b/tests/xfs/910
> new file mode 100755
> index 00000000..1924d9ea
> --- /dev/null
> +++ b/tests/xfs/910
> @@ -0,0 +1,72 @@
...
> +
> +# Now upgrade to inobtcount support
> +_scratch_xfs_admin -O inobtcount >> $seqres.full
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +cat $SCRATCH_MNT/urk
> +

I think we probably want some more explicit form of validation here.
Perhaps dump the inobt block counters from the above xfs_db command to
the golden output..? As it is, we can comment out the xfs_admin command
and the test still passes.

> +# success, all done
> +echo Silence is golden.

We can also probably drop this if we have some other form of output from
the test.

Brian

> +status=0
> +exit
> diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> new file mode 100644
> index 00000000..83992f49
> --- /dev/null
> +++ b/tests/xfs/910.out
> @@ -0,0 +1,3 @@
> +QA output created by 910
> +moo
> +Silence is golden.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 4b0caea4..862df3be 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -524,6 +524,7 @@
>  760 auto quick rw collapse punch insert zero prealloc
>  761 auto quick realtime
>  763 auto quick rw realtime
> +910 auto quick inobtcount
>  915 auto quick quota
>  917 auto quick db
>  918 auto quick db
> 

