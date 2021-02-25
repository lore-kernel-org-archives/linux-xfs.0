Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A96AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 19:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD2464EFA
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 19:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhBYTEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233557AbhBYTE2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 14:04:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9DDC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 11:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KlbhI3cy5YAnf1ltLxdkM35VK/VkvaY9g2ChxSW/CGg=; b=R8UxikGmzE0ouWlCLHRsMuv74v
        qK9/JdokFaIYLYNTnYJ5E6IE4cUuzRk74YWugTVPLd9pQNsZEtvLHDyiK5K3Z5sQ7pV2Dj+G0X3E8
        E7FhMW4YRAQrcBKf7A0W8T1qw6MB8n4Lvyl7m9biuRESw42OpoVJTOK6BmilOmlVTBEgXgEUzBX23
        Lb55D2kUXXSnY6OhXignvkWs5xXLhbf16na0sKJOZ7E+EZq5oFITrQtUZz4dkjSXUu51HNrsV17ej
        HBxyjoQirJWQARgJ/LuMFFF2S0whEV1J9jwRp46y9U2cvo7nRxn2CPeOJjjEMDLpRBg68Zs9jtiM4
        nEaTnJLA==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFLv8-00B3Wi-AP; Thu, 25 Feb 2021 19:03:32 +0000
Date:   Thu, 25 Feb 2021 20:01:19 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: xfs_log_force_lsn isn't passed a LSN
Message-ID: <YDfz/ym+SGVZXDkC@infradead.org>
References: <20210223053212.3287398-1-david@fromorbit.com>
 <20210223053212.3287398-2-david@fromorbit.com>
 <20210224214235.GB7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224214235.GB7272@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 01:42:35PM -0800, Darrick J. Wong wrote:
> FWIW I rather wish you'd defined a new type for cil sequence numbers,
> since uint64_t is rather generic.  Even if checkpatch whines about new
> typedefs.
> 
> I was kind of hoping that we'd be able to mark xfs_lsn_t and xfs_csn_t
> with __bitwise and so static checkers could catch us if we accidentally
> feed a CIL sequence number into a function that wants an LSN.

__bitwise is a rather bad fit for xfs_lsn_t.  It is used as scalar and not
flags for which __bitwise is used, and it is written to disk in many
places.  Any in case you're asking:  I tried to quickly convert it and
noticed that the hard way.
