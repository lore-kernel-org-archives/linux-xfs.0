Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9BEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 21:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 064F464DE3
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 21:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhBKVXs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 16:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhBKVXQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 16:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE1DF64E42;
        Thu, 11 Feb 2021 21:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613078552;
        bh=JsD3j5o+dPcV5ZoSvx/ETT73LXLDOyAPmLHyV8yc8G0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MOjloW1QYpAHa1As8EM8mruy4u851Zh5xx0pVNjYuEUF+6tpXKk1YaboHjqX4sV0x
         b7p6Kfu7+2fmK58a/wxZu6ZndVPFx156wuhJbXW0AnR+q0lm1mNSsGXS5rgkbLpOnI
         O7jQTrkr6faR8kyFQnOK1OarAiQLyv/zcnPVnkyjXuHLTs4z2MLwrlTM5w4kS/VgoQ
         91XxfgYZKe6har7vvsg3gikwgOUK+y/0gzkufhzMk3iNAP3k+YER/9tjq93Hr6a08x
         tmByXVPjMMVLsih5nbjiJu2V3Y8ktmU6xzK5sBj7eZT9OQQQH5bswoSpzNUmNpY4u/
         QbukApiJViAhA==
Date:   Thu, 11 Feb 2021 13:22:31 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] fsstress: get rid of attr_list
Message-ID: <20210211212231.GL7190@magnolia>
References: <160505547722.1389938.14377167906399924976.stgit@magnolia>
 <160505550232.1389938.14087037220733512558.stgit@magnolia>
 <20201114104753.GG11074@infradead.org>
 <20210211211818.GK7190@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211211818.GK7190@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 11, 2021 at 01:18:18PM -0800, Darrick J. Wong wrote:
> On Sat, Nov 14, 2020 at 10:47:53AM +0000, Christoph Hellwig wrote:
> > Instead of the loop to check if the attr existed can't we just check
> > for the ENODATA return value from removexattr?
> 
> Yes.

No -- attr_remove_f reads the list of attribute names from the file and
then picks one at random to lremovexattr().

--D

> 
> > Also I think with this series we can drop the libattr dependency
> > for xfstests, can't we?
> 
> I'll do that in a subsequent patch.
> 
> --D
