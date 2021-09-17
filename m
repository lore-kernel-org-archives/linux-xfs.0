Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB9AC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:27:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7182261029
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 10:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242714AbhIQK3K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 06:29:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38166 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242482AbhIQK3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 06:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631874467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=liKY3Y3XpuEb1R8bOfajserrfbkX+Pg3hLBYQbacQsw=;
        b=RF6CjI/TKVUVZGjfRMSTHsqwnRrLfC63RQ7R+ft7A115Vk6fCJ0tOMPXKNFc5AhjCECl2i
        J1oKvT4X9IYHwp8dlIXxElGIkrxj2bLmw1N4N2K2kMKTbX9+o0CG/0m/0VQu0Smhcx9iBx
        LWw1AZ3pz9II705m5nR2gV1AO6m+rIs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-AiRMSWuNP7SQTwSipXnnDQ-1; Fri, 17 Sep 2021 06:27:45 -0400
X-MC-Unique: AiRMSWuNP7SQTwSipXnnDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2B3D801B3D;
        Fri, 17 Sep 2021 10:27:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCA49100AE35;
        Fri, 17 Sep 2021 10:27:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
cc:     dhowells@redhat.com, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Could we get an IOCB_NO_READ_HOLE?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2315871.1631874463.1@warthog.procyon.org.uk>
Date:   Fri, 17 Sep 2021 11:27:43 +0100
Message-ID: <2315872.1631874463@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Christoph,

Would it be possible to get an IOCB_NO_READ_HOLE flag that causes a read to
either fail entirely if there's a hole in the file or to stop at the hole,
possibly returning -ENODATA if the hole is at the front of the file?

Looking at iomap_dio_iter(), IOMAP_HOLE should be enabled in
iomap_iter::iomap.type for this?  Is it that simple?

David

