Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A901DC433E5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D2E20760
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 10:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TKu/pt+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgGPKst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 06:48:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34254 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbgGPKss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 06:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594896527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wz/UHAiAHufAey++tJMpYh4czlqRhqCI8oLt32Fb7BY=;
        b=TKu/pt+55v2r8SVAoYNLquFn5MgqAFEYwLzYuxn6r03HBRkPnwSmSlVmzcm0IWM1ns0A5Y
        Gg415HnnOzuTOC7Bx6d8gYV3dq5wNKt+Aec4fj7dbjs+tkLl0u6rY12+MlBrci62OwWh2c
        G62Zr2O/UQYyda2X99pBWAo8w9BLXy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-m1S4YDBjPfCaCk7ekE6pXw-1; Thu, 16 Jul 2020 06:48:46 -0400
X-MC-Unique: m1S4YDBjPfCaCk7ekE6pXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06E6F800E23;
        Thu, 16 Jul 2020 10:48:45 +0000 (UTC)
Received: from bfoster (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1D0272E4A;
        Thu, 16 Jul 2020 10:48:44 +0000 (UTC)
Date:   Thu, 16 Jul 2020 06:48:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: drain the buf delwri queue before xfsaild idles
Message-ID: <20200716104842.GA31705@bfoster>
References: <20200715123835.8690-1-bfoster@redhat.com>
 <20200715175207.GA14300@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715175207.GA14300@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 06:52:07PM +0100, Christoph Hellwig wrote:
> On Wed, Jul 15, 2020 at 08:38:35AM -0400, Brian Foster wrote:
> > index c3be6e440134..6a6a79791fbb 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -542,11 +542,11 @@ xfsaild_push(
> >  	xfs_trans_ail_cursor_done(&cur);
> >  	spin_unlock(&ailp->ail_lock);
> >  
> > +out_done:
> >  	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
> >  		ailp->ail_log_flush++;
> >  
> >  	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
> > -out_done:
> 
> Nit:  if you move the out_done up a bit we can also de-duplicate the
> xfs_trans_ail_cursor_done and spin_unlock calls.
> 

Good point. v2 incoming..

Brian

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

