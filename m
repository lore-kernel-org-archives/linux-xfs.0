Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919ACC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54BBB64F37
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 18:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhBYSIL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:08:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231815AbhBYSG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 13:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614276331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2+697g1KmO6Er3+UI8f6JiuuCfoVCssfxnNICXFW4I=;
        b=hveBUcOaPyeTS1UUmqt87b4nGK+XmjpyIaUjamERCTq6PA1RYMPy0DLlsgC7bAFwBEALyN
        pM5DiYk82Xkp5PqdrBjQtoDIi61tV/xEH8sZJk6mluXYkBmNN0kIKVWitJTGLN12qOzAoQ
        jxsSo1ohndn5VF6/AvlxvZYzj0tLAAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-kh5C8nHoNzqqfChRdz_TRw-1; Thu, 25 Feb 2021 13:05:27 -0500
X-MC-Unique: kh5C8nHoNzqqfChRdz_TRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3A4E107ACC7;
        Thu, 25 Feb 2021 18:05:26 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82C9C60854;
        Thu, 25 Feb 2021 18:05:26 +0000 (UTC)
Date:   Thu, 25 Feb 2021 13:05:24 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <YDfm5Cl/ZJe6TkH6@bfoster>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210225075105.GG2483198@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225075105.GG2483198@infradead.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 07:51:05AM +0000, Christoph Hellwig wrote:
> As a quick fix this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> That beeing said we really need to go back and look into this,
> especially due to discards.  For SSDs it is generlly much better to
> quickly reuse freed blocks rather than discarding them later.
> 

Ok, that's an interesting point. I'm not sure online discard is a super
critical use case, but I agree that there's a tangible advantage to
optimizing out pending discards in that configuration.

That also raises a caveat with the alternative implementation I was
mulling over. The current implementation simply skips over extents that
are busy and already under discard. If we were to find a prospective
reusable busy block (not under discard), allocate it, and then commit to
reusing it, we'd have to deal with the fact that we could find it under
discard at that point. We can't easily skip it because we've already
performed an allocation in the transaction by that point. I suspect the
simplest solution is just wait for the discard to complete since we
already have somewhat of a mechanism to do that, but hopefully it
wouldn't be a frequent occurence.

Brian

