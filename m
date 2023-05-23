Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EB1C7EE23
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 12:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbjEWMRf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 08:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbjEWMRe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 08:17:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586B41A6;
        Tue, 23 May 2023 05:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1mtdJJvK8ntl0+tnaW0IVZQ9vmEJLCJ/m1HxTnC7SBc=; b=Mp9Kqou+Is/mKuO/Cp7xAhy8o3
        i0sfqaih65jq+cDlgqPlmsdfM+l9aJrtSXO316yEMAAEvD7aprr6Ymd410rsBeALegp4yCG/6i28v
        KFm0I+RhrqSiAtfVYMydnQKSm5lJA7MOIQ8h+PiZNEmsLdyHgT52BcGhCPeYTw03e0gG5h9Ueg/HZ
        T6Ng8PVCSdFRymL+8NMUrHDt7eQIxJUga7tT3NTrxXzJR3kEoAyM22GsDxxNpNmUkKoOZYlOSdZef
        Ncfeabz89WvYvoLXHmp5aBUA77pl+99nbiBQdxFDUitlFD8xtxX1ZN6C5UwFCvx+734yKlFoa9N1v
        Mmamp13w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q1Qx4-00ABld-1L; Tue, 23 May 2023 12:17:18 +0000
Date:   Tue, 23 May 2023 13:17:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] filemap: Allow __filemap_get_folio to allocate large
 folios
Message-ID: <ZGyuzW0Gc40L16FT@casper.infradead.org>
References: <20230520163603.1794256-1-willy@infradead.org>
 <20230520163603.1794256-2-willy@infradead.org>
 <ZGxWNRNt6sCoTqf9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGxWNRNt6sCoTqf9@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 22, 2023 at 10:59:17PM -0700, Christoph Hellwig wrote:
> On Sat, May 20, 2023 at 05:36:01PM +0100, Matthew Wilcox (Oracle) wrote:
> > +#define FGP_ORDER(fgp)		((fgp) >> 26)	/* top 6 bits */
> 
> Why don't we just add a new argument for the order?

Because it already takes four arguments and has dozens of callers,
most of which would have the uninformative '0' added to them?
