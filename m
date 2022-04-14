Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEACC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 19:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343690AbiDNTPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 15:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbiDNTPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 15:15:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61238E9C8B
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 12:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649963567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yDWNodgInUw5jo4HpGkM9EXi9TSHVWCl7kPrh8Git/Q=;
        b=QLi3B2PxL0HSf/ZipQE6Ap6vOI2LPE82UgMAzWTdz1lPcMJrguB/rSTiapGzlzG9W9TYsn
        /ukJUBMhsIf0BGtdLVYOWGqO4rkVcF3Lt09Eaotp1pYvgWdTpPHxyS2I9R579C0DMOSrBn
        nb4gZF5Fb+nXfj/qzh4BHA5CAy0CP2E=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-FNQXeiZCO12PrH_lTICp0w-1; Thu, 14 Apr 2022 15:12:46 -0400
X-MC-Unique: FNQXeiZCO12PrH_lTICp0w-1
Received: by mail-qt1-f197.google.com with SMTP id z3-20020ac86b83000000b002ed0f18c23cso3814440qts.17
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 12:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=yDWNodgInUw5jo4HpGkM9EXi9TSHVWCl7kPrh8Git/Q=;
        b=1I17AGVcmFqN2yp8qTeSxfNKXZf7J/SgOEQsBBfsK89zOleJgeScVqCLw4cTNagfu7
         HKz3X/K3OsqmQrb6K0VS7S9xpuZZsYBC6XTeV2Q7JY47RGPf1US1hF3Js/CRgq3vsr5A
         WaO9lDPU2AfOD+oeZBQPCB5OZn24VeFYFTI1mohj0c/k6Uuofq5xxpYvkHo0//Ii/m+y
         Q3Z+vsEzy6y/PCqlL+uktEtFQHQZdGsAE0SrjgFPU7+5MHGY1tEATtF0hikf8MnKynRJ
         35b9zJ5NxZvQfMl8vuOE/ByTdM6lHrJtthjc7hd43wRQ6GsGUwiKO3Xz/xim6/SRVZb+
         slBg==
X-Gm-Message-State: AOAM531M5kzVyoENhB/rkdo6lxK50TUlPBGisRnTvEMHA4vnuSPWRbR4
        vMobsQWuX4GFsygdcOLdpayYALWjadZoxMZQgCEGAI83ClXT2Cgrr/9Kxy5ObvTwBDojTwfejkW
        sHAhmaW4twice1VcSCmdt
X-Received: by 2002:ac8:5a46:0:b0:2e2:2edd:374 with SMTP id o6-20020ac85a46000000b002e22edd0374mr2958531qta.295.1649963565516;
        Thu, 14 Apr 2022 12:12:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRiF6C+jQN29BKj+5MqUsCxbFwZsqbL8tVt1Bf12n4XKTkkkHH6Hr7t5R3/wE7uhUR5uRpsQ==
X-Received: by 2002:ac8:5a46:0:b0:2e2:2edd:374 with SMTP id o6-20020ac85a46000000b002e22edd0374mr2958515qta.295.1649963565249;
        Thu, 14 Apr 2022 12:12:45 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c20-20020a05622a025400b002e1dd71e797sm1771854qtx.15.2022.04.14.12.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 12:12:44 -0700 (PDT)
Date:   Fri, 15 Apr 2022 03:12:39 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] generic: test that linking into a directory fails
 with EDQUOT
Message-ID: <20220414191239.jp56xecunxmed72k@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768834.169983.11537125892654404197.stgit@magnolia>
 <20220412171723.owphga4kmx3im7zv@zlang-mailbox>
 <20220412175256.GH16799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412175256.GH16799@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 10:52:56AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 13, 2022 at 01:17:23AM +0800, Zorro Lang wrote:
> > On Mon, Apr 11, 2022 at 03:54:48PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add a regression test to make sure that unprivileged userspace linking
> > > into a directory fails with EDQUOT when the directory quota limits have
> > > been exceeded.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/832     |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/832.out |    3 ++
> > >  2 files changed, 70 insertions(+)
> > >  create mode 100755 tests/generic/832
> > >  create mode 100644 tests/generic/832.out
> > > 
> > > 
> > > diff --git a/tests/generic/832 b/tests/generic/832
> > > new file mode 100755
> > > index 00000000..1190b795
> > > --- /dev/null
> > > +++ b/tests/generic/832
> > > @@ -0,0 +1,67 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 832
> > > +#
> > > +# Ensure that unprivileged userspace hits EDQUOT while linking files into a
> > > +# directory when the directory's quota limits have been exceeded.
> > > +#
> > > +# Regression test for commit:
> > > +#
> > > +# 871b9316e7a7 ("xfs: reserve quota for dir expansion when linking/unlinking files")
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick quota
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/quota
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +_require_quota
> > > +_require_user
> > > +_require_scratch
> > > +
> > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > +_qmount_option usrquota
> > > +_qmount
> > > +
> > > +blocksize=$(_get_block_size $SCRATCH_MNT)
> > > +scratchdir=$SCRATCH_MNT/dir
> > > +scratchfile=$SCRATCH_MNT/file
> > > +mkdir $scratchdir
> > > +touch $scratchfile
> > > +
> > > +# Create a 2-block directory for our 1-block quota limit
> > > +total_size=$((blocksize * 2))
> > > +dirents=$((total_size / 255))
> > > +
> > > +for ((i = 0; i < dirents; i++)); do
> > > +	name=$(printf "x%0254d" $i)
> > > +	ln $scratchfile $scratchdir/$name
> > > +done
> > > +
> > > +# Set a low quota hardlimit for an unprivileged uid and chown the files to it
> > > +echo "set up quota" >> $seqres.full
> > > +setquota -u $qa_user 0 "$((blocksize / 1024))" 0 0 $SCRATCH_MNT
> > > +chown $qa_user $scratchdir $scratchfile
> > > +repquota -upn $SCRATCH_MNT >> $seqres.full
> > > +
> > > +# Fail at appending the directory as qa_user to ensure quota enforcement works
> > > +echo "fail quota" >> $seqres.full
> > > +for ((i = 0; i < dirents; i++)); do
> > > +	name=$(printf "y%0254d" $i)
> > > +	su - "$qa_user" -c "ln $scratchfile $scratchdir/$name" 2>&1 | \
> > 
> > All looks good to me. Only one question about this "su -". Is the "-" necessary?
> > I checked all cases in fstests, no one use "--login" when try to su to $qa_user.
> > I'm not sure if "login $qa_user" will affect the testing, I just know it affect
> > environment variables.
> 
> It's not strictly necessary since it's unlikely that qa_user="-luser",
> but it seems like a Good Idea to prevent su cli option injection
> attacks.

Thanks for your understanding :) Eryu of me (after I get push permission) will help
to remove the little "-" when merge it.

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +		_filter_scratch | sed -e 's/y[0-9]*/yXXX/g'
> > > +	test "${PIPESTATUS[0]}" -ne 0 && break
> > > +done
> > > +repquota -upn $SCRATCH_MNT >> $seqres.full
> > > +
> > > +# success, all done
> > > +echo Silence is golden
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/832.out b/tests/generic/832.out
> > > new file mode 100644
> > > index 00000000..593afe8b
> > > --- /dev/null
> > > +++ b/tests/generic/832.out
> > > @@ -0,0 +1,3 @@
> > > +QA output created by 832
> > > +ln: failed to create hard link 'SCRATCH_MNT/dir/yXXX': Disk quota exceeded
> > > +Silence is golden
> > > 
> > 
> 

