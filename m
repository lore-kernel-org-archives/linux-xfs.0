Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8246C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 17:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353135AbiDLRe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 13:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358160AbiDLRcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 13:32:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D554838D93
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 10:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649784579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pzQ3vKJD2mKLljBbGpPHheDPClTnkzH7l3aPjzIXIB0=;
        b=BzqEKT5iiNZq12Q2eeWQUkvVBH8AUKQBCjU8+RvAlelkHIl4lNhjqAjYQRrhJFzCiRVXsj
        ijQPxQzf7VeyJWnoy5vc6dGPUqaiVPxduEKziD37rGQWQbo9rJaC7uXBFodC6UdJQ32tS0
        kXDc01z+1vsA25qPfUQKyfsu3qg6Wvo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-418Z1cPrM36EVZokyve_OQ-1; Tue, 12 Apr 2022 13:29:38 -0400
X-MC-Unique: 418Z1cPrM36EVZokyve_OQ-1
Received: by mail-qv1-f69.google.com with SMTP id o15-20020a0562140e4f00b00443dee06cc4so18968420qvc.10
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 10:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=pzQ3vKJD2mKLljBbGpPHheDPClTnkzH7l3aPjzIXIB0=;
        b=OLqouAGSny/v8gCYNMBWbH2ebyUdycIcXO7PMKFAwsYGrDzHbThYjFLfr2s2TYn4JI
         Nn6xEce9vpu9acr+vewpCS9eN4ql+ZFmTJvkHYkdf+0HcsVvRSSwxZizfuYhbq1KQiTa
         ljgfoRL0mpDKLIJ5YEKi/GlgTJNNdTjMNS+2eJwJ9JN0vT5a3xtbGIABy94FcTAmB9p8
         xHorB7J6zVhiQGAO9g0yw/UEKExBgOKomEJ3IU8eXesf6vBqES/HDDxVxgwMAQ6FbegB
         NUf9xotnnduohp9JFNdzARPGM7WNwjvDadOjCz00gSiK3UDGDdz3JxOEDWIXz7owNMdH
         KIew==
X-Gm-Message-State: AOAM532DSg/ygfpBDMrd25oPFsAyma9uB5EAprIiNjD2+eJCjkrUlWXn
        zccC5WCjLrrswNNtDZa3DHdSNP2Nhoq3omb2P8TZuIPIa7qs+R+ae75osOdqys5++0naMq1QFi9
        nS8U19QJL0CQkq5Syi0FS
X-Received: by 2002:a37:af86:0:b0:69c:1fae:2d89 with SMTP id y128-20020a37af86000000b0069c1fae2d89mr4041304qke.506.1649784577563;
        Tue, 12 Apr 2022 10:29:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBj/ExPDhdmBkAQ9K448c3IBILjg+DYiz+5qgNSlkcNYQOlBb1QjV9lFgSjumsaXHAqs6grQ==
X-Received: by 2002:a37:af86:0:b0:69c:1fae:2d89 with SMTP id y128-20020a37af86000000b0069c1fae2d89mr4041290qke.506.1649784577305;
        Tue, 12 Apr 2022 10:29:37 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9-20020ac87c49000000b002f13658d1b3sm737879qtv.19.2022.04.12.10.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:29:36 -0700 (PDT)
Date:   Wed, 13 Apr 2022 01:29:30 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] generic: test that renaming into a directory fails
 with EDQUOT
Message-ID: <20220412172930.fv2uofjqxgeo5tft@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971769398.169983.1284630275364529313.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971769398.169983.1284630275364529313.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:54:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a regression test to make sure that unprivileged userspace renaming
> within a directory fails with EDQUOT when the directory quota limits have
> been exceeded.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/833     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/833.out |    3 ++
>  2 files changed, 74 insertions(+)
>  create mode 100755 tests/generic/833
>  create mode 100644 tests/generic/833.out
> 
> 
> diff --git a/tests/generic/833 b/tests/generic/833
> new file mode 100755
> index 00000000..a1b3cbc0
> --- /dev/null
> +++ b/tests/generic/833
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 833
> +#
> +# Ensure that unprivileged userspace hits EDQUOT while moving files into a
> +# directory when the directory's quota limits have been exceeded.
> +#
> +# Regression test for commit:
> +#
> +# 41667260bc84 ("xfs: reserve quota for target dir expansion when renaming files")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick quota
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/quota
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_quota
> +_require_user
> +_require_scratch
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_qmount_option usrquota
> +_qmount
> +
> +blocksize=$(_get_block_size $SCRATCH_MNT)
> +scratchdir=$SCRATCH_MNT/dir
> +scratchfile=$SCRATCH_MNT/file
> +stagedir=$SCRATCH_MNT/staging
> +mkdir $scratchdir $stagedir
> +touch $scratchfile
> +
> +# Create a 2-block directory for our 1-block quota limit
> +total_size=$((blocksize * 2))
> +dirents=$((total_size / 255))
> +
> +for ((i = 0; i < dirents; i++)); do
> +	name=$(printf "x%0254d" $i)
> +	ln $scratchfile $scratchdir/$name
> +done
> +
> +# Set a low quota hardlimit for an unprivileged uid and chown the files to it
> +echo "set up quota" >> $seqres.full
> +setquota -u $qa_user 0 "$((blocksize / 1024))" 0 0 $SCRATCH_MNT
> +chown $qa_user $scratchdir $scratchfile
> +repquota -upn $SCRATCH_MNT >> $seqres.full
> +
> +# Fail at renaming into the directory as qa_user to ensure quota enforcement
> +# works
> +chmod a+rwx $stagedir
> +echo "fail quota" >> $seqres.full
> +for ((i = 0; i < dirents; i++)); do
> +	name=$(printf "y%0254d" $i)
> +	ln $scratchfile $stagedir/$name
> +	su - "$qa_user" -c "mv $stagedir/$name $scratchdir/$name" 2>&1 | \

Same as [PATCH 3/4], do we need "--login"?
Oh, I just found there's only one case generic/128 use this option too. Anyway I
have no reason to object it, just speak out for review:)

Thanks,
Zorro

> +		_filter_scratch | sed -e 's/y[0-9]*/yXXX/g'
> +	test "${PIPESTATUS[0]}" -ne 0 && break
> +done
> +repquota -upn $SCRATCH_MNT >> $seqres.full
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/833.out b/tests/generic/833.out
> new file mode 100644
> index 00000000..d100fa07
> --- /dev/null
> +++ b/tests/generic/833.out
> @@ -0,0 +1,3 @@
> +QA output created by 833
> +mv: cannot move 'SCRATCH_MNT/staging/yXXX' to 'SCRATCH_MNT/dir/yXXX': Disk quota exceeded
> +Silence is golden
> 

