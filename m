Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5370DC3A5A3
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FFA4206BB
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 05:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="elDl6cLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfH3FWx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 01:22:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46770 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbfH3FWx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 01:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cxDp7+az0BClZ5OYlHt5GETGLWysXi6f3EmMISYOPHs=; b=elDl6cLWWiOQh3LxGtl6Ih8+t
        Se9JBw/gOiekS80TxmaYoFv26mV6kVzhjHDH+z/a9I49gScZlqaqm8E8cZMxDssmmeSnER7Us1/6E
        fKpEfxXbrXNZcYiFSRK6W0tDHuIz4CxBnuve+dI3AiXN3dlgOmYdKLEke1ayabO4vezy7QHlRhraW
        SenV3qumrpMPwX4uJ3DyM8oFlpAgiBzwWNmgS3wg9tSZD0wor8MIanxEMAtV2XURkHVGLK02Icpng
        mYXcXtsnM6wDBJ755mpay1Bh9VmY5lZZVgMuwxU6Dc4Fk0yRf22pBJCVXOpA7Mz6wZMAn5VF7hKaj
        TzhNkdHnQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i3ZN6-0001sR-Vo; Fri, 30 Aug 2019 05:22:52 +0000
Date:   Thu, 29 Aug 2019 22:22:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: move xfs_dir2_addname()
Message-ID: <20190830052252.GA6077@infradead.org>
References: <20190829104710.28239-1-david@fromorbit.com>
 <20190829104710.28239-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829104710.28239-2-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 08:47:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This gets rid of the need for a forward  declaration of the static
> function xfs_dir2_addname_int() and readies the code for factoring
> of xfs_dir2_addname_int().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Did't I ack this lat time around?

Reviewed-by: Christoph Hellwig <hch@lst.de>
