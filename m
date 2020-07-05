Return-Path: <SRS0=iu4H=AQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B434C433E0
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 20:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E26482073E
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jul 2020 20:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgGEUfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jul 2020 16:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbgGEUfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 16:35:39 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B03C061794;
        Sun,  5 Jul 2020 13:35:39 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id DE4F0739;
        Sun,  5 Jul 2020 20:35:38 +0000 (UTC)
Date:   Sun, 5 Jul 2020 14:35:37 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] doc: cgroup: add f2fs and xfs to supported list for
 writeback
Message-ID: <20200705143537.68055b16@lwn.net>
In-Reply-To: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
References: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 29 Jun 2020 14:08:09 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> f2fs and xfs have both added support for cgroup writeback:
> 
> 578c647 f2fs: implement cgroup writeback support
> adfb5fb xfs: implement cgroup aware writeback
> 
> so add them to the supported list in the docs.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> TBH I wonder about the wisdom of having this detail in
> the doc, as it apparently gets missed quite often ...

Good question, but as long as it's there it might as well be correct;
applied, thanks.

jon
