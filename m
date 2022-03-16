Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524FEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 22:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCPWYY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 18:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiCPWYX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 18:24:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 720A413D7B
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 15:23:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 80857534178;
        Thu, 17 Mar 2022 09:23:05 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUc2q-006JJB-Pr; Thu, 17 Mar 2022 09:23:04 +1100
Date:   Thu, 17 Mar 2022 09:23:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     nate <linux-xfs@linuxpowered.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS reflink copy to different filesystem performance question
Message-ID: <20220316222304.GR3927073@dread.disaster.area>
References: <2cbd42b3bb49720d53ccca3d19d2ae72@linuxpowered.net>
 <20220316083333.GQ3927073@dread.disaster.area>
 <e99689e6c1232ffb564b0c2aecd8b0dd@linuxpowered.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e99689e6c1232ffb564b0c2aecd8b0dd@linuxpowered.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6232634a
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=WBZUUWWohaiSB4p0PmgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 10:08:30AM -0700, nate wrote:
> On 2022-03-16 1:33, Dave Chinner wrote:
> 
> > Yeah, Veeam appears to use the shared data extent functionality in
> > XFS for deduplication and cloning. reflink is the use facing name
> > for space efficient file cloning (via cp --reflink).
> 
> I read bits and pieces about cp --reflink, I guess using that would be
> a more "standard" *nix way of using dedupe?

reflink is not dedupe. file clones simply make a copy by reference,
so it doesn't duplicate the data in the first place. IOWs, it ends
up with a single physical copy that has multiple references to it.

dedupe is done by a different operation, which requires comparing
the data in two different locations and if they are the same
reducing it to a single physical copy with multiple references.

In the end they look the same on disk (shared physical extent with
multiple references) but the operations are distinctly different.

> For example cp --reflink then
> using rsync to do a delta sync against the new copy(to get the updates?
> Not that I have a need to do this just curious on the workflow.

IIUC, you are asking about whether you can run a reflink copy on
the destination before you run rsync, then do a delta sync using
rsync to only move the changed blocks, so only store the changed
blocks in the backup image?

If so, then yes. This is how a reflink-based file-level backup farm
would work. It is very similar to a hardlink based farm, but instead
of keeping a repository of every version of the every file that is
backed up in an object store and then creating the directory
structure via hardlinks to the object store, it creates the new
directory structure with reflink copies of the previous version and
then does delta updates to the files directly.

> > I'm guessing that you're trying to copy a deduplicated file,
> > resulting in the same physical blocks being read over and over
> > again at different file offsets and causing the disks to seek
> > because it's not physically sequential data.
> 
> Thanks for confirming that, it's what I suspected.

I haven't confirmed anything, just made a guess same as you have.

> [..]
> 
> > Maybe they are doing that with FIEMAP to resolve deduplicated
> > regions and caching them, or they have some other infomration in
> > their backup/deduplication data store that allows them to optimise
> > the IO. You'll need to actually run things like strace on the copies
> > to find out exactly what it is doing....
> 
> ok thanks for the info. I do see a couple of times there are periods of lots
> of disk reads on the source and no writes happening on the destination
> I guess it is sorting through what it needs to get, one of those lasted
> about 20mins.

That sounds more like the dedupe process searching for duplicate
blocks to dedupe....

> > No, they don't exist because largely reading a reflinked file
> > performs no differently to reading a non-shared file.
> 
> Good to know, certainly would be nice if there was at least a way to
> identify a file as having X number of links.

You can use FIEMAP (filefrag(1) or xfs_bmap(8)) to tell you if a
specific extent is shared or not. But it cannot tell you how many
references there are to it, nor what file those references belong
to. For that, you need root permissions, ioctl_getfsmap(2) and
rmapbt=1 support in your filesystem.

> > To do that efficiently (i.e. without a full filesystem scan) you
> > need to look up the filesystem reverse mapping table to find all the
> > owners of pointers to a given block.  I bet you didn't make the
> > filesystem with "-m rmapbt=1" to enable that functionality - nobody
> > does that unless they have a reason to because it's not enabled by
> > default (yet).
> 
> I'm sure I did not do that either, but I can do that if you think it
> would be advantageous. I do plan to ship this DL380Gen10 XFS system to
> another location and am happy to reformat the XFS volume with that extra
> option if it would be useful.

Unless you have an immediate use for filesystem metadata level
introspection (generally unlikely), there's no need to enable it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
