Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CAFC54FB9
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Nov 2023 21:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjKSVG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Nov 2023 16:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjKSVG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Nov 2023 16:06:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461E7E0
        for <linux-xfs@vger.kernel.org>; Sun, 19 Nov 2023 13:06:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 06E80218E3;
        Sun, 19 Nov 2023 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1700428014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tlmWGPHTiClypbjZsR1mnUkr45CwmPuvcjUfqyL9XIo=;
        b=Pc4dZt2tDleAejApMjjFvC9yhRvUpk+G8d6TSBMsbr23mgLM9SEzXzc2LAyP4cnpXTysr9
        BYSBPAgkm/TnKGWdxguqb4DpOtVeuH+MZiH7U/G9k4zi98ynRBiqS/3j52zetRqWhJV5KD
        y8gay3kPire/F9cwtgtzWhsZDb2thT0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B47081377F;
        Sun, 19 Nov 2023 21:06:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IUWMKO14WmUDPQAAMHmgww
        (envelope-from <ailiop@suse.com>); Sun, 19 Nov 2023 21:06:53 +0000
Date:   Sun, 19 Nov 2023 22:06:53 +0100
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Martin Steigerwald <martin@lichtvoll.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfsprogs-6.5.0 with grub 2.12~rc1-12: unknown filesystem
Message-ID: <ZVp47fergtXq8CzX@technoir>
References: <4545292.LvFx2qVVIh@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4545292.LvFx2qVVIh@lichtvoll.de>
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [6.26 / 50.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM_SHORT(3.00)[1.000];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[suse.com:s=susede1];
         RCPT_COUNT_TWO(0.00)[2];
         NEURAL_SPAM_LONG(3.50)[1.000];
         FUZZY_BLOCKED(0.00)[rspamd.com];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_NOT_FQDN(0.50)[];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         BAYES_HAM(-0.64)[82.37%]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 19, 2023 at 09:16:20PM +0100, Martin Steigerwald wrote:
> Hi!
> 
> On recovering from some crazy filesystem corruption, probably related to 
> "thou shalt not resume from this hibernation image" (posts on linux-btrfs 
> mailing list, I can share link if curious), gladly no loss of important 
> data involved, I recreated XFS based /boot with
> 
> xfsprogs-6.5.0 (12 Oct 2023)
> […]
>         mkfs: enable reverse mapping by default (Darrick J. Wong)
>         mkfs: enable large extent counts by default (Darrick J. Wong)
> 
> After that GRUB started being funny on me:
> 
> update-grub => grub-mkconfig and grub-install both told me:
> 
> unknown filesystem
> 
> grub-probe revealed that grub did not like to recognize new XFS based
> /boot filesystem. So /boot is Ext4 now. I don't really care.
> 
> This is with grub 2.12~rc1-12 on Devuan Ceres.
> 
> I read on internet that similar funny stuff happened as Ext4 gained 
> features. Could this be the case here as well?

Yes this is due to enabling the large extent counts (nrext64) feature.

> Is this a known issue? I bet it needs a bug report to the GRUB developers?

See:
https://lore.kernel.org/grub-devel/20231026095339.31802-1-ailiop@suse.com/

Regards,
Anthony
