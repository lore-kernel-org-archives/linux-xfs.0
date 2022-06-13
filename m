Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AA3CCA482
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jun 2022 19:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346342AbiFMTET (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243254AbiFMTDK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:03:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5006F18B20;
        Mon, 13 Jun 2022 09:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=38GMK7zc3Cm7LcXXwKmU9W4OU1b1mjrh83F5vfSCyBQ=; b=q71dZ0RNYEi0mB4pl8RDLP51wf
        V5nYZSKjqwvFVDZzIzL51r69+V9azDuuygaWJKoGYf1UE/SHUjjFNuez7ASDIH1X68BolKKeGk+/w
        VQLVowfZO0nSz6D3MaI14MCYvyUzkROJX5V7qcZLG8HiQMR5yUNmriLSkkujZFFbpaVHuFtzT9yxC
        cQ9ifA37KVOsjj/GMiDJKjReCuucJ8FbUwuPCFNd4n+ydLUtw4GJ2uZK9cNkfSO8IK+r/auKamYXM
        lv0q4/YqRNeJa17YBhCZkaQhl/1QlthBvX3Uk46Z8qsIuM/G3QUbqgvEl5pARyPuNjfHnge9sPel8
        7yvj9TzQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0nB5-00H0Mg-6D; Mon, 13 Jun 2022 16:44:35 +0000
Date:   Mon, 13 Jun 2022 17:44:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Message-ID: <Yqdpc336QsmVr1Tp@casper.infradead.org>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-2-willy@infradead.org>
 <202206130922.A218C4E3E8@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202206130922.A218C4E3E8@keescook>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 13, 2022 at 09:23:15AM -0700, Kees Cook wrote:
> On Sun, Jun 12, 2022 at 10:32:25PM +0100, Matthew Wilcox (Oracle) wrote:
> > vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
> > us to deny usercopies from those areas.  This affects XFS which uses
> > vm_map_ram() for its directories.
> > 
> > Fix this by calling find_vmap_area() instead of find_vm_area().
> 
> Thanks for the fixes!
> 
> > [...]
> > +		/* XXX: We should also abort for free vmap_areas */
> 
> What's needed to detect this?

I'm not entirely sure.  I only just learned of the existence of this
struct ;-)

        /*
         * The following two variables can be packed, because
         * a vmap_area object can be either:
         *    1) in "free" tree (root is free_vmap_area_root)
         *    2) or "busy" tree (root is vmap_area_root)
         */
        union {
                unsigned long subtree_max_size; /* in "free" tree */
                struct vm_struct *vm;           /* in "busy" tree */
        };

Hmm.  Actually, we only search vmap_area_root, so I suppose it can't
be a free area.  So this XXX can be removed, as we'll get NULL back
if we've got a pointer to a free area.  Ulad, do I have this right?
