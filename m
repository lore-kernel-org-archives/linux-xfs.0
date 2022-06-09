Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4645C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jun 2022 02:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbiFICt2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbiFICt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 22:49:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3EBD1A0AF8
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 19:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654742963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/0YpjuW68HNELekQLFsdSYJRUrxNvsJVXmGH2rDIGvE=;
        b=hsaeGx+aCumNHDyAXnwI7E23YQh+49Rsagx5zOJzKZmII+Q04fBFgDizPtqPQjrc1XK06i
        D/vbCqO+vRIbGFl43UB8R5uUZumNsHZUKd+FyZYMCjP1Ylu+pkwK7AHuDaPDhfFHKvWBzi
        9ddx7YLHmMxPuTpjoeRGqdla/0mJdDo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-5yBJVxomO1y10A6zsfqWgw-1; Wed, 08 Jun 2022 22:49:22 -0400
X-MC-Unique: 5yBJVxomO1y10A6zsfqWgw-1
Received: by mail-qv1-f69.google.com with SMTP id q36-20020a0c9127000000b00461e3828064so14130045qvq.12
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 19:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/0YpjuW68HNELekQLFsdSYJRUrxNvsJVXmGH2rDIGvE=;
        b=nCvGi6SjgItUCYk9zM4Jc7bzVoUzHf7ANgQfQ9GtjXczYP0/smoPH4GMScbdrUdPho
         PHiCF9oIeY7mkyXwlI6eJsds0Aw3v4J/faKBexWpd4xJC6HJY8eF6s5A+gR1Paem0l0A
         W2esIGO6HQGnpQQT0jZJdLGroOxsgApH0qXpB/5JUedUoJuP7bJ6A0AjDDhQwzf/JRN4
         kmBku9oUgJHc/piTul/MFrSVqp0AKfWwLADoP24a3eK0Tg8zsb8pSyoERE6d1oER2WHj
         qJQmpAtiePZlGIi/YYsULE2J2FTVa8FYrKIcQmmeAw0BHQHZGFAq+PzPtTmmxP7FyhVd
         ED5A==
X-Gm-Message-State: AOAM5314iVIfmoygzX4hJdF6mhc5e0G2XTYjjOT7p6EjCdLO0MvWlBtG
        njp3jKjzNdohDxPnuNOZqwmpbthU03xgzcNm6uQAKybHc9f/kH8WXOVGIqASojHgP61O/7MBxlg
        oFwvZuBF1TR8hKCKgMAKI
X-Received: by 2002:a05:620a:884:b0:6a7:347:386 with SMTP id b4-20020a05620a088400b006a703470386mr4112877qka.7.1654742962228;
        Wed, 08 Jun 2022 19:49:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBK1tIWNCe57tZEsE8mUnnp/UpdYnyXz4Zm8gvU2pKB7qcEdewVRclbUm+yfr4AUtK27ViWw==
X-Received: by 2002:a05:620a:884:b0:6a7:347:386 with SMTP id b4-20020a05620a088400b006a703470386mr4112866qka.7.1654742961980;
        Wed, 08 Jun 2022 19:49:21 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y28-20020a05620a0e1c00b006a0ffae114fsm16842033qkm.120.2022.06.08.19.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 19:49:21 -0700 (PDT)
Date:   Thu, 9 Jun 2022 10:49:15 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n  o area'
 (offset 0, size 1)!
Message-ID: <20220609024915.geephkxchu2fgpwk@zlang-mailbox>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 09:13:12PM +0200, Alexander Gordeev wrote:
> On Wed, Jun 08, 2022 at 10:19:22AM +0800, Zorro Lang wrote:
> > One of the test environment details as [1]. The xfstests config as [2].
> > It's easier to reproduce on 64k directory size xfs by running xfstests
> > auto group.
> 
> 
> Thanks for the details, Zorro!
> 
> Do you create test and scratch device with xfs_io, as README suggests?
> If yes, what are sizes of the files?

# fallocate -l 5G /home/test_dev.img
# fallocate -l 10G /home/scratch_dev.img
Then create loop devices.


> Also, do you run always xfs/auto or xfs/294 hits for you reliably?

100% for on my testing, I tried 10 times, then hit it 10 times last
weekend. Will test again this week.

> 
> Thanks!
> 

