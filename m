Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55933C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 21:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F54F60E9B
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 21:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhJSVGa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:06:30 -0400
Received: from sandeen.net ([63.231.237.45]:33002 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230190AbhJSVGa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 17:06:30 -0400
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 92E237B9F;
        Tue, 19 Oct 2021 16:03:03 -0500 (CDT)
Message-ID: <6f7d8d49-909a-f9f3-273c-8641eedb5ea2@sandeen.net>
Date:   Tue, 19 Oct 2021 16:04:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <e5d00665-ff40-cd6a-3c5c-a022341c3344@sandeen.net>
 <20211019204418.GZ2361455@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: Small project: Make it easier to upgrade root fs (i.e. to
 bigtime)
In-Reply-To: <20211019204418.GZ2361455@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/19/21 3:44 PM, Dave Chinner wrote:
> On Tue, Oct 19, 2021 at 10:18:31AM -0500, Eric Sandeen wrote:
>> Darrick taught xfs_admin to upgrade filesystems to bigtime and inobtcount, which is
>> nice! But it operates via xfs_repair on an unmounted filesystem, so it's a bit tricky
>> to do for the root fs.
>>
>> It occurs to me that with the /forcefsck and /fsckoptions files[1], we might be able
>> to make this a bit easier. i.e. touch /forcefsck and add "-c bigtime=1" to /fsckoptions,
>> and then the initrd/initramfs should run xfs_repair with -c bigtime=1 and do the upgrade.
> 
> Does that happen before/after swap is enabled?

Good question, and I don't know.

> What problems can arise from a failed repair here?

In general, we've always said that an aborted repair should leave things
in a not-worse state, I think? As in "repair is safe to cancel?"

I don't know if that holds true on an upgrade path though...

> Also, ISTR historical problems with doing initrd based root fs
> operations because it's not uncommon for the root filesystem to fail
> to cleanly unmount on shutdown.  i.e. it can end up not having the
> unmount record written because shutdown finishes with the superblock
> still referenced. Hence the filesystem has to be mounted and the log
> replayed before repair can be run on it....
> 
>> However ... fsck.xfs doesn't accept that option, and doesn't pass
>> it on to repair, so that doesn't work.
>>
>> It seems reasonable to me for fsck.xfs, when it gets the "-f"
>> option via init, and the special handling we do already to
>> actually Do Something(tm)[2], we could then also pass on any
>> additional options we got via the /fsckoptions method.
>>
>> Does anyone see a problem with this?  If not, would anyone like to
>> take this on as a small project?
> 
> As long as it doesn't result in an unbootable system on failure, it
> sounds like a good idea to me.

The /forcefsck is already honored, so I think the only additional possible
pitfalls would be specifically related to the upgrade path.

But, that upgrade path would encourage more people to make use of it, so...

I guess in general, if we honor forcefsck and translate that into a real
xfs_repair run, it probably makes sense to honor command line options in
general.

-Eric
