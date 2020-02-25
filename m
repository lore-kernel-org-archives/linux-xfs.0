Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 895B4C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 543C62082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jeGgxB4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgBYRtn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:49:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731017AbgBYRtm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:49:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=A2BbXtEcAcN5qb1FvDiguvolLVwOifeYMVwEDue26cw=; b=jeGgxB4ab1Ro56hqM4867MmhQP
        m/31eY1DlKQIgDKb4JXkMeefH5nixpQe9f4uRsVTFto5XAwFEEKwAqCCWfnHUedoVO6JZub7LFDYi
        pQRNwgnV9IIGkLcevqnUwetRgPoe5faKbE7NbLD9lF3rN3Sm/XlIXfWuOE3MKEvBwwYMPOQ783qd1
        1d5BgwKqb9DMZjXxc5sPkEAuDRkPeDfQAUWqxl9HGsenvQGyQe7/iUvqQmkHp1wl3vEHE9yNU+9Qs
        9ugN13gUcFJ5rZ8JcsBRNuudxgAaEZWg5JAwycEP2cPw8M17qVGsQp9jX0GI08QG6q8KHRw24UVly
        0VWnqVEg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eKz-00080g-8Z; Tue, 25 Feb 2020 17:49:41 +0000
Date:   Tue, 25 Feb 2020 09:49:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/25] libxfs: convert libxfs_log_clear to use uncached
 buffers
Message-ID: <20200225174941.GO20570@infradead.org>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258957631.451378.6297312804413916157.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158258957631.451378.6297312804413916157.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:12:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the log clearing function to use uncached buffers like
> everything else, instead of using the raw buffer get/put functions.
> This will eventually enable us to hide them more effectively.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  libxfs/rdwr.c |   16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index d607a565..739f4aed 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -1413,15 +1413,13 @@ libxfs_log_clear(
>  	/* write out the first log record */
>  	ptr = dptr;
>  	if (btp) {
> -		bp = libxfs_getbufr(btp, start, len);
> +		bp = libxfs_getbufr_uncached(btp, start, len);

Any reason this isn't using the public libxfs_buf_get_uncached
function?  Yes, that requires setting up the address, but it avoids
a dependency on internal helpers.

And I think we should add initializing the block, zeroing the buffer
and setting up ops into (lib)xfs_buf_get_uncached, basically moving
most of xfs_get_aghdr_buf into and improve the API eventually.
