Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3BBC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 12:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346561AbiD1Mtp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 08:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346599AbiD1Mtl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 08:49:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2741F2A731
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 05:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NiVDIsxC7hkE7jUCFcIbWa20Yf+RHpcZ5Zs89q3Fx18=; b=R7E8uMvkOYyI9r4tEE3id3RbiU
        yhr6pOJGDoQYXH9twFeinPgziU27HWXekDbWBXLBILLlpNokvWJ8XuKrjwKFXVs0DciKj9GouSYd/
        GFm7GZXlEwbUhkKFudPaNS5pfI92+1rSN1EXXM6p9FhIDpsKmPJLW/al2ijf7w+NXz/1FSo8OHXiH
        uWzWSkH8Sli69rVvDLYNPIWkKSMQejYFFtbck6DACAAtza3RTceRq1Q8tJ1/1C4XzT4W1bjX5Rk5N
        OCaO1xa9K0bj93HbO0Kww+9e9+kEA8Yj/99luT++cHci4Ut7a7VzjR0ZUTWLGE90JsrTXwq0dNcul
        VAQpEuWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nk3XM-006rX9-NE; Thu, 28 Apr 2022 12:46:24 +0000
Date:   Thu, 28 Apr 2022 05:46:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: count EFIs when deciding to ask for a
 continuation of a refcount update
Message-ID: <YmqMoAn/0Zdxr8nN@infradead.org>
References: <165102071223.3922658.5241787533081256670.stgit@magnolia>
 <165102071799.3922658.11838016511226658958.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165102071799.3922658.11838016511226658958.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good except for the premature helper removal:

Reviewed-by: Christoph Hellwig <hch@lst.de>
