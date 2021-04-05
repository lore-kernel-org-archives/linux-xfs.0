Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE199C433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 18:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1DD613B1
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 18:08:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbhDESI5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 14:08:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhDESI4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 14:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617646129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iO9Tl0zH4AJIiSbbf5Bno07qWsyfVUlbd9oUCkocla8=;
        b=Qf6dtjPo10jMY9qGLcEzSb0ZbMsmUVsaGMKST4Iwa71UCziG2RZnfSIv0ELvPdDyZWA7jE
        VXjp8z+edU+f48FDYweqGqbnGZu5eGOMcrkgwSs4EyXLDaZ47fqrCz2QUxWyTo2bO0dtou
        5Tzl+lFtQoaVTdenwclmVvaPbXlu9Ro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-Ay5DIR3PNxWhA_IsvMYElg-1; Mon, 05 Apr 2021 14:08:48 -0400
X-MC-Unique: Ay5DIR3PNxWhA_IsvMYElg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C0651966329;
        Mon,  5 Apr 2021 18:08:47 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E4675D9D0;
        Mon,  5 Apr 2021 18:08:46 +0000 (UTC)
Date:   Mon, 5 Apr 2021 14:08:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: drop unused ioend private merge and setfilesize
 code
Message-ID: <YGtSLVV3bxPRrN1P@bfoster>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-4-bfoster@redhat.com>
 <20210405175533.GA2788042@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405175533.GA2788042@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 06:55:33PM +0100, Christoph Hellwig wrote:
> On Mon, Apr 05, 2021 at 10:59:02AM -0400, Brian Foster wrote:
> >  			io_list))) {
> >  		list_del_init(&ioend->io_list);
> > -		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> > +		iomap_ioend_try_merge(ioend, &tmp, NULL);
> 
> The merge_private argument to iomap_ioend_try_merge and the io_private
> field in struct ioend can go way now as well.
> 

Indeed. I'll tack on another patch to remove all of that.

Brian

> Otherwise the whole series looks good to me from a very cursory look.
> 

