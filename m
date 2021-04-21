Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8539C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 17:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4C00613B6
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 17:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbhDUR1W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31342 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240604AbhDUR1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 13:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619026007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=beMzMFBBs1f7PeVaOSRJYYzwQJTiLrMowOY0hzvamUs=;
        b=E3NS/KeZYyiOvjzYFRcad0ozBoIAtUojtDZITViPRbnvqSFqUWugNdsWDV/cNSnc/dyk7d
        bVeeY+KRrKmTqNaZ7yifHhZekFL+BKh9wh2N60iLSO164ZmM765JKlkB6MZb/4l4X3jg+M
        +/HQXmddswEFuSEQt4zqcYeRX/F+MUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-9oCsqw6LMcK-1ipf2JEoZw-1; Wed, 21 Apr 2021 13:26:45 -0400
X-MC-Unique: 9oCsqw6LMcK-1ipf2JEoZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7AF28026AC;
        Wed, 21 Apr 2021 17:26:44 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B79F5C1B4;
        Wed, 21 Apr 2021 17:26:44 +0000 (UTC)
Date:   Wed, 21 Apr 2021 13:26:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] generic/223: make sure all files get created on the
 data device
Message-ID: <YIBgUgAnkiw4unv1@bfoster>
References: <161896453944.776190.2831340458112794975.stgit@magnolia>
 <161896454559.776190.1857804198421552259.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161896454559.776190.1857804198421552259.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 05:22:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test formats filesystems with various stripe alignments, then
> checks that data file allocations are actually aligned to those stripe
> geometries.  If this test is run on an XFS filesystem with a realtime
> volume and RTINHERIT is set on the root dir, the test will fail because
> all new files will be created as realtime files, and realtime
> allocations are not subject to data device stripe alignments.  Fix this
> by clearing rtinherit on the root dir.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/generic/223 |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/tests/generic/223 b/tests/generic/223
> index 1f85efe5..f6393293 100755
> --- a/tests/generic/223
> +++ b/tests/generic/223
> @@ -43,6 +43,11 @@ for SUNIT_K in 8 16 32 64 128; do
>  	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seqres.full 2>&1
>  	_scratch_mount
>  
> +	# This test checks for stripe alignments of space allocations on the
> +	# filesystem.  Make sure all files get created on the main device,
> +	# which for XFS means no rt files.
> +	test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> +
>  	for SIZE_MULT in 1 2 8 64 256; do
>  		let SIZE=$SIZE_MULT*$SUNIT_BYTES
>  
> 

