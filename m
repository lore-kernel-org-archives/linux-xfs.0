Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B153C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E505860FF1
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhDIORj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:17:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232286AbhDIORj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:17:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617977846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AfJ3/hZiNHWMxa/xhhSKNuIXECCaeJ54oAY4jB5iR1E=;
        b=T4nxJZdm+JwM26m5fKr2OW7n0B6TU2jYhT5NTbVu6PSNTmHuwTWuJoo7/QKeyUDeQpzc7d
        ggkc8cHH1jSGYZdOZGGhCv9ATAL4afrSLjxn1wtvP56SPGXo0pDHZFFNpdW327BTrHNHi2
        PTC+QW+GmmMXqANDbKRTw3XVf++9HBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-Y75rGiDTMLK5lDqeSOAWtg-1; Fri, 09 Apr 2021 10:17:23 -0400
X-MC-Unique: Y75rGiDTMLK5lDqeSOAWtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0221800FEA
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:17:22 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 796247217B
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:17:22 +0000 (UTC)
Date:   Fri, 9 Apr 2021 10:17:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 0/2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <YHBh8FCIBBMrrkyZ@bfoster>
References: <20210318161707.723742-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318161707.723742-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 18, 2021 at 12:17:05PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is v3 of the allocbt block set aside fixup. The primary change in
> v3 is to filter out rmapbt blocks from the usage accounting. rmapbt
> blocks live in free space similar to allocbt blocks, but are managed
> appropriately via perag reservation and so should not be set aside from
> reservation requests.
> 
> Brian
> 
> v3:
> - Use a mount flag for easy detection of active perag reservation.
> - Filter rmapbt blocks from allocbt block accounting.
> v2: https://lore.kernel.org/linux-xfs/20210222152108.896178-1-bfoster@redhat.com/
> - Use an atomic counter instead of a percpu counter.
> v1: https://lore.kernel.org/linux-xfs/20210217132339.651020-1-bfoster@redhat.com/
> 

Ping on this series..? AFAICT there is no outstanding feedback..

Brian

> Brian Foster (2):
>   xfs: set a mount flag when perag reservation is active
>   xfs: set aside allocation btree blocks from block reservation
> 
>  fs/xfs/libxfs/xfs_ag_resv.c     | 24 ++++++++++++++----------
>  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
>  fs/xfs/xfs_mount.c              | 18 +++++++++++++++++-
>  fs/xfs/xfs_mount.h              |  7 +++++++
>  5 files changed, 52 insertions(+), 11 deletions(-)
> 
> -- 
> 2.26.2
> 

