Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE381C3F2D2
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 16:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD2120637
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 16:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m/Ig6TE/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbgCEQs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Mar 2020 11:48:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60358 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCEQs3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Mar 2020 11:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K+xBEDruGymbm+3ycrQz4pf8dy4pR3xtiaDdBCcv6b4=; b=m/Ig6TE/XYA1j0PUK9/PNrJ/ih
        N0Xa3H0bE8vhaNZUKSkHSX/07ExMsVvjEB9yFIJuwETEPlriqhpptjAD9P6mdD1VJg+j1OAW5Feya
        e27NAT0+4FfTwQbR8sXzcpt3r138SnCxcWYdryxRg5CDGSBvIBrO5GeaeJC6lEaOOKrYy5Qgzqp0s
        HqmbLFBkz031GXVzbDo00Q/76Fi/GcjptmGe11N+AtDw5R3XIshQ7I1sta08H4nRb65KkFKRzO63+
        Gten0XQrSs/1DyK/u0vuNerDyBXSaNxbiMzQsqZt/+enBEDnO9sB2hRirMH9UMWlc1xM8Im7l7Z0a
        qFHSnn5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9tfd-000264-II; Thu, 05 Mar 2020 16:48:25 +0000
Date:   Thu, 5 Mar 2020 08:48:25 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs_repair: check that metadata updates have been
 committed
Message-ID: <20200305164825.GA7630@infradead.org>
References: <158293292760.1548526.16432706349096704475.stgit@magnolia>
 <158293296528.1548526.15883438061985494121.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158293296528.1548526.15883438061985494121.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 03:36:05PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that any metadata that we repaired or regenerated has been
> written to disk.  If that fails, exit with 1 to signal that there are
> still errors in the filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
