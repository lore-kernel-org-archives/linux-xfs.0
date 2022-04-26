Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B518EC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 14:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiDZOTH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 10:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351596AbiDZOTB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 10:19:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C694F20195
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 07:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650982552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L9PTpHnx6OUlvwfeN9b7umSmYti14aIiXQimfuHmXYM=;
        b=ZBuwnglqQZgwC6JI8GpYb81UeCJpntGpOvL3m0RERWJyMY+ne+9w1iPAIu48thqK/DUZre
        dh087EBqRqSFP1Pzvx30N3LuFwPw6kjGtVkpvpY91ZV23bGggE7xCAy9nDcLjcK+jFGH+K
        KyDkh1R4nkNv+ddvfjEEhuMorf8Uf/k=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-RFHzmVykMjm7qNNqf_RqvQ-1; Tue, 26 Apr 2022 10:15:51 -0400
X-MC-Unique: RFHzmVykMjm7qNNqf_RqvQ-1
Received: by mail-qt1-f199.google.com with SMTP id cj27-20020a05622a259b00b002f334b76068so9976534qtb.4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 07:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L9PTpHnx6OUlvwfeN9b7umSmYti14aIiXQimfuHmXYM=;
        b=ea9OTs0QxglTl/1OwliBN3Z6zdcyrMDSr5bIZJ4kbCTdGxv/mztKjpg7um7i+Nk+GK
         leHkbikSDvCRBElSDakWLrs5HrM6Qp9ZsWLlia7SIEhTPNSbry+dptutA+4y/yKbBFdO
         /xvvtSv0fuY1uciuX/nzS7qQiyi4DH3Ac5brKZQeoM+CVminOHcYYk9L16ezsl9K3wk6
         NBBdllkFAMKtAXuE/h9FCaMJD40z+LPFbaHRXXh3ZeEifR87hqJzTbKOKZ8/2zpgW8MM
         V8xi795Yb/cfQ0+H+4W/PXV7hm+Qs4/yD69ypUuwjgq/9NVTqdPSFdYuASEYIA6qnPrU
         EUIw==
X-Gm-Message-State: AOAM531fO6Bmv8YxULDNOiQTpPfujL47YDhE0jn6AlXZ/aTfcsrG3kmd
        Xf8J07lvWF5QrXKxY4aDhfzzyA0mDbW47oBmYOdNV20YlFZUz5vAqjBOAbILP2IEaR5cy6tzVoj
        gjHC0yKFQcvquYrpd9TkN
X-Received: by 2002:a0c:a68a:0:b0:443:d22b:cdff with SMTP id t10-20020a0ca68a000000b00443d22bcdffmr16356937qva.47.1650982551016;
        Tue, 26 Apr 2022 07:15:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXHVa37XmmhAprnRR05j75LioDmj8yCKU6uunubkJUUlHswALWZHnwFxf0pzTlpKXA1kewTQ==
X-Received: by 2002:a0c:a68a:0:b0:443:d22b:cdff with SMTP id t10-20020a0ca68a000000b00443d22bcdffmr16356915qva.47.1650982550811;
        Tue, 26 Apr 2022 07:15:50 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id g187-20020a37b6c4000000b0069f840cb643sm424864qkf.102.2022.04.26.07.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 07:15:50 -0700 (PDT)
Date:   Tue, 26 Apr 2022 10:15:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <Ymf+k9EA2bY/af4Y@bfoster>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
 <20220426024331.GR17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426024331.GR17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 07:43:31PM -0700, Darrick J. Wong wrote:
...
> 
> The biggest problem right now is that the pagecache is broken in 5.18
> and apparently I'm the only person who can trigger this.  It's the same
> problem willy and I have been working on since -rc1 (where the
> filemap/iomap debug asserts trip on generic/068 and generic/475) that's
> documented on the fsdevel list.  Unfortunately, I don't have much time
> to work on this, because as team lead:
> 

I seem to be able to reproduce this fairly reliably with generic/068.
I've started a bisect if it's of any use...

Brian

