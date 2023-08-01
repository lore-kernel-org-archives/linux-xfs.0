Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E927C00528
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Aug 2023 17:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjHARsj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 13:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjHARsh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 13:48:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C531E61;
        Tue,  1 Aug 2023 10:48:35 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1EED621D12;
        Tue,  1 Aug 2023 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1690912114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+mHZr6IXrsMOhJHIE2jKj1GMx2+HOC57bVUND7MpNQ=;
        b=lyQmbfqJg4zfPW4UncUMfNDQ4kBt/sh+eii6FB6Opr2T84QFEtfqV1Gaj4ETgwTNuDC1lv
        QxcxozIcx8wNedNGU/NsOZaeDUyBtYeL9ZGJunANYm2LEZdG/6cU8cUKJ6+altpseAUGOX
        A5cE755M/w41TzTlT7nZgEyyW0kdI5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1690912114;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+mHZr6IXrsMOhJHIE2jKj1GMx2+HOC57bVUND7MpNQ=;
        b=FGxmXe1lS/hyxwQ6FAA53dEfGKsk3PWlkc0NDmrr7r8g+hBIOoQTQKCFA4ECehp9fU6mxq
        VEmTPmRg+6m75ZDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D28EF139BD;
        Tue,  1 Aug 2023 17:48:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iLdNMnFFyWTdSAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 01 Aug 2023 17:48:33 +0000
Message-ID: <770a1cbd-f943-3f9a-5a0a-8bb2a8fd88ba@suse.de>
Date:   Tue, 1 Aug 2023 19:48:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 3/6] block: open code __generic_file_write_iter for blkdev
 writes
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian@brauner.io>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20230801172201.1923299-1-hch@lst.de>
 <20230801172201.1923299-4-hch@lst.de>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230801172201.1923299-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/1/23 19:21, Christoph Hellwig wrote:
> Open code __generic_file_write_iter to remove the indirect call into
> ->direct_IO and to prepare using the iomap based write code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/fops.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 43 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes


