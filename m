Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D4FC072A2
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Nov 2023 20:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjKSUXM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Nov 2023 15:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKSUXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Nov 2023 15:23:12 -0500
X-Greylist: delayed 404 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 19 Nov 2023 12:23:08 PST
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF446C6
        for <linux-xfs@vger.kernel.org>; Sun, 19 Nov 2023 12:23:08 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 6597381755A
        for <linux-xfs@vger.kernel.org>; Sun, 19 Nov 2023 21:16:20 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-xfs@vger.kernel.org
Subject: xfsprogs-6.5.0 with grub 2.12~rc1-12: unknown filesystem
Date:   Sun, 19 Nov 2023 21:16:20 +0100
Message-ID: <4545292.LvFx2qVVIh@lichtvoll.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi!

On recovering from some crazy filesystem corruption, probably related to 
"thou shalt not resume from this hibernation image" (posts on linux-btrfs 
mailing list, I can share link if curious), gladly no loss of important 
data involved, I recreated XFS based /boot with

xfsprogs-6.5.0 (12 Oct 2023)
[…]
        mkfs: enable reverse mapping by default (Darrick J. Wong)
        mkfs: enable large extent counts by default (Darrick J. Wong)

After that GRUB started being funny on me:

update-grub => grub-mkconfig and grub-install both told me:

unknown filesystem

grub-probe revealed that grub did not like to recognize new XFS based
/boot filesystem. So /boot is Ext4 now. I don't really care.

This is with grub 2.12~rc1-12 on Devuan Ceres.

I read on internet that similar funny stuff happened as Ext4 gained 
features. Could this be the case here as well?

Is this a known issue? I bet it needs a bug report to the GRUB developers?

Sometimes I like booting to be simpler than that. *Much* *simpler* *than* 
*that*. With less moving parts that could do crazy things.

Reminder to self: Don't start crazy experimentation adventures like 
"trying out BCacheFS with some 6.7-almost-rc2-i-dont-like-to-hibernate- 
kernel" (well the BCacheFS part of the adventure basically worked as 
expected as far as I can tell).

Ciao,
-- 
Martin


