Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88FFC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 13:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C5E4610C7
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 13:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhIQNDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 09:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbhIQNDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 09:03:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A99C061574;
        Fri, 17 Sep 2021 06:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DEmVMpmTCGqFf+yF34SLhuKOtOLCFQoDrpA+8o6tNNM=; b=ue5susz7hbwODLv/DPomTCBDPu
        XF1NQcFtI6G/yQ2DnzH8iYnABXeVfL2te3Ulxd3JtcCzVSJZSYcjMkeNevLjwUkytsugR8fblOoHr
        qMWByjUVx2dg7G8V2hNpcHt4l8P+aMk8uhJgyCdzeXoQd/oVI7xdhSIH8vH1X2B9n5fcOTn9UHa+Q
        H7GM1QJmlmu8mf8jeCoaehnOEFMjgmhXYQ0kx44qFHI/hyo1xlgrqk/DwBytUw2B1twSoTinxAgkh
        IzCPYThRp+rlyr2lK7PWgozAuqptmTOejxbn4pxc+GtyT0WoEx5Ou4CTCz5VmsByl64m0z2KlBhwo
        uD5Gu8Qw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mRDSQ-000G6q-Rl; Fri, 17 Sep 2021 13:00:05 +0000
Date:   Fri, 17 Sep 2021 13:59:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com
Subject: Re: [PATCH 3/3] ext2: remove dax EXPERIMENTAL warning
Message-ID: <YUSRHjynaozAuO+P@infradead.org>
References: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
 <1631726561-16358-4-git-send-email-sandeen@redhat.com>
 <20210917094707.GD6547@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917094707.GD6547@quack2.suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 17, 2021 at 11:47:07AM +0200, Jan Kara wrote:
> On Wed 15-09-21 12:22:41, Eric Sandeen wrote:
> > As there seems to be no significant outstanding concern about
> > dax on ext2 at this point, remove the scary EXPERIMENTAL
> > warning when in use.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Agreed. Do you want my ack or should I just merge this patch?

Please do not merge it.  The whole DAX path is still a mess and should
not be elevated to non-EXPERMINTAL state in this form.
