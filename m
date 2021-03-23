Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C291EC433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 18:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F962619C2
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 18:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhCWSgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 14:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhCWSga (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 14:36:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A5C061574
        for <linux-xfs@vger.kernel.org>; Tue, 23 Mar 2021 11:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=edQrln/19f0fGr+AyGuV89lVpbEOhTIZ4Dk0nu6zVMo=; b=dxilOZq7AxKn7/3C57KpVx15ki
        5btQ8OxWUuEW8lRC35U8tMY39shmLV3fGA2ZDHlCa4L5mUdmP8QMPt6pWjB832sRBfS7z5LUYXvIQ
        pqcQ/UEVvF0/B5nMzUk23DsuOZVz9sxeDGgDphJXD63RsazeXDVBKH2Jiz8NO98n2GJ14FGs+rcEn
        rRwvGTYENMUCJQSPrCmpLYgmAUVCO6AkfAvY+UojcQ/WTxAlSnX+62+Le5xsVPjrVyG6lHI9sZFtb
        yTrzgGbKVVqOsGSu4o7+8QlNUyseLIFI9uXlicdGU4cOq+txqVLabOCsk0hJBwHqEXzNF684zInvX
        qWu98n+A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOlsf-00APTY-0y; Tue, 23 Mar 2021 18:36:03 +0000
Date:   Tue, 23 Mar 2021 18:35:53 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove tag parameter from xfs_inode_walk{,_ag}
Message-ID: <20210323183553.GB2479637@infradead.org>
References: <161610681966.1887634.12780057277967410395.stgit@magnolia>
 <161610682523.1887634.9689710010549931486.stgit@magnolia>
 <20210319062501.GC955126@infradead.org>
 <20210319164354.GQ22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319164354.GQ22100@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 09:43:54AM -0700, Darrick J. Wong wrote:
> > That being said, the quota inode walk is a little different in that it
> > doesn't use any tags, so switching it to a plain list_for_each_entry_safe
> > on sb->s_inodes would seems more sensible, something like this untested
> > patch:
> 
> Hmm, well, I look forward to hearing the results of your testing. :)

I've thrown a whole lot ot of load onto it and it seems to survive just
fine.

> I /think/ this will work, since quotaoff doesn't touch inodes that can't
> be igrabbed (i.e. their VFS state is gone), so walking sb->s_inodes
> /should/ be the same.  The only thing I'm not sure about is that the vfs
> removes the inode from the sb list before clear_inode sets I_FREEING
> (to prevent further igrab), which /could/ introduce a behavioral change?

inode_sb_list_delinode_sb_list_del( is called from evict(), which
has a BUG_ON to assert I_FREEING is already set.
