Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BF2C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5826B20714
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 17:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UrDN60Hj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgDYR1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 13:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbgDYR1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 13:27:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7E6C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 10:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gVpHzTgXkrFrtzT5SdnUCnxsuDcdUgchBowUgtGVI1s=; b=UrDN60HjC2CaejtzjKuZPAmxHI
        00cRhd/1b9PZkoYb3waAcGjnls8rIPf39NG5PgLobh7vAUtbBNW/m4Ondom1jUG5HSfJBYeMd9M41
        PFnqBYh8/k3idkUSzEy0YX8n7PdqazdBj4OL53X9GfgfIHNNFHe+4f+TFAELUPH5sxrIKValiNlqn
        4qP3TR7lWUTw6Q+q16158LAzSxa74A3Z88165Cr3zJmFfEYtW3a5Fsqyr90G8cmvkHDSOaA4JRBUL
        yU6/Gkb6v8A2OvRHivKbJnY0PE5Qmed7cr0DbWVHr78N2YzL6/iyQV9y+m/iaNNnIeEjhrXpXdZuw
        1/fU2bzw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSOam-0005dT-Ei; Sat, 25 Apr 2020 17:27:52 +0000
Date:   Sat, 25 Apr 2020 10:27:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 04/13] xfs: remove unnecessary shutdown check from
 xfs_iflush()
Message-ID: <20200425172752.GD30534@infradead.org>
References: <20200422175429.38957-1-bfoster@redhat.com>
 <20200422175429.38957-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422175429.38957-5-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 22, 2020 at 01:54:20PM -0400, Brian Foster wrote:
> The shutdown check in xfs_iflush() duplicates checks down in the
> buffer code. If the fs is shut down, xfs_trans_read_buf_map() always
> returns an error and falls into the same error path. Remove the
> unnecessary check along with the warning in xfs_imap_to_bp()
> that generates excessive noise in the log if the fs is shut down.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
