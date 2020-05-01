Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233AFC47253
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD162166E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 11:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7K67fWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgEALZg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 07:25:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44808 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgEALZg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 07:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588332335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1J41qZXKoTdEEZXqVWBikp9nnbtjTzKv33XPwEqUyqE=;
        b=A7K67fWB9JeDWnHWj8Ux0RP+aAaKw0G3LzTiwwKjOtGLPfPjNxAO4I0tctAiZbU9tPM8Ml
        Ch8jlXYBhL+5kiZjx06ponqmfqdxEvFQC31E+uNedTaeolsA48t5AIIAt+zf2ACsbUSruU
        Sj743UsxsHsS82Sgvaqq2Q4RolzrlKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-gBvVcevAOSy7iQAes2lgkQ-1; Fri, 01 May 2020 07:25:33 -0400
X-MC-Unique: gBvVcevAOSy7iQAes2lgkQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EF4A107ACCA;
        Fri,  1 May 2020 11:25:33 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 94FC060C47;
        Fri,  1 May 2020 11:25:32 +0000 (UTC)
Date:   Fri, 1 May 2020 07:25:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 13/17] xfs: combine xfs_trans_ail_[remove|delete]()
Message-ID: <20200501112530.GE40250@bfoster>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-14-bfoster@redhat.com>
 <20200501080031.GH29479@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501080031.GH29479@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 01:00:31AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 29, 2020 at 01:21:49PM -0400, Brian Foster wrote:
> >  /**
> > - * Remove a log items from the AIL
> > + * Remove a log item from the AIL.
> >   *
> > + * For each log item to be removed, unlink it from the AIL, clear the IN_AIL
> 
> This only works on one item, so the "For each" seems wrong.   That being
> said I think we can just remove the comment entirely - the 'remove a log
> item from the AIL' is pretty obvious from the name, and the details are
> described in the helper actually implementing the functionality.
> 

Works for me, comment removed.

Brian

> The rest looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

