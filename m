Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53441C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 09:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239604AbiHRJvO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 05:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235407AbiHRJvN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 05:51:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC6DB07C9
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 02:51:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 902283ED3B;
        Thu, 18 Aug 2022 09:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660816271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=izmoBcXZCzoW+ZBOVabeEeedzEn73APgAMt0TLEhuyI=;
        b=yDTNtwzYlIIjPi7c1iVUpoVI2MyUsFqClvSt+JBa0duT6tSLC2PaYa9ZViYywW4EMI5KFG
        x/C/+U6ahzFceEU9vMPumXSYy/Y88fhdSAodnk6A6RekxGKk4TINgynTSany89e+3J2Kfp
        8Je4mm7YIxVF04RjH97I5QIzo306kTM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660816271;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=izmoBcXZCzoW+ZBOVabeEeedzEn73APgAMt0TLEhuyI=;
        b=Oi4CbHmUUC1IhkMVDqDVw1o3Ys86B+4oCvNpO8EX8FrglSXyelgEpyRjX2mCrOE03rT+kk
        ToV0Au3NBN56wLAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A26D139B7;
        Thu, 18 Aug 2022 09:51:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6mhjHI8L/mIlBQAAMHmgww
        (envelope-from <chrubis@suse.cz>); Thu, 18 Aug 2022 09:51:11 +0000
Date:   Thu, 18 Aug 2022 11:53:08 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
        Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [RFC PATCH 1/1] API: Allow to use xfs filesystems < 300 MB
Message-ID: <Yv4MBF79PnJKJbwm@yuki>
References: <20220817204015.31420-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817204015.31420-1-pvorel@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi!
I'm starting to wonder if we should start tracking minimal FS size per
filesystem since btrfs and xfs will likely to continue to grow and with
that we will end up disabling the whole fs related testing on embedded
boards with a little disk space. If we tracked that per filesystem we
would be able to skip a subset of filesystems when there is not enough
space. The downside is obviously that we would have to add a bit more
complexity to the test library.

-- 
Cyril Hrubis
chrubis@suse.cz
