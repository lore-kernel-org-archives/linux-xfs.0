Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60983C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 09:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbiEJJho (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 05:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236589AbiEJJhn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:37:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F028F7C2;
        Tue, 10 May 2022 02:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rP+2CL8iavR1r2YkRzJlB6pNAk9QBrJ0m5kgZqYBVtk=; b=R/mnbuxczCa18R1H2+2cyWZT8W
        VkMdzgbs3gAqNaLsADO18st0Q0093szVnSfDYPi2B5oQMhtE6bNYA2jDpZKN/20rKCin5q57sTxa/
        ZCtW14pR4hmo5qzgZ1CYXd0LYW/3u582fKM9kDDOO1jQxencU+MZEaQ4kd3SqM3XOQx4ccKJn7Mnc
        V1Be4nDxc/t3caOg2jRLpkILFU54n791AHE7ZF7mQs8RZuKsVbsPpGj/4lnuHVWPS4FwuRL/XFnQx
        OEUO2zcTo1Pi0YdpzVTIzr5v9tKC5sQuPqmsVQZtPzTSmQjH2MxiwCcMJVi1+qQb/yMBN6nGAnApv
        H1N4gi7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMFW-000qdu-0K; Tue, 10 May 2022 09:33:46 +0000
Date:   Tue, 10 May 2022 02:33:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] xfs: remove unreachable code
Message-ID: <YnoxebQ9JUugBwv0@infradead.org>
References: <20220506082615.19328-1-jiapeng.chong@linux.alibaba.com>
 <20220506160402.GO27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506160402.GO27195@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 09:04:02AM -0700, Darrick J. Wong wrote:
> > @@ -1765,7 +1765,6 @@ xfs_icwalk(
> >  		}
> >  	}
> >  	return last_error;
> > -	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_ICWALK_FLAGS_VALID);
> 
> <cough> Do you know what you're removing?

That being said hiding this behind the return is rather odd.  The
normal placement in most of the kernel is at the beginning of a
function.
