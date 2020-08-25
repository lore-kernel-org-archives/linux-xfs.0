Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730FEC433E4
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 14:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C4120665
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 14:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgHYODo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 10:03:44 -0400
Received: from sandeen.net ([63.231.237.45]:52000 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgHYN7m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Aug 2020 09:59:42 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A4AE31435;
        Tue, 25 Aug 2020 08:59:30 -0500 (CDT)
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
To:     Dave Chinner <david@fromorbit.com>,
        Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824225533.GA12131@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
Date:   Tue, 25 Aug 2020 08:59:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200824225533.GA12131@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/24/20 5:55 PM, Dave Chinner wrote:
> I agree that mkfs needs to be aware of DAX capability of the block
> device, but that capability existing should not cause mkfs to fail.
> If we want users to be able to direct mkfs to to create a DAX
> capable filesystem then adding a -d dax option would be a better
> idea. This would direct mkfs to align/size all the data options to
> use a DAX compatible topology if blkid supports reporting the DAX
> topology. It would also do things like turn off reflink (until that
> is supported w/ DAX), etc.
> 
> i.e. if the user knows they are going to use DAX (and they will)
> then they can tell mkfs to make a DAX compatible filesystem.

FWIW, Darrick /just/ added a -d daxinherit option, though all it does
now is set the inheritable dax flag on the root dir, it doesn't enforce
things like page vs block size, etc.

That change is currently staged in my local tree.

I suppose we could condition that on other requirements, although we've
always had the ability to mkfs a filesystem that can't necessarily be
used on the current machine - i.e. you can make a 64k block size filesystem
on a 4k page machine, etc.  So I'm not sure we want to tie mkfs abilities
to the current mkfs environment....

Still, I wonder if I should hold off on "-d daxinherit" patch until we
have thought through things like reflink conflicts, for now.

(though again, mkfs is "perfectly capapable" of making a consistent
reflink+dax filesystem, it's just that no kernel can mount it today...)

-Eric
