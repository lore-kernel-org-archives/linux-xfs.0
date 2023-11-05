Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB476C4332F
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Nov 2023 18:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjKESNN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Nov 2023 13:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjKESNM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2023 13:13:12 -0500
X-Greylist: delayed 549 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Nov 2023 10:13:09 PST
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAACFF
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 10:13:09 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5b2e826a.dip0.t-ipconnect.de [91.46.130.106])
        by mail.itouring.de (Postfix) with ESMTPSA id 6F4BCCF1AE0
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 19:03:56 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 10537F01600
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 19:03:56 +0100 (CET)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: XFS_DEBUG got enabled by default in 6.6
Organization: Applied Asynchrony, Inc.
Message-ID: <308d32cc-4451-ad70-53bc-b41275023e45@applied-asynchrony.com>
Date:   Sun, 5 Nov 2023 19:03:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I recently updated to 6.6 and was surprised to see that XFS_DEBUG suddenly
got enabled by default. This was apparently caused by commit d7a74cad8f45
("xfs: track usage statistics of online fsck") and a followup fix.
Was that intentional? From the description of XFS_DEBUG I gather it should
be disabled for regular use, so this was a bit surprising to see.
Maybe that "default y" setting should be removed.

thanks,
Holger
