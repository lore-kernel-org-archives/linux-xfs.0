Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:38482 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753541AbdHUTwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 15:52:49 -0400
Received: by mail-vk0-f50.google.com with SMTP id l132so7047022vke.5
        for <linux-xfs@vger.kernel.org>; Mon, 21 Aug 2017 12:52:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170821190414.long2535xppcxvvd@breakpoint.cc>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 21 Aug 2017 13:52:48 -0600
Message-ID: <CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com>
Subject: Re: Support for data CRC
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: xfs list <linux-xfs@vger.kernel.org>

On Mon, Aug 21, 2017 at 1:04 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> Hi,
>
> my understanding is that only metadata is protected by CRC in the new
> on-disk format. Are there any plans to also protect data?

See dm-integrity, merged as of 4.12 kernel. I haven't seen any
performance benchmarking so far.

-- 
Chris Murphy
