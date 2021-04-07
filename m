Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3260C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 11:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFA16136A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 11:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhDGLYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 07:24:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234598AbhDGLYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 07:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617794631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=78gYsMf1wTUbwD1fRz6i3IOgBu8ZHNk+ftqf8wYMriI=;
        b=SNPoMEbw5MW6j5q6vgvw2KkhftDEnV4ITKMGM+Ne9jacWPXCjpZSfXX+yJVGPP2WyJVdAu
        GfFwGKbYAzcT1LNXrAz5VyGiznT0Lnup93HdfZYkagVgAVTtyLRbrx6ftJaByEvUWPBrcE
        qKXugXHQ/zyAdmHCmIowtOCTQWLg5zo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-2x-JkzOZOqWIgNJbS4Lryg-1; Wed, 07 Apr 2021 07:23:49 -0400
X-MC-Unique: 2x-JkzOZOqWIgNJbS4Lryg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3940189C454;
        Wed,  7 Apr 2021 11:23:48 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7FE0D1045D01;
        Wed,  7 Apr 2021 11:23:48 +0000 (UTC)
Date:   Wed, 7 Apr 2021 07:23:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: drop submit side trans alloc for append ioends
Message-ID: <YG2WQhu3GcXwIgmO@bfoster>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-2-bfoster@redhat.com>
 <20210407063321.GB3339217@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407063321.GB3339217@infradead.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 07, 2021 at 07:33:21AM +0100, Christoph Hellwig wrote:
> > @@ -182,12 +155,10 @@ xfs_end_ioend(
> >  		error = xfs_reflink_end_cow(ip, offset, size);
> >  	else if (ioend->io_type == IOMAP_UNWRITTEN)
> >  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> > -	else
> > -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
> 
> I first though we'd now call xfs_setfilesize for unwritten extents
> as well, but as those have already updated di_size we are fine here.
> 
> As a future enhancement it would be useful to let xfs_reflink_end_cow
> update the file size similar to what we do for the unwritten case.
> 

Agreed. I noticed that when first passing through the code but didn't
want to get into further functional changes.

> >  done:
> > -	if (ioend->io_private)
> > -		error = xfs_setfilesize_ioend(ioend, error);
> > +	if (!error && xfs_ioend_is_append(ioend))
> > +		error = xfs_setfilesize(ip, ioend->io_offset, ioend->io_size);
> >  	iomap_finish_ioends(ioend, error);
> 
> The done label can move after the call to xfs_setfilesize now.
> 

Fixed.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks.

Brian

