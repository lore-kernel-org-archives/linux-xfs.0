Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D2DBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 16:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiCQQpO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 12:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiCQQpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 12:45:13 -0400
Received: from yehat.aphroland.org (yehat.aphroland.org [64.62.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2767217155A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 09:43:57 -0700 (PDT)
Received: by yehat.aphroland.org (Postfix, from userid 1010)
        id 0693D141D; Thu, 17 Mar 2022 09:43:57 -0700 (PDT)
Received: from roundcube.linuxpowered.net (localhost [127.0.0.1])
        by yehat.aphroland.org (Postfix) with ESMTP id B94B9A6E
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 09:43:55 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 17 Mar 2022 09:43:55 -0700
From:   nate <linux-xfs@linuxpowered.net>
To:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink copy to different filesystem performance question
In-Reply-To: <20220316222304.GR3927073@dread.disaster.area>
References: <2cbd42b3bb49720d53ccca3d19d2ae72@linuxpowered.net>
 <20220316083333.GQ3927073@dread.disaster.area>
 <e99689e6c1232ffb564b0c2aecd8b0dd@linuxpowered.net>
 <20220316222304.GR3927073@dread.disaster.area>
Message-ID: <3d9539b0f931cbb28dc26d68806f0b11@linuxpowered.net>
X-Sender: linux-xfs@linuxpowered.net
User-Agent: Roundcube Webmail/1.3.9
X-Sanitizer: This message has been sanitized!
X-Sanitizer-URL: http://mailtools.anomy.net/
X-Sanitizer-Rev: $Id: Sanitizer.pm,v 1.94 2006/01/02 16:43:10 bre Exp $
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022-03-16 15:23, Dave Chinner wrote:
> reflink is not dedupe. file clones simply make a copy by reference,
> so it doesn't duplicate the data in the first place. IOWs, it ends
> up with a single physical copy that has multiple references to it.
> 
> dedupe is done by a different operation, which requires comparing
> the data in two different locations and if they are the same
> reducing it to a single physical copy with multiple references.

Yeah sorry I didn't phrase that statement right but I understand
the situation.

> IIUC, you are asking about whether you can run a reflink copy on
> the destination before you run rsync, then do a delta sync using
> rsync to only move the changed blocks, so only store the changed
> blocks in the backup image?
> 
> If so, then yes. This is how a reflink-based file-level backup farm
> would work. It is very similar to a hardlink based farm, but instead
> of keeping a repository of every version of the every file that is
> backed up in an object store and then creating the directory
> structure via hardlinks to the object store, it creates the new
> directory structure with reflink copies of the previous version and
> then does delta updates to the files directly.

ok thanks


> I haven't confirmed anything, just made a guess same as you have.

Well good enough for me thanks anyway!


> That sounds more like the dedupe process searching for duplicate
> blocks to dedupe....

I think so too.

> You can use FIEMAP (filefrag(1) or xfs_bmap(8)) to tell you if a
> specific extent is shared or not. But it cannot tell you how many
> references there are to it, nor what file those references belong
> to. For that, you need root permissions, ioctl_getfsmap(2) and
> rmapbt=1 support in your filesystem.

Sounds more complex than I would like to deal with.

> Unless you have an immediate use for filesystem metadata level
> introspection (generally unlikely), there's no need to enable it.

ok thanks for the info.

I am leaving the list now, thanks a bunch for the replies.

nate
