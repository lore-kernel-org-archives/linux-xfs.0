Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969F7C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 11:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbiHRL2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 07:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244127AbiHRL2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 07:28:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8C19C27
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 04:28:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B60985BDFE;
        Thu, 18 Aug 2022 11:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660822109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=52uM/uWZ0VDt/vom63V5uOWSqqnIVymzuJcqNwduUUM=;
        b=wH/pfHMcz3SdjBxU7xNRUJcP3u9UBAYOiSGUoqty0Yl7nIO2BKsmTJTf76fOHitcsHJp/h
        XMyukHYsPsZmd8vg3pUW7SKk3fptp/3ZmaKR+tRDBfQmUnVHVU4yipLyC8sLbbWphy1O9B
        u+aRxsbkSEOI8l2acq2bawZDaT1mvHc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660822109;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=52uM/uWZ0VDt/vom63V5uOWSqqnIVymzuJcqNwduUUM=;
        b=BxUxoSzLImBa9WhqR9MUvGub1N+YrwQQcoPHdZwi6gO5wgqtqvplDUb9y3hQCpNQHAmNgl
        CWig8EJ1uwvyeoCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D796139B7;
        Thu, 18 Aug 2022 11:28:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IGDwJV0i/mJILAAAMHmgww
        (envelope-from <chrubis@suse.cz>); Thu, 18 Aug 2022 11:28:29 +0000
Date:   Thu, 18 Aug 2022 13:30:26 +0200
From:   Cyril Hrubis <chrubis@suse.cz>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
        Martin Doucha <mdoucha@suse.cz>,
        automated-testing@yoctoproject.org,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        automated-testing@lists.yoctoproject.org
Subject: Re: [RFC PATCH 1/1] API: Allow to use xfs filesystems < 300 MB
Message-ID: <Yv4i0gWiHTkfWB5m@yuki>
References: <20220817204015.31420-1-pvorel@suse.cz>
 <Yv4MBF79PnJKJbwm@yuki>
 <Yv4eiT5L+M7dMkQ5@pevik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv4eiT5L+M7dMkQ5@pevik>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi!
> > I'm starting to wonder if we should start tracking minimal FS size per
> > filesystem since btrfs and xfs will likely to continue to grow and with
> > that we will end up disabling the whole fs related testing on embedded
> > boards with a little disk space. If we tracked that per filesystem we
> > would be able to skip a subset of filesystems when there is not enough
> > space. The downside is obviously that we would have to add a bit more
> > complexity to the test library.
> 
> Maybe I could for start rewrite v2 (I've sent it without Cc kernel devs now it's
> mainly LTP internal thing) as it just to have 300 MB for XFS and 256 MB for the
> rest. That would require to specify filesystem when acquiring device (NULL would
> be for the default filesystem), that's would be worth if embedded folks counter
> each MB. It'd be nice to hear from them.

The 256MB limit was set previously due to btrfs, I bet that we can
create smaller images for ext filesytems for example.

-- 
Cyril Hrubis
chrubis@suse.cz
