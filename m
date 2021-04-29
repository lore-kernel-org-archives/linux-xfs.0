Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_20,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B3BC433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 14:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E92C61420
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 14:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhD2OUB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 10:20:01 -0400
Received: from mail.worldserver.net ([217.13.200.37]:51611 "EHLO
        mail.worldserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbhD2OT7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Apr 2021 10:19:59 -0400
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 10:19:58 EDT
Received: from postpony.nebelschwaden.de (v22018114346177759.hotsrv.de [194.55.14.20])
        (Authenticated sender: postmaster@nebelschwaden.de)
        by mail.worldserver.net (Postfix) with ESMTPA id 8FAFB27434
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 16:10:45 +0200 (CEST)
Received: from [172.16.37.5] (kaperfahrt.nebelschwaden.de [172.16.37.5])
        by postpony.nebelschwaden.de (Postfix) with ESMTP id 19D25EB59B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Apr 2021 16:10:45 +0200 (CEST)
To:     xfs <linux-xfs@vger.kernel.org>
Reply-To: listac@nebelschwaden.de
From:   Ede Wolf <listac@nebelschwaden.de>
Subject: current maximum stripe unit size?
Message-ID: <993c93fc-56e7-8c81-8f92-4e203b6e68dd@nebelschwaden.de>
Date:   Thu, 29 Apr 2021 16:10:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

having found different values, as of Kernel 5.10, what is the maximum 
allowed size in K for stripe units?

I came across limits from 64k - 256k, but the documentation  always 
seemed quite aged.

Thanks

Ede
