Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779B0C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4938964E6B
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 19:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbhBJTOP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 14:14:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234581AbhBJTOK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Feb 2021 14:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612984364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4OM9bRFVvC7O968pyl6Nevci5qP2kLB6/s2zBX59EY8=;
        b=YIKv3ALaHRM83hD/9EjevSFb62o7wyTgKXeMdrRieyTf2oqT/Zqd6qjLP5yeEz2tMNFqL+
        Vq+GHv4MsExE4x9B/yqhLmXZ+DYhqMnQPg4RHKhuOTLfJeVJXCxCmShsYzx1dBgS8suJ9g
        i8fK2bFckAPowFx38eqRXL/gOtpgDpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-_kYLWhQLN-S-lJuSenFgMQ-1; Wed, 10 Feb 2021 14:12:40 -0500
X-MC-Unique: _kYLWhQLN-S-lJuSenFgMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20FC480364B;
        Wed, 10 Feb 2021 19:12:39 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFEFD60936;
        Wed, 10 Feb 2021 19:12:38 +0000 (UTC)
Date:   Wed, 10 Feb 2021 14:12:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: test mapped write after shutdown and failed
 writeback
Message-ID: <20210210191236.GA90895@bfoster>
References: <20210210170628.173200-1-bfoster@redhat.com>
 <aeafb8f1-c383-686f-c349-99bf6fef39e8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeafb8f1-c383-686f-c349-99bf6fef39e8@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 10, 2021 at 12:56:28PM -0600, Eric Sandeen wrote:
> On 2/10/21 11:06 AM, Brian Foster wrote:
> > XFS has a regression where it failed to check shutdown status in the
> > write fault path. This produced an iomap warning if the page
> > happened to recently fail a writeback attempt because writeback
> > failure can clear Uptodate status on the page. Add a test for this
> > scenario to help ensure mapped write failures are handled as
> > expected in the event of filesystem shutdown.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> This looks reasonable to me, I have run the same xfs_io tests when
> looking at this behavior and they do provoke it.
> 
> This could maybe run on $TEST? But I don't really care much either
> way.
> 

I suppose that would be possible, but I'd prefer not to shut down the
test device intentionally. I don't _think_ we currently do that
anywhere. AFAICT, there's only a handful of open-coded shutdowns and
most others use _scratch_shutdown...

> I spot-checked this on ext4 and it passes.
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 

Thanks.

Brian

> 
> > ---
> > 
> > Note that this test currently fails on XFS. The fix is posted for review
> > on linux-xfs:
> > 
> > https://lore.kernel.org/linux-xfs/20210210170112.172734-1-bfoster@redhat.com/
> > 
> > Brian
> > 
> >  tests/generic/999     | 45 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/999.out |  4 ++++
> >  tests/generic/group   |  1 +
> >  3 files changed, 50 insertions(+)
> >  create mode 100755 tests/generic/999
> >  create mode 100644 tests/generic/999.out
> > 
> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..5e5408e7
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,45 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +# Copyright 2021 Red Hat, Inc.
> > +#
> > +# FS QA Test No. 999
> > +#
> > +# Test a write fault scenario on a shutdown fs.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	rm -f $tmp.*
> > +}
> > +
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +rm -f $seqres.full
> > +
> > +_supported_fs generic
> > +_require_scratch_nocheck
> > +_require_scratch_shutdown
> > +
> > +_scratch_mkfs &>> $seqres.full
> > +_scratch_mount
> > +
> > +# XFS had a regression where it failed to check shutdown status in the fault
> > +# path. This produced an iomap warning because writeback failure clears Uptodate
> > +# status on the page.
> > +file=$SCRATCH_MNT/file
> > +$XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
> > +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> > +	-c "mwrite 0 4k" $file | _filter_xfs_io
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > new file mode 100644
> > index 00000000..f55569ff
> > --- /dev/null
> > +++ b/tests/generic/999.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 999
> > +wrote 4096/4096 bytes at offset 0
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> > +fsync: Input/output error
> > diff --git a/tests/generic/group b/tests/generic/group
> > index b10fdea4..edd54ce5 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -625,3 +625,4 @@
> >  620 auto mount quick
> >  621 auto quick encrypt
> >  622 auto shutdown metadata atime
> > +999 auto quick shutdown
> > 
> 

