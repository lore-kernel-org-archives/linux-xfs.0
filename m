Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE75C4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 11:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD6420870
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 11:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkBaY6xZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgCXLnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 07:43:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:33299 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgCXLnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 07:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585050198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eSLP1FvTqrKGGesBYSs73BxqhmYe4DNqmfGVjzLz02E=;
        b=HkBaY6xZtAeffJiAa8ZfoTx2N5sAxLe3yhqH7DVMj92Bcu+CAEpQj23hoUOV3dCrxSSqhT
        Y2ziC3SLl8K+/5D+bP2R+HUAvQM6NIKp5MaY2gpJFlEJdNUunOi2c+JWwtD2cNNluBTJgb
        /jL1LILs6sfIDmQ+l+e7m/GynGKqaTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-VKXpVtzaNeeL0oTEtdBesA-1; Tue, 24 Mar 2020 07:43:14 -0400
X-MC-Unique: VKXpVtzaNeeL0oTEtdBesA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2705713F5;
        Tue, 24 Mar 2020 11:43:13 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9083C89E76;
        Tue, 24 Mar 2020 11:43:12 +0000 (UTC)
Date:   Tue, 24 Mar 2020 07:43:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: xfs: clean up log tickets and record writes v2
Message-ID: <20200324114310.GA3148@bfoster>
References: <20200323130706.300436-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323130706.300436-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 02:06:57PM +0100, Christoph Hellwig wrote:
> This series follows up on conversions about relogging infrastructure
> and the way xfs_log_done() does two things but only one of several
> callers uses both of those functions. It also pointed out that
> xfs_trans_commit() never writes to the log anymore, so only
> checkpoints pass a ticket to xlog_write() with this flag set and
> no transaction makes multiple calls to xlog_write() calls on the
> same ticket. Hence there's no real need for XLOG_TIC_INITED to track
> whether a ticket has written a start record to the log anymore.
> 
> A lot of further cleanups fell out of this. Once we no longer use
> XLOG_TIC_INITED to carry state inside the write loop, the logic
> can be simplified in both xlog_write and xfs_log_done. xfs_log_done
> can be split up, and then the call chain can be flattened because
> xlog_write_done() and xlog_commit_record() are basically the same.
> 
> This then leads to cleanups writing both commit and unmount records.
> 
> Finally, to complete what started all this, the XLOG_TIC_INITED flag
> is removed.
> 
> A git tree is avaiblable here:
> 
>     git://git.infradead.org/users/hch/xfs.git xlog-ticket-cleanup.2
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xlog-ticket-cleanup.2
> 
> 
> Changes since v1:
>  - taking this over from Dave (for now) as he is still injured, an it
>    interacts closely with my log error handling bits
>  - rebased on top of for-next + the "more log cleanups" series
>  - fix an accounting error in xlog_write
>  - use a bool for the ticket header in xlog_write
>  - add a new patch to split xlog_ticket_done
> 

This seems to ignore various bits of (trivial) feedback from v1 as well
as drops all reviews...

Brian

