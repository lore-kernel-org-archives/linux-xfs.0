Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA46FC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 08:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36FB207BC
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 08:59:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G6WDGQU+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgGJI7Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 04:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgGJI7P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 04:59:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6073C08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 01:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9suiaCyA6n9zpkCe8RDJnXKIHWpCPll+xj1LntvNO1M=; b=G6WDGQU+Ok5Fw5pPVjq53r8LDV
        ArmhYJigd6deTfpKY3vVUnZBYgZJ/p7ffVTUwR58oL0xkRGPX0h/ymSC8NJcSyaqyVJd8FHeGA8Kp
        jm1oAa+b0nCCs3TDZczLTuH+WHMvEz89wKpy/z9GI5K+07zwyCddAgaTDH4iKxwqLC/yMNkNTNPa3
        1geHoNu28AB08Sa5wr0QZcXiHB94nHcE/uS8pp+uzD7tKhntiV39ZuKYkVh2KMGrrvenbnfLrsMXf
        wD1JLB2ILTYAVGIuTTiB6Zq2Q90gCENF9vfCY5Rm+OsLtXG/OpsaV0kuwJbXo8eSn80y+XTUnxFeH
        e5dwD/yw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtos6-00081K-IS; Fri, 10 Jul 2020 08:59:06 +0000
Date:   Fri, 10 Jul 2020 09:59:06 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Bill O'Donnell <billodo@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_quota: display warning limits when printing quota
 type information
Message-ID: <20200710085906.GA30797@infradead.org>
References: <20200709161124.GP7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709161124.GP7606@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 09:11:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We should dump the default warning limits when we're printing quota
> information.

This looks sensible.  Do we need any xfstests changes for thew new
output, though?

Reviewed-by: Christoph Hellwig <hch@lst.de>
