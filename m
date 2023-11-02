Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1F4C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 17:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjKBRUu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 13:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345168AbjKBRUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 13:20:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70FCB7;
        Thu,  2 Nov 2023 10:20:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8C6961F8C0;
        Thu,  2 Nov 2023 17:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1698945630;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hgyXm0yqUH3M9/QhJ+aQZ9JKr6wuOBE4tKbbRNdObs=;
        b=eBE4yRJojZDnSSHbSO/kkjsF1ze4WIiA5HnEiR83+sTUb4KYuutCxu6WiJHMdRYtxWMf5L
        bEjTUdE+krnT/CyVhGz1mnR9u6P+nuXVyhzuntot7Z9d5k7bM+OvfhOcSWqBpM8jjLE7Av
        PcQQmgfPQUdoYCTcFXiLp2ElMTFtWsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1698945630;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hgyXm0yqUH3M9/QhJ+aQZ9JKr6wuOBE4tKbbRNdObs=;
        b=DDXHnuuQc24ivuyozlTmMN4WtzkaQs9vYlCO/KrHfoB62dlx4VFtFGcNaNOuCOxRSi5919
        rFMg0Jhxc5RMGJDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3987D13584;
        Thu,  2 Nov 2023 17:20:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5IItDV7aQ2WrZAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 02 Nov 2023 17:20:30 +0000
Date:   Thu, 2 Nov 2023 18:13:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Jan Kara <jack@suse.cz>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        linux-xfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 4/7] btrfs: Do not restrict writes to btrfs devices
Message-ID: <20231102171331.GG11264@suse.cz>
Reply-To: dsterba@suse.cz
References: <20231101173542.23597-1-jack@suse.cz>
 <20231101174325.10596-4-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101174325.10596-4-jack@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 06:43:09PM +0100, Jan Kara wrote:
> Btrfs device probing code needs adaptation so that it works when writes
> are restricted to its mounted devices. Since btrfs maintainer wants to
> merge these changes through btrfs tree and there are review bandwidth
> issues with that, let's not block all other filesystems and just not
> restrict writes to btrfs devices for now.
> 
> CC: linux-btrfs@vger.kernel.org
> CC: David Sterba <dsterba@suse.com>
> CC: Josef Bacik <josef@toxicpanda.com>
> CC: Chris Mason <clm@fb.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: David Sterba <dsterba@suse.com>
