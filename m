Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4CBC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 14:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E846D23107
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 14:57:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388964AbhALO4u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 09:56:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20232 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbhALO4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 09:56:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610463324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PvQ1pZlUJgGcLSXgk+eGFmkHixguymc6AKtCSg4/rew=;
        b=Bub5+t5maBIKRQjfFVAMHwV/Dh3W0uX70oEUhTScGCfnvyQKqByTyrcZ/2+AhRURj1xTXC
        /icOYbsxgDfSqbeVOot6YXsUIdmjN9pYCVPcwsm99AC6194PuuRzjIqj/cyfNNfbVyJS5j
        paVof1Wfj/xMPl9kuqap0/zR97p/t9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-QruS43_eO_mp1yPJYueWJA-1; Tue, 12 Jan 2021 09:55:22 -0500
X-MC-Unique: QruS43_eO_mp1yPJYueWJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DD1D100C600;
        Tue, 12 Jan 2021 14:55:21 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 025145B692;
        Tue, 12 Jan 2021 14:55:20 +0000 (UTC)
Date:   Tue, 12 Jan 2021 09:55:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: sync lazy sb accounting on quiesce of read-only
 mounts
Message-ID: <20210112145519.GA1131084@bfoster>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-2-bfoster@redhat.com>
 <20210111173851.GD848188@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111173851.GD848188@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:38:51PM +0000, Christoph Hellwig wrote:
> On Wed, Jan 06, 2021 at 12:41:19PM -0500, Brian Foster wrote:
> > Update xfs_log_sbcount() to use the same logic
> > xfs_log_unmount_write() uses to determine when to write an unmount
> > record.
> 
> But it isn't the same old logic - a shutdown check is added as well.
> 

xfs_log_unmount_write() does have a shutdown check, it just doesn't show
up in the diff because I wanted to retain the post-log force check in
that function (in the event that the force triggers a shutdown).

Brian

