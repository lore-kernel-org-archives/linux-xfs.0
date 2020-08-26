Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA920C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 18:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB3D2078D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 18:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="bmi0CLc7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgHZSem (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 14:34:42 -0400
Received: from fanzine.igalia.com ([178.60.130.6]:37969 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHZSem (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 14:34:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=/hZsxkMu//hdGcZkF5Nm74Qa9GNadrEHHn2DxAUVZIU=;
        b=bmi0CLc7gmloG25iu/MacY9fKilBV5Nr4ohkoFSXdpWnKCDDLjx/QC6KwXFp6S31dCWTw0876dfiJC+JWHR4W/YpTiGyOlmGQ7QSlVgUjrE5nwD4ycQLQWtmxOeDqH2QFagkrhbZCepO44yHFL+fTuDxAHqJ4jDW2ua1HJrYNOU8K1WMcIJ2KY3OCVqv82Yd/d46cFqMy+/qlKoW5oCqPCOqEf/FDpAaBAsB3OlWjkUGo9EUyIpXDr3mWGktuk4naoyjXGd5P+dnwQk8my8mFv9L4mWreppAPHn9PX/IVtPjLyL7GEUvonKeiK+QssAeFZ8lNAlouthQJg5uL0rVxQ==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1kB0Fk-0007fI-GJ; Wed, 26 Aug 2020 20:34:32 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1kB0Fk-00026U-6m; Wed, 26 Aug 2020 20:34:32 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, Kevin Wolf <kwolf@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero cluster
In-Reply-To: <20200825194724.GA338144@bfoster>
References: <20200819175300.GA141399@bfoster> <w51v9hdultt.fsf@maestria.local.igalia.com> <20200820215811.GC7941@dread.disaster.area> <20200821110506.GB212879@bfoster> <w51364gjkcj.fsf@maestria.local.igalia.com> <w51zh6oi4en.fsf@maestria.local.igalia.com> <20200821170232.GA220086@bfoster> <w51d03evrol.fsf@maestria.local.igalia.com> <20200825165415.GB321765@bfoster> <w51d03etzj8.fsf@maestria.local.igalia.com> <20200825194724.GA338144@bfoster>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Wed, 26 Aug 2020 20:34:32 +0200
Message-ID: <w51wo1l6ytj.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue 25 Aug 2020 09:47:24 PM CEST, Brian Foster <bfoster@redhat.com> wrote:
> My fio fallocates the entire file by default with this command. Is that
> the intent of this particular test? I added --fallocate=none to my test
> runs to incorporate the allocation cost in the I/Os.

That wasn't intentional, you're right, it should use --fallocate=none (I
don't see a big difference in my test anyway).

>> The Linux version is 4.19.132-1 from Debian.
>
> Thanks. I don't have LUKS in the mix on my box, but I was running on a
> more recent kernel (Fedora 5.7.15-100). I threw v4.19 on the box and
> saw a bit more of a delta between XFS (~14k iops) and ext4 (~24k). The
> same test shows ~17k iops for XFS and ~19k iops for ext4 on v5.7. If I
> increase the size of the LVM volume from 126G to >1TB, ext4 runs at
> roughly the same rate and XFS closes the gap to around ~19k iops as
> well. I'm not sure what might have changed since v4.19, but care to
> see if this is still an issue on a more recent kernel?

Ok, I gave 5.7.10-1 a try but I still get similar numbers.

Perhaps with a larger filesystem there would be a difference? I don't
know.

Berto
