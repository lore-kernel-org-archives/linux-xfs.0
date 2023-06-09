Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C107C7EE25
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 03:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbjFIDhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 23:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238146AbjFIDhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 23:37:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A4630EE
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 20:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686281784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6PHbXjldBnxpaBDp1b6uHJLMKUgeGdgfPjnTV5JD1g=;
        b=XOnxcWuIHwNxYwEYIHIFtZWQnDk2ZFBOrGDwNsl53Ng3PKn8f1vrMnpzK9ig8V2DIBlMOE
        JYIKQ91YVUV/SoxsQsrUsH4r2dvE3jkGaOyKnNlv74+l5dY2uLQwfe8/KhQPFpDetqELHG
        OutSzNQjQvyeyNe3nJ6++pwEPyz4myk=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-Pmlo5RdqPMCYhvM8fhOWFQ-1; Thu, 08 Jun 2023 23:36:23 -0400
X-MC-Unique: Pmlo5RdqPMCYhvM8fhOWFQ-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-55551dfd39fso836899eaf.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jun 2023 20:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686281783; x=1688873783;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b6PHbXjldBnxpaBDp1b6uHJLMKUgeGdgfPjnTV5JD1g=;
        b=Wh0lMc0t3szbpQ5enIt2DMykn81I2SFzP96mMOS/HRDYM0NM9LftV9mtfr54wOO2ZK
         mWtDPzFiod7SD3amiS/ZBLEGbxUBUgoe21KLYniMrLIYpOp96ZrnfEzUWb+HKGBpSXcF
         mI8WmbJRA7F/Jn4T9El/niqRTBo7uxV0qec1Re9d+l7DrujYxaLEHl/vHAb4fTCHPTiM
         3JZ9s5iII/mJN+Hnx3PiydfNCsNLTy3QRhjCBe0VBfZOAvZi1l+tpZgYbo1oGhQGr1Ag
         eS01s/1FRH4LE8rNRgnLCjU9VLStmd5JLTQ3YSmNgtiwECmNBz7ASkyznBjP35elfiaz
         pvYw==
X-Gm-Message-State: AC+VfDy25fzwFUCyIFP8O/coq731reW6KrjTEocvZkAvvJdYHGZjuKMy
        qhWpXd4IjJkeVG83iH/3QP1CuvlQBqdWoB1xqnUav0zV+9BrujbFM6vKZFzGhCJGVfnitkxR2jQ
        x0ru5cs9P++gVnRCFSbF8
X-Received: by 2002:a05:6808:2c6:b0:398:1045:17ed with SMTP id a6-20020a05680802c600b00398104517edmr244697oid.54.1686281782845;
        Thu, 08 Jun 2023 20:36:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5BYLMbQEGYVEBzy6Vueuu9nmnNgJaZscYFWA+ckNpNWgKRp99kcTS6YVOL3UxH4m6xIYrtUw==
X-Received: by 2002:a05:6808:2c6:b0:398:1045:17ed with SMTP id a6-20020a05680802c600b00398104517edmr244691oid.54.1686281782556;
        Thu, 08 Jun 2023 20:36:22 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a192-20020a6390c9000000b0051b4a163ccdsm1920861pge.11.2023.06.08.20.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 20:36:22 -0700 (PDT)
Date:   Fri, 9 Jun 2023 11:36:17 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>,
        Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v4] xfstests: add test for xfs_repair progress reporting
Message-ID: <20230609033617.oglgtpy2syx4rraq@zlang-mailbox>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
 <20230531064024.1737213-2-ddouwsma@redhat.com>
 <CADJHv_v-YUrpT3MA8+2HcWb3B03V87ZQ2b0_pKR+LcAE4-9WUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADJHv_v-YUrpT3MA8+2HcWb3B03V87ZQ2b0_pKR+LcAE4-9WUg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 09, 2023 at 09:50:26AM +0800, Murphy Zhou wrote:
> Adding fstests
> 
> On Wed, May 31, 2023 at 2:50 PM Donald Douwsma <ddouwsma@redhat.com> wrote:
> >
> > Confirm that xfs_repair reports on its progress if -o ag_stride is
> > enabled.
> >
> > Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> Ack.

Hi Donald,

That's weird, I never saw the original patch email, did I miss something?
Please send the original patch to fstests@ if you hope to get reviewing
and merging (if acked:)

Thanks,
Zorro

> 
> Thanks,
> > ---
> > Changes since v3
> > - Rebase after tests/xfs/groups removal (tools/convert-group), drop _supported_os
> > - Shorten the delay, remove superfluous dm-delay parameters
> > Changes since v2:
> > - Fix cleanup handling and function naming
> > - Added to auto group
> > Changes since v1:
> > - Use _scratch_xfs_repair
> > - Filter only repair output
> > - Make the filter more tolerant of whitespace and plurals
> > - Take golden output from 'xfs_repair: fix progress reporting'
> >
> >  tests/xfs/999     | 66 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out | 15 +++++++++++
> >  2 files changed, 81 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> >
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 00000000..9e799f66
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,66 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 521
> > +#
> > +# Test xfs_repair's progress reporting
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto repair
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +       cd /
> > +       rm -f $tmp.*
> > +       _cleanup_delay > /dev/null 2>&1
> > +}
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/dmdelay
> > +. ./common/populate
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_dm_target delay
> > +
> > +# Filter output specific to the formatters in xfs_repair/progress.c
> > +# Ideally we'd like to see hits on anything that matches
> > +# awk '/{FMT/' xfsprogs-dev/repair/progress.c
> > +filter_repair()
> > +{
> > +       sed -nre '
> > +       s/[0-9]+/#/g;
> > +       s/^\s+/ /g;
> > +       s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
> > +       /#:#:#:/p
> > +       '
> > +}
> > +
> > +echo "Format and populate"
> > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > +
> > +echo "Introduce a dmdelay"
> > +_init_delay
> > +DELAY_MS=38
> > +
> > +# Introduce a read I/O delay
> > +# The default in common/dmdelay is a bit too agressive
> > +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> > +DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $DELAY_MS"
> > +_load_delay_table $DELAY_READ
> > +
> > +echo "Run repair"
> > +SCRATCH_DEV=$DELAY_DEV _scratch_xfs_repair -o ag_stride=4 -t 1 2>&1 |
> > +        tee -a $seqres.full > $tmp.repair
> > +
> > +cat $tmp.repair | filter_repair | sort -u
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > new file mode 100644
> > index 00000000..e27534d8
> > --- /dev/null
> > +++ b/tests/xfs/999.out
> > @@ -0,0 +1,15 @@
> > +QA output created by 999
> > +Format and populate
> > +Introduce a dmdelay
> > +Run repair
> > + - #:#:#: Phase #: #% done - estimated remaining time {progres}
> > + - #:#:#: Phase #: elapsed time {progres} - processed # inodes per minute
> > + - #:#:#: check for inodes claiming duplicate blocks - # of # inodes done
> > + - #:#:#: process known inodes and inode discovery - # of # inodes done
> > + - #:#:#: process newly discovered inodes - # of # allocation groups done
> > + - #:#:#: rebuild AG headers and trees - # of # allocation groups done
> > + - #:#:#: scanning agi unlinked lists - # of # allocation groups done
> > + - #:#:#: scanning filesystem freespace - # of # allocation groups done
> > + - #:#:#: setting up duplicate extent list - # of # allocation groups done
> > + - #:#:#: verify and correct link counts - # of # allocation groups done
> > + - #:#:#: zeroing log - # of # blocks done
> > --
> > 2.39.3
> >
> 

