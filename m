Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E68BC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 18:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BFA6347B
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Nov 2021 18:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243056AbhKOS4U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:56:20 -0500
Received: from sandeen.net ([63.231.237.45]:51432 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243256AbhKOSyS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Nov 2021 13:54:18 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CB9C24910;
        Mon, 15 Nov 2021 12:50:58 -0600 (CST)
Message-ID: <0943b4ba-73a2-fab4-0ba5-826e0a8d0a37@sandeen.net>
Date:   Mon, 15 Nov 2021 12:51:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Sean Caron <scaron@umich.edu>, linux-xfs@vger.kernel.org
References: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Question regarding XFS crisis recovery
In-Reply-To: <CAA43vkU_X5Ss0uiKwji3eOPSo00-t-UGO-hNnAUy7-Wuyuce-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/15/21 11:14 AM, Sean Caron wrote:
> I guess, after blowing through four or five "Hope you have a backup,
> but if not, you can try this and pray" checkpoints, I just want to
> check with the developers and group here to see if we did the best
> thing possible given the circumstances?

Overall I suppose that what you did sounds reasonable, unless I'm missing
something about the MD raid state. Having that many drives failing out
sounds bad.  Any idea how many blocks got skipped with your dd clone?

> Xfs_repair is it, right? When things are that scrambled, pretty much
> all you can do is run an xfs_repair and hope for the best? Am I
> correct in thinking that there is no better or alternative tool that
> will give different results?

well ... from the xfs POV, yes, but xfs_repair is not a data recovery tool,
it is designed to make the filesystem consistent again, not to recover
all data.  (that might sound a bit glib, but while repair obviously tries
to salvage/correct what it can, in the end, the goal is consistency.)

There's not much xfs_repair can do if the block device has been severely
scrambled beneath it.

> Can a commercial data recovery service make any better sense of a
> scrambled XFS than xfs_repair could? When the underlying device is
> presenting OK, just scrambled data on it?

maybe? :) not sure, personally. I have never used a data recovery service.

Sorry for your data loss. I'd suggest asking these questions of the
md raid folks as well, because I think that's where your problems started,
and frankly xfs / xfs_repair may have been handed an impossible task.

(Not blaming md; perhaps the hardware failure made this all inevitable,
but maybe they md devs thoughts on your recovery attempts.)

-Eric
