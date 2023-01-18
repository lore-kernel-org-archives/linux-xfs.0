Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC7CC46467
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 14:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjAROgO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 09:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjAROfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 09:35:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0155414EBE
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 06:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674051855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lfKGMY01UOVNs2XEWd6MIP0FrCTHviiP1TvDlkdcWhM=;
        b=ie9eR34Fd8DDLArR7RB+IDs+qVdrgTIO1S6u4Nyb55MMX2JeK2zrxETNYe87QM9idlEh33
        NlzvsJpHpJ/EQdWDr6V+YERzmE2NgV5vZrDGkmmfzYI0xOi1yU/2ewIO1/nLcQT7DJqNpF
        TAo7DiRM/VfSB9AVYDwh6OtZaUzScgk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-NAXfrWYwP6yYe0rD3Y-Itw-1; Wed, 18 Jan 2023 09:24:14 -0500
X-MC-Unique: NAXfrWYwP6yYe0rD3Y-Itw-1
Received: by mail-ej1-f69.google.com with SMTP id jg2-20020a170907970200b0086ee94381fbso7105951ejc.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 06:24:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfKGMY01UOVNs2XEWd6MIP0FrCTHviiP1TvDlkdcWhM=;
        b=Ynvl7CDZ+MjVQO/zDi8a6Xp4yyp2sOoYJcHEn/AMWB/nn/0oeHlw3/vigkhw6WFnl8
         D8Otwh0Lq7ZB3Nl77X7Cy61kWUNhBYpckNrBQxkVhSnt+wVL1K4oKAySd572HTDBcJt+
         0MzMpfXHF1+MejoU87ZYWWh1W8BaQZ5ZPaQrVuf+5TGD+WCC+MLelo3o0JV/oDQs7WT0
         qmH7AZWD8k1njNuRn6Ga3fKl4UaF8sBiemjx049C9eyfy+SXHnCsAHQ2yJkazZYHubVD
         ny/B66n8XCcSD8gUXzZPziO9t4azs+8VQlPUVV1Uv1UNvOlHgsMqMiQkHut4F6eK7dmc
         O6sw==
X-Gm-Message-State: AFqh2krensT3vCV9StrT3AbVp2vK92MFCO3mh+6TEE6Z3cVxOG4WBfI5
        TBLnuvB60PKH0iOe8cWa4T4+NQV+AY5SpQ0h2Nh4IIcyrp8Omuq0pmMkrGT464+Ty/EgZApnbJV
        QEyu1kNB0FoSX+7wuZ9k=
X-Received: by 2002:a50:ff08:0:b0:49b:7416:e3ff with SMTP id a8-20020a50ff08000000b0049b7416e3ffmr7155397edu.5.1674051852798;
        Wed, 18 Jan 2023 06:24:12 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsPC+0p5G7HHxc1ucF1IJLYzkmc+VFQvWdfQlaWShUE3jzkGnkgF8A1r+9zFabWuNF8MstP6A==
X-Received: by 2002:a50:ff08:0:b0:49b:7416:e3ff with SMTP id a8-20020a50ff08000000b0049b7416e3ffmr7155381edu.5.1674051852544;
        Wed, 18 Jan 2023 06:24:12 -0800 (PST)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020aa7c0c4000000b004847513929csm14249854edp.72.2023.01.18.06.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:24:12 -0800 (PST)
Date:   Wed, 18 Jan 2023 15:24:10 +0100
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/4] fstests: filesystem population fixes
Message-ID: <20230118142410.qxo3j64d7ebhw76j@aalbersh.remote.csb>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400103044.1915094.5935980986164675922.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:42:02PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> [original patchset cover letter from Dave]
> 
> common/populate operations are slow. They are not coded for
> performance, and do things in very slow ways. Mainly doing loops to
> create/remove files and forcing a task to be created and destroy for
> every individual operation. We can only fork a few thousand
> processes a second, whilst we can create or remove tens of thousands
> of files a second. Hence population speed is limited by fork/exit
> overhead, not filesystem speed. I also changed it to run all the
> creation steps in parallel, which means they run as fast as the
> filesystem can handle them rather than as fast as a single CPU can
> handle them.
> 
> patch 1 and patch 3 address these issues for common/populate and
> xfs/294.  I may update a bunch of other tests that use loop { touch
> file } to create thousands of files to speed them up as well.
> 
> The other patch in this series (patch 2) fixes the problem with
> populating an Xfs btree format directory, which currently fails
> because the removal step that creates sparse directory data also
> causes the dabtree index to get smaller and free blocks, taking the
> inode from btree to extent format and hence failing the populate
> checks.
> 
> More details are in the commit messages for change.
> 
> [further changes from Darrick]
> 
> This series moves the FMT_BTREE creation bugfix to be first in line,
> since it's a bug fix.  Next, I convert the directory and xattr creation
> loops into separate programs to reduce the execve overhead.  This alone
> is sufficient for a 10x reduction in runtime without substantially
> altering what gets written to disk and comes out in the xfs fsck fuzz
> tests.
> 
> The last patch in this series starts parallelizing things, but I've left
> most of that out since the parallelization patches make it harder to
> reliably generate a filesystem image where we can fuzz a two-level inobt
> and still mount the fs to run online fsck.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-populate-slowness
> ---
>  common/populate |   89 ++++++++++++++++++++++++++++++-------------------------
>  src/popattr.py  |   62 ++++++++++++++++++++++++++++++++++++++
>  src/popdir.pl   |   72 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 182 insertions(+), 41 deletions(-)
>  create mode 100755 src/popattr.py
>  create mode 100755 src/popdir.pl
> 

The patchset looks good to me:

Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

