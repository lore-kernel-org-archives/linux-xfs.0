Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EFAC34056
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 19:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76181208E4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 19:21:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaqZTOYN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSTVa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 14:21:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726643AbgBSTV3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 14:21:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582140088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z9mS72MXAaqNrFajkATOASI+LjuOcAOG9SFbbmnIEio=;
        b=aaqZTOYNQjCGXAXlDm5wuQiVp+v+7S+qmK0a7ad1yjdqNTaZ4jsGtnQIcWJWPMO/vUUQDP
        gag5w322Qym3wawq4jg/R9ZX0ZuskOOrM9gPUTwBX4nwqg1dVqxmFz56Il4Aj+7uLDMmDr
        XATETY5qlR4dshI1R2u9iwHX3fls6aY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-XcnIpHrhP-Onx40MSmEexg-1; Wed, 19 Feb 2020 14:21:26 -0500
X-MC-Unique: XcnIpHrhP-Onx40MSmEexg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B304100726A;
        Wed, 19 Feb 2020 19:21:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73CF810001AE;
        Wed, 19 Feb 2020 19:21:24 +0000 (UTC)
Date:   Wed, 19 Feb 2020 14:21:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the di_version field from struct icdinode
Message-ID: <20200219192122.GJ24157@bfoster>
References: <20200116104640.489259-1-hch@lst.de>
 <20200218210615.GA3142@infradead.org>
 <20200219001852.GA9506@magnolia>
 <20200219145234.GE24157@bfoster>
 <20200219184519.GB22307@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219184519.GB22307@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 07:45:19PM +0100, Christoph Hellwig wrote:
> On Wed, Feb 19, 2020 at 09:52:34AM -0500, Brian Foster wrote:
> > FWIW, I don't really view this patch as a straightforward
> > simplification. IMO, this slightly sacrifices readability for slightly
> > less code and a smaller xfs_icdinode. That might be acceptable... I
> 
> I actually find it easier to read.  The per-inode versioning seems
> to suggest inodes could actually be different on the same fs, while
> the new one makes it clear that all inodes on the fs are the same.
> 

It's subjective. I read it as that the logic assumes all inodes on the
fs are the same version, but doesn't tell me anything about whether that
assumption is (or will always be) true. I find that confusing,
particularly since that's not always the case on older sb versions that
we still support. IOW, so long as the codebase has to handle the common
denominator of non-uniform inode formats (or might in the future), I
don't see much value in using such mixed (feature level) logic when the
per-inode versioning handles both regardless of the particular sb
version policy. Just my .02.

> > don't feel terribly strongly against it, but to me the explicit version
> > checks are more clear in cases where the _hascrc() check is not used for
> > something that is obviously CRC related (which is a pattern I'm
> > generally not a fan of).
> 
> xfs_sb_version_hascrc is rather misnamed unfortunately.  In fact I think
> just open coding it as 'XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5'
> would improve things quite a bit.
> 

Agreed. This would help mitigate my aesthetic gripe around the whole 'if
(hascrc) { <do some non-crc related stuff> }' thing, at least.

Brian

