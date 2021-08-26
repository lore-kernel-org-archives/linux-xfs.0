Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C02C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 02:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11DF7610C9
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Aug 2021 02:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhHZCH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 22:07:26 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:43974 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbhHZCH0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Aug 2021 22:07:26 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 2EAFB61C4B
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 12:06:38 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id DxcvWOdQm_Be for <linux-xfs@vger.kernel.org>;
        Thu, 26 Aug 2021 12:06:38 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id C5B2D61C5D
        for <linux-xfs@vger.kernel.org>; Thu, 26 Aug 2021 12:06:37 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id AEE12680468; Thu, 26 Aug 2021 12:06:37 +1000 (AEST)
Date:   Thu, 26 Aug 2021 12:06:37 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: XFS fallocate implementation incorrectly reports ENOSPC
Message-ID: <20210826020637.GA2402680@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

As reported by Charles Hathaway here (with no resolution):

XFS fallocate implementation incorrectly reports ENOSPC
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1791323

Given this sequence:

fallocate -l 1GB image.img
mkfs.xfs -f image.img
mkdir mnt
mount -o loop ./image.img mnt
fallocate -o 0 -l 700mb mnt/image.img
fallocate -o 0 -l 700mb mnt/image.img

Why does the second fallocate fail with ENOSPC, and is that considered an 
XFS bug?

Ext4 is happy to do the second fallocate without error.

Tested on linux-5.10.60

Background: I'm chasing a mysterious ENOSPC error on an XFS filesystem 
with way more space than the app should be asking for. There are no quotas 
on the fs. Unfortunately it's a third party app and I can't tell what 
sequence is producing the error, but this fallocate issue is a 
possibility.

Cheers,

Chris
