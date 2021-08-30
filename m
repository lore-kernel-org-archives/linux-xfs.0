Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEFEC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 15:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9CE861002
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 15:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbhH3P4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 11:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57406 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237542AbhH3P4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 11:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630338924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j3FK78u4epuKntZ1Jo0syUJH1rnv1EfRFzIkn2+EY8I=;
        b=YieaE1tbyTQ5DvqPvpGgFo7BRYJZweHFP3Ml95TSI3mSUQ8ygbtSj8TD18BxA28CpuH3qm
        bnJEm5ouhT2Cbn0dDQwmC8/lRnbZwk6nTkLkRKrbR85zLpR1PuXpQ+y1j7QDIn6JAYpqqd
        +gewlnfeOSQ/yAk5CTkEVVM8KYIePuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-P9t4zmu7NeiorKfHLghVDg-1; Mon, 30 Aug 2021 11:55:22 -0400
X-MC-Unique: P9t4zmu7NeiorKfHLghVDg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8EEE1B18BC2;
        Mon, 30 Aug 2021 15:55:21 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62FF35D9F4;
        Mon, 30 Aug 2021 15:55:21 +0000 (UTC)
Date:   Mon, 30 Aug 2021 10:55:19 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: dax: facilitate EXPERIMENTAL warning for dax=inode
 case
Message-ID: <20210830155519.b3ddh66dve4xcfgq@redhat.com>
References: <20210826173012.273932-1-bodonnel@redhat.com>
 <20210826180947.GL12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826180947.GL12640@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 26, 2021 at 11:09:47AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 26, 2021 at 12:30:12PM -0500, Bill O'Donnell wrote:
> > When dax-mode was tri-stated by adding dax=inode case, the EXPERIMENTAL
> > warning on mount was missed for the case. Add logic to handle the
> > warning similar to that of the 'dax=always' case.
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> >  fs/xfs/xfs_mount.h | 2 ++
> >  fs/xfs/xfs_super.c | 8 +++++---
> >  2 files changed, 7 insertions(+), 3 deletions(-)
... 

> > -	if (xfs_has_dax_always(mp)) {
> > +	if (xfs_has_dax_always(mp) || xfs_has_dax_inode(mp)) {
> 
> Er... can't this be done without burning another feature bit by:
> 
> 	if (xfs_has_dax_always(mp) || (!xfs_has_dax_always(mp) &&
> 				       !xfs_has_dax_never(mp))) {
> 		...
> 		xfs_warn(mp, "DAX IS EXPERIMENTAL");
> 	}

Not quite. This will be true at initialization.
-Bill

