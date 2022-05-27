Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27F1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 06:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiE0GRI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 02:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiE0GRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 02:17:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D0666C9B
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 23:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZAwIr6b/G3qJ7axMxXTCxb1ZGDVRtMy6flku4atUiow=; b=gVP2r5vSrOEWXikkJbfr/7dozu
        d0rv7NqRwk1TcobRvkgo+hRh0OU2u03qlHYoZgbb6yacka8lSR0xtbr27/417GVE03eTIWNXOAO+f
        qsgcbfLNGEOF5/QUSzWDArUZWa8smGkj1UMHzeF3F+Jgxll2xF+YdGUkccHMx6UUHSXMgL1IWN9nC
        mizRD5H1JKGisOI5jTGbpmSx94RJj6ZnpCQKy6PN4sQBpwvYF8h6FIwkKm57l5V5JW0cykprLzozn
        ftiXbNfzWArS4AK0yxjD0Bf8PwyEGnf1zsXrBIaGK26YYIYn27+I3xOhx8bXlJLj10SOZ0DKZBU0l
        CK05ZI5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuTHU-00GkBy-MC; Fri, 27 May 2022 06:17:04 +0000
Date:   Thu, 26 May 2022 23:17:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfsprogs: autoconf modernisation
Message-ID: <YpBs4K14/+CfMcu1@infradead.org>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-5-david@fromorbit.com>
 <393627ac-be5e-276b-65fb-6701679b958c@sandeen.net>
 <418a926d-fcc9-c5f0-1693-6392aaaa4618@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <418a926d-fcc9-c5f0-1693-6392aaaa4618@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 02:44:54PM -0500, Eric Sandeen wrote:
> Actually, I think that 2.71 from autoupdate is gratuitous, all your changes
> seem fine under the (ancient) 2.69.
> 
> So I'm inclined to merge this patch as is, but with a 2.69 minimum, as the
> current 2.50 version requirement is for something released around the turn
> of the century...

Sounds good.
