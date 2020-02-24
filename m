Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17939C38BFA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E088E218AC
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 22:50:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gRA0oJMh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBXWui (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 17:50:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33215 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728010AbgBXWui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 17:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582584637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bD7epqUSyH14V5UJO3Tp8PDSH7uB1/nl7pEhP2PyGlM=;
        b=gRA0oJMhBOJhoBnTR26FOeneqZF8+DjFPKzWr9pXIT4JT+SP9A9OpmRnSZsmcSPHRgb4SA
        Lw2OHgHw9/ouJy4AmQcToqV5aPW5Fy+Wz8CEW6JgVKfEmKVLRQWCktJEXnQJIlHsqyRNUl
        Fcxyt8ac9WaqprL0Qn3FHedG3f25a+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-MAwUON0fNF-M09XLpi5TtA-1; Mon, 24 Feb 2020 17:50:35 -0500
X-MC-Unique: MAwUON0fNF-M09XLpi5TtA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 464FC1005514;
        Mon, 24 Feb 2020 22:50:34 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFD9E60BF7;
        Mon, 24 Feb 2020 22:50:33 +0000 (UTC)
Subject: Re: [PATCH 1/6] xfs: remove the agfl_bno member from struct xfs_agfl
To:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20200130133343.225818-1-hch@lst.de>
 <20200130133343.225818-2-hch@lst.de> <20200224220256.GA3446@infradead.org>
 <75eb13f6-8f96-a07d-f6ee-c648f8a3b38e@sandeen.net>
 <20200224223034.GA14361@infradead.org>
 <61713cad-ea6c-6a0c-79eb-cf01105e1222@sandeen.net>
 <20200224224648.GB25075@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <477af5b7-9973-1e4e-a8b4-8458e516f686@redhat.com>
Date:   Mon, 24 Feb 2020 14:50:33 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224224648.GB25075@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/24/20 2:46 PM, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 02:35:08PM -0800, Eric Sandeen wrote:
>>> The "harmless" gcc complaint is that the kernel build errors out as
>>> soon as XFS is enabled on arm OABI.  Which is a good thing, as the
>>> file system would not be interoperable with other architectures if it
>>> didn't.
>>
>> Not just on latest GCC?
> 
> AFAIK all versions of gcc, as that is the intent of BUILD_BUG_ON.

Right, makes sense.

So let's please commit a changelog that makes it clear that this
fixes an actual alignment problem and build breakage, ok?

Thanks,
-Eric

