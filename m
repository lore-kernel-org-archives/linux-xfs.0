Return-Path: <SRS0=5D7u=6E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AEFC3815B
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC8820722
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Apr 2020 14:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UjmywCIE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgDTODE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 10:03:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48976 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726959AbgDTODE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Apr 2020 10:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587391383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tGtvFdgkyVapRiBSXEO0ZxG1hesbxhSdnD4IKAnE804=;
        b=UjmywCIEdq710wDRk41zUfvI31BfEXYgKDtWeq1ZkTHZoJ5fRxExNxE73tk4OWAhndfJtY
        WneRhILVq2/4XDBCA7qtBT0R9xvSTq6c6O1H0yi1BuR1nUNxOE+KcH4Pa4rvPOjg5qaVXE
        gcLFcEd65xpolo3BiIyHt/0ajif4DcI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-4ZGgWIpKOTSMzfasHU_UDw-1; Mon, 20 Apr 2020 10:03:01 -0400
X-MC-Unique: 4ZGgWIpKOTSMzfasHU_UDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20BEA100728B;
        Mon, 20 Apr 2020 14:03:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B930E5DA76;
        Mon, 20 Apr 2020 14:02:59 +0000 (UTC)
Date:   Mon, 20 Apr 2020 10:02:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove unnecessary quotaoff intent item push
 handler
Message-ID: <20200420140257.GG27516@bfoster>
References: <20200417150859.14734-1-bfoster@redhat.com>
 <20200417150859.14734-9-bfoster@redhat.com>
 <20200420035858.GK9800@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420035858.GK9800@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 20, 2020 at 01:58:58PM +1000, Dave Chinner wrote:
> On Fri, Apr 17, 2020 at 11:08:55AM -0400, Brian Foster wrote:
> > The quotaoff intent item push handler unconditionally returns locked
> > status because it remains AIL resident until removed by the
> > quotafoff end intent. xfsaild_push_item() already returns pinned
> > status for items (generally intents) without a push handler. This is
> > effectively the same behavior for the purpose of quotaoff, so remove
> 
> It's not the same. XFS_ITEM_PINNED results in a log force from the
> xfsaild, while XFS_ITEM_LOCKED items are just skipped. So this
> change will result in a log force every time the AIL push sees a
> quotaoff log item.  Hence I think the code as it stands is correct
> as log forces will not speed up the removal of the quotaoff item
> from the AIL...
> 

Ah right.. I was thinking we had a count heuristic there but we
potentially force the log once we hit at least one pinned item. I think
this same thing might have come up when this was first refactored. I'll
drop this one..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

