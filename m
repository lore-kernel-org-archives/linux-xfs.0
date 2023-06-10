Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B579C7EE29
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Jun 2023 06:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjFJGjt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 10 Jun 2023 02:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjFJGjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Jun 2023 02:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A683ABA
        for <linux-xfs@vger.kernel.org>; Fri,  9 Jun 2023 23:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686379143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=apIywfp+26USocsZ6gnBqT87GpWheB8HZxLELd0tRjo=;
        b=A7ebVYdaPRPvfgKuwBG+jqOGuxOsHE4bsZPcZrBEwOf4wcr++HWWQVs/Ny0qXrPr+3JXnx
        9I7eTRpoPM2mhMjc8Gk8GClIw+X7YuKXvDEG23UOQt0b7iMazdi01of07RIa7ra5mG/cxL
        JNJdpbjWkOWul76anr7m4361JrnkYos=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-LvGZiCKXNWKbwgIFtGBBIQ-1; Sat, 10 Jun 2023 02:39:01 -0400
X-MC-Unique: LvGZiCKXNWKbwgIFtGBBIQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-256a45c6389so942389a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 09 Jun 2023 23:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686379140; x=1688971140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apIywfp+26USocsZ6gnBqT87GpWheB8HZxLELd0tRjo=;
        b=VuUrYQkKnq0+/BTALrRELuraLhUCsOWIcx/V4WwzQUvBxLx02ctKNkg1tEAPg6EIRx
         2l1trQsUk0IH2jmxwl8m0ez8KKydwNRYPSen1lSpBCRcZwRmP+AHhJ+Qd9zb4PoLzDRY
         1hXOC9emTj7l68F3bxdNzelVx4d4sxwupYGRWPHinBq9T5Z5UNvcgUqD0cDh2GAD7l1w
         kP/Tk9Y+lohCvrB7cL/5PY4P+CRMk186s8W11Xqi14gbBP3fkWB5UkMd2Mag8aRPkfLj
         P1qyr4k4dWK6blBslOkP8vFlQKkTij9FPkKAOpMKxw784hzm0liEZZqgYVb8HjILu28P
         pPZA==
X-Gm-Message-State: AC+VfDz5vVa34rfIDQ8+Paz6LViZGbp8QePzWKFSG5iIQXWg9e5mygom
        m9ET4egTAf458xeYeghEXLMgP15rIZ9RZ1LHzqbL9JFOSW5XF8LgLXj4F3EakaLeA10AumwaJ8Q
        njP4p46pI+nD0PDkjTqAj
X-Received: by 2002:a17:90a:1a1a:b0:258:99d1:6b84 with SMTP id 26-20020a17090a1a1a00b0025899d16b84mr2755664pjk.41.1686379140646;
        Fri, 09 Jun 2023 23:39:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6CH0xXtKEdC/l7//SHpeBYTc/vro/j2MBjKTCNKm8tlO2YZ9WkPzReJkXdrmIdgMpuH0WGAA==
X-Received: by 2002:a17:90a:1a1a:b0:258:99d1:6b84 with SMTP id 26-20020a17090a1a1a00b0025899d16b84mr2755655pjk.41.1686379140258;
        Fri, 09 Jun 2023 23:39:00 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090a088f00b0023a9564763bsm5577582pjc.29.2023.06.09.23.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 23:38:59 -0700 (PDT)
Date:   Sat, 10 Jun 2023 14:38:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4] xfstests: add test for xfs_repair progress reporting
Message-ID: <20230610063855.gg6cd7bh5pzyobhe@zlang-mailbox>
References: <20230531064024.1737213-1-ddouwsma@redhat.com>
 <20230531064024.1737213-2-ddouwsma@redhat.com>
 <20230609145253.GY1325469@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609145253.GY1325469@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 09, 2023 at 07:52:53AM -0700, Darrick J. Wong wrote:
> Tests ought to be cc'd to fstests@vger.kernel.org.

Thanks, I got this patch now :)

> 
> On Wed, May 31, 2023 at 04:40:24PM +1000, Donald Douwsma wrote:
> > Confirm that xfs_repair reports on its progress if -o ag_stride is
> > enabled.
> > 
> > Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
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
> > +	cd /
> > +	rm -f $tmp.*
> > +	_cleanup_delay > /dev/null 2>&1
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

As a regression test case, we need to point out that it's:
  _fixed_by_git_commit xfsprogs a4d94d6c30ac "xfs_repair: fix progress reporting"

Then due to it might fail without the other patch [1] (which has been reviewed),
so we'd better to point out that:

  _wants_git_commit xfsprogs xxxxxxxxxxxx \
          "xfs_repair: always print an estimate when reporting progress"

[1]
https://lore.kernel.org/linux-xfs/ZIM%2FKegChkoeTJE8@redhat.com/T/#u


> > +_require_scratch
> > +_require_dm_target delay
> > +
> > +# Filter output specific to the formatters in xfs_repair/progress.c
> > +# Ideally we'd like to see hits on anything that matches
> > +# awk '/{FMT/' xfsprogs-dev/repair/progress.c
> > +filter_repair()
> > +{
> > +	sed -nre '
> > +	s/[0-9]+/#/g;
> > +	s/^\s+/ /g;
> > +	s/(# (week|day|hour|minute|second)s?(, )?)+/{progres}/g;
> > +	/#:#:#:/p
> > +	'
> > +}
> > +
> > +echo "Format and populate"
> > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > +
> > +echo "Introduce a dmdelay"
> > +_init_delay
> > +DELAY_MS=38
> 
> I wonder if this is where _init_delay should gain a delay_ms argument?
> 
> _init_delay() {
> 	local delay_ms="${1:-10000}"

Agree

> 
> 	...
> 	DELAY_TABLE_RDELAY="0 $BLK_DEV_SIZE delay $SCRATCH_DEV 0 $delay_ms $SCRATCH_DEV 0 0"
> }
> 
> 
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

If the `sort -u` is necessary, how about only print the lines we realy care,
filter out all other lines?

Thanks,
Zorro

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
> 
> Otherwise seems fine to me, assuming nothing goes nuts if rt devices or
> whatever happen to be configured. ;)
> 
> --D
> 
> > -- 
> > 2.39.3
> > 
> 

