Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C53FC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 17:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235033AbiCPRJs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbiCPRJr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 13:09:47 -0400
Received: from yehat.aphroland.org (yehat.aphroland.org [64.62.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 839A1201B6
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:08:31 -0700 (PDT)
Received: by yehat.aphroland.org (Postfix, from userid 1010)
        id DAD5F141D; Wed, 16 Mar 2022 10:08:31 -0700 (PDT)
Received: from roundcube.linuxpowered.net (localhost [127.0.0.1])
        by yehat.aphroland.org (Postfix) with ESMTP id 9FE60A6E
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:08:30 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Mar 2022 10:08:30 -0700
From:   nate <linux-xfs@linuxpowered.net>
To:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink copy to different filesystem performance question
In-Reply-To: <20220316083333.GQ3927073@dread.disaster.area>
References: <2cbd42b3bb49720d53ccca3d19d2ae72@linuxpowered.net>
 <20220316083333.GQ3927073@dread.disaster.area>
Message-ID: <e99689e6c1232ffb564b0c2aecd8b0dd@linuxpowered.net>
X-Sender: linux-xfs@linuxpowered.net
User-Agent: Roundcube Webmail/1.3.9
X-Sanitizer: This message has been sanitized!
X-Sanitizer-URL: http://mailtools.anomy.net/
X-Sanitizer-Rev: $Id: Sanitizer.pm,v 1.94 2006/01/02 16:43:10 bre Exp $
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022-03-16 1:33, Dave Chinner wrote:

> Yeah, Veeam appears to use the shared data extent functionality in
> XFS for deduplication and cloning. reflink is the use facing name
> for space efficient file cloning (via cp --reflink).

I read bits and pieces about cp --reflink, I guess using that would be
a more "standard" *nix way of using dedupe? For example cp --reflink 
then
using rsync to do a delta sync against the new copy(to get the updates?
Not that I have a need to do this just curious on the workflow.

> I'm guessing that you're trying to copy a deduplicated file,
> resulting in the same physical blocks being read over and over again
> at different file offsets and causing the disks to seek because it's
> not physically sequential data.

Thanks for confirming that, it's what I suspected.

[..]

> Maybe they are doing that with FIEMAP to resolve deduplicated
> regions and caching them, or they have some other infomration in
> their backup/deduplication data store that allows them to optimise
> the IO. You'll need to actually run things like strace on the copies
> to find out exactly what it is doing....

ok thanks for the info. I do see a couple of times there are periods of 
lots
of disk reads on the source and no writes happening on the destination
I guess it is sorting through what it needs to get, one of those lasted
about 20mins.

> No, they don't exist because largely reading a reflinked file
> performs no differently to reading a non-shared file.

Good to know, certainly would be nice if there was at least a way to
identify a file as having X number of links.

> To do that efficiently (i.e. without a full filesystem scan) you
> need to look up the filesystem reverse mapping table to find all the
> owners of pointers to a given block.  I bet you didn't make the
> filesystem with "-m rmapbt=1" to enable that functionality - nobody
> does that unless they have a reason to because it's not enabled by
> default (yet).

I'm sure I did not do that either, but I can do that if you think it
would be advantageous. I do plan to ship this DL380Gen10 XFS system to
another location and am happy to reformat the XFS volume with that extra
option if it would be useful.

I don't anticipate needing to deal directly with this reflinked data,
just let Veeam do it's thing. Thanks for clearing things up for
me so quickly!

nate

