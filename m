Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B4DC00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 11:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiHRLMQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 07:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243897AbiHRLMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 07:12:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C05A261D
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 04:12:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9296C3EF4F;
        Thu, 18 Aug 2022 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660821131;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVy2n59fQYp+pu9qr16IzYo/E5Ctyx6akUTRrrt1Q2s=;
        b=jhlzRDKj5DhQ7i289fyvZaOesK80n/nfK8Mci6/klXO6qZJ5i77asP7cReB5VU5fhY2pOh
        zNrKjKnfGV930dvbPqvHqyB6LzM09l4zFdZK5HZ1UqhcShq1bRcpZCrAxAz2LUtDO5G38Y
        //bs8JvPpxKZOqETALYj5YXpTSn6a0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660821131;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eVy2n59fQYp+pu9qr16IzYo/E5Ctyx6akUTRrrt1Q2s=;
        b=KxifbIzasSSgYiOoGC8jfXkb/Gn+HO1s65d7+2Tcm77OlQNyBhvDIPiFmk7rJo1IZC+m7I
        GvFq7C30AG46+3CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 381B7133B5;
        Thu, 18 Aug 2022 11:12:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zGBHDIse/mKcJQAAMHmgww
        (envelope-from <pvorel@suse.cz>); Thu, 18 Aug 2022 11:12:11 +0000
Date:   Thu, 18 Aug 2022 13:12:09 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     Cyril Hrubis <chrubis@suse.cz>
Cc:     ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
        Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [RFC PATCH 1/1] API: Allow to use xfs filesystems < 300 MB
Message-ID: <Yv4eiT5L+M7dMkQ5@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20220817204015.31420-1-pvorel@suse.cz>
 <Yv4MBF79PnJKJbwm@yuki>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv4MBF79PnJKJbwm@yuki>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Cyril,

> Hi!
> I'm starting to wonder if we should start tracking minimal FS size per
> filesystem since btrfs and xfs will likely to continue to grow and with
> that we will end up disabling the whole fs related testing on embedded
> boards with a little disk space. If we tracked that per filesystem we
> would be able to skip a subset of filesystems when there is not enough
> space. The downside is obviously that we would have to add a bit more
> complexity to the test library.

Maybe I could for start rewrite v2 (I've sent it without Cc kernel devs now it's
mainly LTP internal thing) as it just to have 300 MB for XFS and 256 MB for the
rest. That would require to specify filesystem when acquiring device (NULL would
be for the default filesystem), that's would be worth if embedded folks counter
each MB. It'd be nice to hear from them.

Kind regards,
Petr
