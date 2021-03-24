Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_05,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B220C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 22:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EA2619C7
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 22:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhCXWSX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:18:23 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:45818 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbhCXWRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 18:17:53 -0400
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Mar 2021 18:17:53 EDT
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id 12OM5UE7099247
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 15:05:32 -0700
Message-ID: <605BB7AA.4050500@tlinx.org>
Date:   Wed, 24 Mar 2021 15:05:30 -0700
From:   L A Walsh <xfs@tlinx.org>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: xfsdump | xfsrestore resulting in files->orphanage
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

copying a disk to a replacing disk I am using
xfsdump on the fromdir and xfsrestore on the todir.

I finish another disk a short while ago with no probs, but this
disk starts out with a weird message from xfsdump:


xfsdump: NOTE: root ino 192 differs from mount dir ino 256, bind mount?

Then later, when it starts restoring files on the target,
all the files end up in the orphanage:

xfsrestore: 9278 directories and 99376 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: NOTE: ino 709 salvaging file, placing in 
orphanage/256.0/Library/Music/ Maria/Cover-Inside.jpg
xfsrestore: NOTE: ino 710 salvaging file, placing in 
orphanage/256.0/Library/Music/ Maria/Cover-Outside.jpg

The files look "fine" on the source
Never had a simply "copy" go so wrong...

What might be causing this?

Thanks!
-l


