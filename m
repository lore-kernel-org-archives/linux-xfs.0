Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52304C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 12:32:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E002080D
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 12:32:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SB3Zu4Ab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgFRMce (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 08:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727853AbgFRMce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jun 2020 08:32:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDE2C06174E;
        Thu, 18 Jun 2020 05:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=u5GeGyPb6IA0NbwDYar5/BEzeL7CZOg0nnPBSqGJN3w=; b=SB3Zu4Abml6P2PPUZp/IEHQ8oq
        rBGZvNmA5c2bZRrwKPQCZ2otnyyZ+aUrvr7va53JI69CaQslbauUdXn/hCFYhJAuMeW75FOdRJkaI
        b61KoiFETe23/VHJffoZcsTwp8CmbzrORms9Hf+3XfvoGUm9rDMhCdWbictCR9VgtyU+W0bZ3ePCJ
        si0IreqstlfOwWHfbkn4FCOtkYyO6eDc4Na37dOY+ryidiUmzVrRmkhq21qB6sEbNEsE7ZUzb+I4o
        jv0349kypHo5KMNsGadMaQqtDhEva3cqvZ3yniWVi1C/RWpIW0rC7yyx3P+gQEr7fLo94eg/TKEC1
        06N2m+jQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jltiV-0003m5-83; Thu, 18 Jun 2020 12:32:27 +0000
Date:   Thu, 18 Jun 2020 05:32:27 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>
Subject: Re: [PATCH] iomap: Make sure iomap_end is called after iomap_begin
Message-ID: <20200618123227.GO8681@bombadil.infradead.org>
References: <20200615160244.741244-1-agruenba@redhat.com>
 <20200618013901.GR11245@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618013901.GR11245@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 17, 2020 at 06:39:01PM -0700, Darrick J. Wong wrote:
> > -	if (WARN_ON(iomap.offset > pos))
> > -		return -EIO;
> > -	if (WARN_ON(iomap.length == 0))
> > -		return -EIO;
> > +	if (WARN_ON(iomap.offset > pos) || WARN_ON(iomap.length == 0)) {
> 
> Why combine these WARN_ON?  Before, you could distinguish between your
> iomap_begin method returning zero length vs. bad offset.

Does it matter?  They're both the same problem -- the filesystem has
returned an invalid iomap.  I'd go further and combine the two:

	if (WARN_ON(iomap.offset > pos || iomap.length == 0)) {

that'll save a few bytes of .text
