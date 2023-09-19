Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10077CE79AC
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Sep 2023 21:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjISVEc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Sep 2023 17:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbjISVEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2023 17:04:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445C4B3
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2023 14:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695157424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SQ2jSb2HniT/9ZxZOqq4fZsdcqlotGNawe8KlI6XEwk=;
        b=G1w6d5nJyN6mNOEz0/4YKwEXYGGELb4G924Hz3Xdxt+a+Iqr7MhHHf+hcqea9F0NMfXPfO
        kc7NLIpb7Ws7NCXzV9dM2kTdTyKQZPuOWBXBkhlKAuwekaPE/izIDO/PKBW6i4qba/sZO2
        RH/IeIRNLKf6I9AjTYTCQDXXf8kRy48=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-eIRUBykjMwCw6pvVHAiSTw-1; Tue, 19 Sep 2023 17:03:42 -0400
X-MC-Unique: eIRUBykjMwCw6pvVHAiSTw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31963185A790;
        Tue, 19 Sep 2023 21:03:42 +0000 (UTC)
Received: from rh (unknown [10.64.138.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D042C492C37;
        Tue, 19 Sep 2023 21:03:41 +0000 (UTC)
Received: from localhost ([::1] helo=rh)
        by rh with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <dchinner@redhat.com>)
        id 1qihsg-001H19-1L;
        Wed, 20 Sep 2023 07:03:38 +1000
Date:   Wed, 20 Sep 2023 07:03:36 +1000
From:   Dave Chinner <dchinner@redhat.com>
To:     Charles Han <hanchunchao@inspur.com>
Cc:     corbet@lwn.net, djwong@kernel.org, allison.henderson@oracle.com,
        bhelgaas@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Documentation: xfs: Remove repeated word in comments
Message-ID: <ZQoMqI/QGPWEpkEi@rh>
References: <20230918071905.296081-1-hanchunchao@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918071905.296081-1-hanchunchao@inspur.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc linux-xfs@vger.kernel.org]

Hi Charles,

For future reference, can you CC the XFS list on XFS documentation
changes please?  That's much preferable to sending patches to random
developers and hoping they notice it....

On Mon, Sep 18, 2023 at 03:19:05PM +0800, Charles Han wrote:
> Remove the repeated word "the" in comments.
> 
> Signed-off-by: Charles Han <hanchunchao@inspur.com>
> ---
>  Documentation/filesystems/xfs-online-fsck-design.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
> index 1625d1131093..a0678101a7d0 100644
> --- a/Documentation/filesystems/xfs-online-fsck-design.rst
> +++ b/Documentation/filesystems/xfs-online-fsck-design.rst
> @@ -1585,7 +1585,7 @@ The transaction sequence looks like this:
>  2. The second transaction contains a physical update to the free space btrees
>     of AG 3 to release the former BMBT block and a second physical update to the
>     free space btrees of AG 7 to release the unmapped file space.
> -   Observe that the the physical updates are resequenced in the correct order
> +   Observe that the physical updates are resequenced in the correct order

Change looks fine, though.

Reviewed: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
dchinner@redhat.com

