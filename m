Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:40536 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdISD61 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 23:58:27 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 4/7] xfs: Implement fallocate query support mode
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
        <1505749947-26360-5-git-send-email-lczerner@redhat.com>
        <20170918175651.GA7937@infradead.org>
Date: Tue, 19 Sep 2017 12:28:03 +0900
In-Reply-To: <20170918175651.GA7937@infradead.org> (Christoph Hellwig's
        message of "Mon, 18 Sep 2017 10:56:51 -0700")
Message-ID: <8760cfbc58.fsf@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

I myself

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

to [5/7] fat part though,

> That being said, I really detest adding weird query modes to random
> syscalls.  We should expose capabilities through the interface that
> was designed for such things: (f)pathconf, as there are a lot more
> important parameters we currently fail to expose to userspace to
> start with.

This is true. For example, max link count. And it might be able to use
for fs's bug/issue detection too (in past, userland has to add
workaround for all cases, because noway to detect the buggy or not).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
