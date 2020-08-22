Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA4EC433E1
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 09:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68865214F1
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 09:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T3WJchXa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgHVJDn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgHVJDk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 05:03:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B717EC061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 02:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PBfbQswSwez+NoufzcHDYpmHuiFPaRIdHxdjzsYfg8g=; b=T3WJchXaF32bOIfggpSztfiX2A
        mg9W6B5j72hUF/iLiNVC+vF7vxq4qM3a0wsF0RJAJEclxkRRzZN2jklGOYLSwNho70ZYXhdlCmc84
        JLtYZaEzZKgx1jmkiGZPebiUf0vHk0FHAgmFdphaXf3DUsm4IlQyvWqbRZQvOWTJ8hcM8Aut3hfbJ
        tOf0UdkV0f+kFhHfmIEpf6szNjcucGgwKL6/fV4PLiNXTy5XYKYxvhGm5DIVJ53hVKVlSPMPOcwSK
        J61SgJZpLjb4CQDT1gtBHsmVLL6DRK+VeUAjCmY0TTZNgVS2cZkyTqSeDUftndzQwjd+XC+TkCeCY
        WmVPJxCQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9PR5-00072s-CE; Sat, 22 Aug 2020 09:03:39 +0000
Date:   Sat, 22 Aug 2020 10:03:39 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/13] xfs: add unlink list pointers to xfs_inode
Message-ID: <20200822090339.GB25623@infradead.org>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-6-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:48PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To move away from using the on disk inode buffers to track and log
> unlinked inodes, we need pointers to track them in memory. Because
> we have arbitrary remove order from the list, it needs to be a
> double linked list.
> 
> We start by noting that inodes are always in memory when they are
> active on the unlinked list, and hence we can track these inodes
> without needing to take references to the inodes or store them in
> the list. We cannot, however, use inode locks to protect the inodes
> on the list - the list needs an external lock to serialise all
> inserts and removals. We can use the existing AGI buffer lock for
> this right now as that already serialises all unlinked list
> traversals and modifications.
> 
> Hence we can convert the in-memory unlinked list to a simple
> list_head list in the perag. We can use list_empty() to detect an
> empty unlinked list, likewise we can detect the end of the list when
> the inode next pointer points back to the perag list_head. This
> makes insert, remove and traversal.
> 
> The only complication here is log recovery of old filesystems that
> have multiple lists. These always remove from the head of the list,
> so we can easily construct just enough of the unlinked list for
> recovery from any list to work correctly.

I'd much prefer not bloating the inode for the relative rate case of
inode unlinked while still open.  Can't we just allocate a temporary
structure with the list_head and inode pointer instead?
