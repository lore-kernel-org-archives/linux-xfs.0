Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A268C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjDKEuS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDKEuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:50:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017D2173E
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1lZnDvQAKKPGH3K8pMnBPF5kQMkVrG4jMtDXtfZhKMg=; b=ho+O4v4M7xVr6vaQS7yJ4L8RCC
        VfBe9HitvX6i1EVGTdta12coa3Oo7cP2wvrMA5NZue4cZBYsscABUO1znYscqH87/xQ/DqPFHxs8O
        x0U0r1uh3NdYb6RigxwDqaldYz00iVnZrojnoyfiEIbwxQ/YxAI0MVtRRnSU38UlpL9gKcfECdfXI
        VsavsgS0Rhx27crZHxF9X2KV405HUf/dhxBhqjWWnuOxpHlIV2qJNt+rUVTlKfBUYSQZpj58032P2
        V0H+ognwbYBDllTnZsR0PzswwJobTorVfVci+TRjuVbh8SlE54wxLQzSfSuZjM/Nov4gOun0QoEVK
        i/Fd/fAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm5xM-00GPZv-1Q;
        Tue, 11 Apr 2023 04:50:12 +0000
Date:   Mon, 10 Apr 2023 21:50:12 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/4] xfs: stabilize the dirent name transformation
 function used for ascii-ci dir hash computation
Message-ID: <ZDTnBKxNz3v9uH/a@infradead.org>
References: <168073937339.1648023.5029899643925660515.stgit@frogsfrogsfrogs>
 <168073937927.1648023.2161829383787403331.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073937927.1648023.2161829383787403331.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 05:02:59PM -0700, Darrick J. Wong wrote:
> -		if (tolower(args->name[i]) != tolower(name[i]))
> +		if (xfs_ascii_ci_xfrm(args->name[i]) != xfs_ascii_ci_xfrm(name[i]))

Please avoid the overly long line name here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
