Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975EDC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 13:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EAA82064A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 13:44:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DSPREbHt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgEGNoC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 09:44:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbgEGNoB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 09:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588859040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8FyHjr7cRDRanSqpfXfBg4y5EKZdRa6C0+x8FLrI1sk=;
        b=DSPREbHtWoOPWpgCX2Z8i0O4M1Vqoxmu9nZvHWISpIf2IXZYHFsrkrqPk5mDQd5EM+IOhs
        /oYn1gGeAgTOcll3ZL0iaFdUh48iiufdYeB1Er0C/RMs2UMPXq03z1CNcYkPKB0x4Q5O0l
        BVhhRkBe1E48Fb/pZV6reVMpJRefQ2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-RUSRasn-OeOO7oj9FMxUXg-1; Thu, 07 May 2020 09:43:58 -0400
X-MC-Unique: RUSRasn-OeOO7oj9FMxUXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BCA2107ACF4;
        Thu,  7 May 2020 13:43:57 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B5D95C1BE;
        Thu,  7 May 2020 13:43:56 +0000 (UTC)
Date:   Thu, 7 May 2020 09:43:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200507134355.GF9003@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-9-hch@lst.de>
 <20200501155649.GO40250@bfoster>
 <20200501160809.GT6742@magnolia>
 <20200501163809.GA18426@lst.de>
 <20200501165017.GA20127@lst.de>
 <20200501182316.GT40250@bfoster>
 <20200507123411.GB17936@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507123411.GB17936@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 02:34:11PM +0200, Christoph Hellwig wrote:
> On Fri, May 01, 2020 at 02:23:16PM -0400, Brian Foster wrote:
> > Can we use another dummy parent inode value in xfs_repair? It looks to
> > me that we set it to zero in phase 4 if it fails verification and set
> > the parent to NULLFSINO (i.e. unknown) in repair's in-core tracking.
> > Phase 6 walks the directory entries and explicitly sets the parent inode
> > number of entries with an unknown parent (according to the in-core
> > tracking). IOW, I don't see where we actually rely on the directory
> > header having a parent inode of zero outside of detecting it in the
> > custom verifier. If that's the only functional purpose, I wonder if we
> > could do something like set the bogus parent field of a sf dir to the
> > root inode or to itself, that way the default verifier wouldn't trip
> > over it..
> 
> I don't think we need a dummy parent at all - we can just skip the
> parent validation entirely, which is what my incremental patch does.
> 

xfs_repair already skips the parent validation, this patch just
refactors it. What I was considering above is whether repair uses the
current dummy value of zero for any functional reason. If not, it kind
of looks like the earlier phase of repair checks the parent, sees that
it would fail a verifier, replaces it with zero (which would also fail
the verifier) and then eventually replaces zero with a valid parent or
ditches the entry in phase 6. If we placed a temporary parent value in
the early phase that wouldn't explicitly fail a verifier by being an
invalid inode number (instead of using 0 to notify the verifier to skip
the validation), then we wouldn't need to skip the parent validation in
phase 6 when we look up the inode again.

Brian

