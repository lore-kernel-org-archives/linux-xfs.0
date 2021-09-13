Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C12C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 18:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2000A610D2
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 18:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbhIMS1z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 14:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347125AbhIMS1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 14:27:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 144C36108B;
        Mon, 13 Sep 2021 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631557584;
        bh=fyaePkL27KXkY/vVNwQ0WrVwKmALYDGk52hIGDl1atM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7OEbZdaURON7cz5bTzmNT9hzl+CBXzGkdLp0chyXn6ITX1XN9zbctQlvPqrOAmW7
         aE5Wid6CkS4XLXV37fwIxrcOnjtF+ptVhsnYqvnLdIq33CP3g8ljcVhxPM5ds7yW64
         5k+RDeCJRa+kU1MBIvYE3ZoOvysFYMFijWq2DBThFI10uqUsfetYLCRzS4cGNnmxmn
         QNFbX+Fnrf5V42Qnfqo30P1QJQYruoNj5cUZXga3NZGqM/fSXLN+sdMUPvR2EZs94p
         byPoB5NAyo/SGF0VG7kGX6l8EC6AcWy/7K48o0cIAcdHmC4nM0B20NRXBhrD0jEqt7
         53ZzInaVjrZNQ==
Date:   Mon, 13 Sep 2021 11:26:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: regresion test for fsmap problems with realtime
Message-ID: <20210913182623.GG638503@magnolia>
References: <163045512451.771394.12554760323831932499.stgit@magnolia>
 <163045514640.771394.1779112875987604476.stgit@magnolia>
 <YT3ZUiH7uANwHoRW@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YT3ZUiH7uANwHoRW@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 12, 2021 at 06:41:22PM +0800, Eryu Guan wrote:
> On Tue, Aug 31, 2021 at 05:12:26PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test for:
> > 
> > xfs: make xfs_rtalloc_query_range input parameters const
> > xfs: fix off-by-one error when the last rt extent is in use
> > xfs: make fsmap backend function key parameters const
> > 
> > In which we synthesize an XFS with a realtime volume and a special
> > realtime volume to trip the bugs fixed by all three patches that
> > resulted in incomplete fsmap output.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/922     |  183 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/922.out |    2 +
> >  2 files changed, 185 insertions(+)
> >  create mode 100755 tests/xfs/922
> >  create mode 100644 tests/xfs/922.out
> > 
> > 
> > diff --git a/tests/xfs/922 b/tests/xfs/922
> > new file mode 100755
> > index 00000000..95304d57
> > --- /dev/null
> > +++ b/tests/xfs/922
> > @@ -0,0 +1,183 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 922
> > +#
> > +# Regression test for commits:
> > +#
> > +# c02f6529864a ("xfs: make xfs_rtalloc_query_range input parameters const")
> > +# 9ab72f222774 ("xfs: fix off-by-one error when the last rt extent is in use")
> > +# 7e1826e05ba6 ("xfs: make fsmap backend function key parameters const")
> > +#
> > +# These commits fix a bug in fsmap where the data device fsmap function would
> > +# corrupt the high key passed to the rt fsmap function if the data device
> > +# number is smaller than the rt device number and the data device itself is
> > +# smaller than the rt device.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto fsmap
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	_scratch_unmount
> > +	test -n "$ddloop" && _destroy_loop_device "$ddloop"
> > +	test -n "$rtloop" && _destroy_loop_device "$rtloop"
> > +	test -n "$ddfile" && rm -f "$ddfile"
> > +	test -n "$rtfile" && rm -f "$rtfile"
> > +	test -n "$old_use_external" && USE_EXTERNAL="$old_use_external"
> > +}
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> 
> _supported_fs xfs
> 
> > +_require_test
> 
> Also need the following _require rules
> 
> _require_loop
> _require_xfs_io_command "falloc"
> _require_xfs_io_command "fpunch"
> _require_xfs_io_command "fsmap"
> 
> I've fixed them all on commit.

Thank you!

--D

> 
> Thanks,
> Eryu
