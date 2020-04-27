Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75D7C54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A373A2063A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 11:12:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OL+Dnegq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgD0LMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 07:12:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57974 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726589AbgD0LMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 07:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587985964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pcOMR/uGvsMGUzv4Ng81kQAhEZa88eCYjVUpBUSUkW8=;
        b=OL+DnegqTeL1Wz9nIqrJBo1KtdwIeKikaYe5qC/NB8trMFI7a9Z2oVdpK/5aNcKBL2xPuk
        5Y9K8ThC7OTfSMXPJyNdmyZuGPWWPwA+kX9ftqEuJn3ekERqe56dD7JTxmi1i8Ez0Ac49k
        ylXiVwT3nNfn1KZZUBiZyf/9wUUFp1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-6JI2sMP5O_yt2RV2vNzwwQ-1; Mon, 27 Apr 2020 07:12:42 -0400
X-MC-Unique: 6JI2sMP5O_yt2RV2vNzwwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3272C1899521;
        Mon, 27 Apr 2020 11:12:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE1DA2C002;
        Mon, 27 Apr 2020 11:12:40 +0000 (UTC)
Date:   Mon, 27 Apr 2020 07:12:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 12/13] xfs: random buffer write failure errortag
Message-ID: <20200427111239.GD4577@bfoster>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-13-bfoster@redhat.com>
 <20200425173833.GI30534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425173833.GI30534@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 10:38:33AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 22, 2020 at 01:54:28PM -0400, Brian Foster wrote:
> > @@ -1289,6 +1289,12 @@ xfs_buf_bio_end_io(
> >  	struct bio		*bio)
> >  {
> >  	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
> > +	struct xfs_mount	*mp = bp->b_mount;
> > +
> > +	if (!bio->bi_status &&
> > +	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> > +	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
> > +		bio->bi_status = errno_to_blk_status(-EIO);
> 
> Please just use BLK_STS_IOERR directly here.
> 

Ok, fixed.

Brian

