Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AB5EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 05:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbjGMFIi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 01:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjGMFIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 01:08:38 -0400
X-Greylist: delayed 227 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Jul 2023 22:08:36 PDT
Received: from out-25.mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8262114
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 22:08:36 -0700 (PDT)
Date:   Thu, 13 Jul 2023 01:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689224914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXZBFt5lXaL+HIYE0QMnKllSutGAtNkC6zd9vvEo5bM=;
        b=uYCcWWB9RKkY2CKDujZNO+90KXyTDrBTg2uJDhJLgDhxmDNq7RWkTBcJau1r5iqqdJcTil
        lO5WytGFOzs+LIxTpFaJxihIix4b1BjoAu4weHYtjO8iA7Xvnfpw0reDyIKMHsyP9kE3wh
        UyTBIfpwpz5JWuTd6Wxk62x+9IsEyww=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 6/9] filemap: Add fgf_t typedef
Message-ID: <20230713050828.e3ptsa2j6anfibbi@moria.home.lan>
References: <20230710130253.3484695-1-willy@infradead.org>
 <20230710130253.3484695-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230710130253.3484695-7-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 02:02:50PM +0100, Matthew Wilcox (Oracle) wrote:
> Similarly to gfp_t, define fgf_t as its own type to prevent various
> misuses and confusion.  Leave the flags as FGP_* for now to reduce the
> size of this patch; they will be converted to FGF_* later.  Move the
> documentation to the definition of the type insted of burying it in the
> __filemap_get_folio() documentation.

lack of type safety for enums is a real issue - this is A+

Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>
