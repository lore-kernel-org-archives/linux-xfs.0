Return-Path: <SRS0=3dSt=YH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B95EC4CECE
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 08:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1151D20650
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Oct 2019 08:41:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aVlO69gd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfJNIk7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:40:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730441AbfJNIk7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Oct 2019 04:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=aVlO69gdetGh5R7NDhKx+2T9a
        748WVFOt5eoGPdOiWpNeMg/9sQqZZolECuq0JrgUzrHtvWM7Dg4HBpw3/w2krJx8Jszn7B4xQejZy
        Pq1wv2pw2Fh64lOM/KjYTrZ+u7zaoznuQNTT1m4fintaSV/tylpVhGExHPMv1lmtISdLq6ct/C1Ve
        h9V/hHtvcnRlKCpMETVtBIfqrcPh4xfIRFzkRSOlAdly5RWzL5u4Oz64RDieJa7xDXQNlQ+Dch99a
        RVYIRd/HfGUPcJVEAGcMqhHDGxAlGdxUknukkfEnvL/unsUGlGRWRKMF2hIZ8/7/TkE7Mo1iNZNrP
        ztTGbhzNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iJvuU-0002rb-0l; Mon, 14 Oct 2019 08:40:58 +0000
Date:   Mon, 14 Oct 2019 01:40:57 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] iomap: Allow forcing of waiting for running DIO in
 iomap_dio_rw()
Message-ID: <20191014084057.GB3593@infradead.org>
References: <20191014082418.13885-1-jack@suse.cz>
 <20191014082610.6298-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014082610.6298-1-jack@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
