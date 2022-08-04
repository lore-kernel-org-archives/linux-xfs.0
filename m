Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72014C25B06
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 22:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240252AbiHDW7G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 18:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbiHDW6v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 18:58:51 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 047F372EDE
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 15:55:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5FB4710C8CA0;
        Fri,  5 Aug 2022 08:55:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oJjkw-009F2h-5B; Fri, 05 Aug 2022 08:55:54 +1000
Date:   Fri, 5 Aug 2022 08:55:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Emmanouil Vamvakopoulos <emmanouil.vamvakopoulos@ijclab.in2p3.fr>
Cc:     "@pop.gmail.com>" <cem@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: s_bmap and  flags explanation
Message-ID: <20220804225554.GD3600936@dread.disaster.area>
References: <1586129076.70820212.1659538177737.JavaMail.zimbra@ijclab.in2p3.fr>
 <1106593372.70825641.1659538603200.JavaMail.zimbra@ijclab.in2p3.fr>
 <20220803215909.GC3600936@dread.disaster.area>
 <789765075.71120211.1659608731638.JavaMail.zimbra@ijclab.in2p3.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <789765075.71120211.1659608731638.JavaMail.zimbra@ijclab.in2p3.fr>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62ec4e7c
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=hwTY5FewZKcuYIiCvp4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 12:25:31PM +0200, Emmanouil Vamvakopoulos wrote:
> hello Carlos and Dave 
> 
> thank you for the replies
> 
> a) for the mismatch in alignment bewteen xfs  and underlying raid volume I have to re-check 
> but from preliminary tests , when I mount the partition with a static allocsize ( e.g. allocsize=256k)
> we have large file with large number of externs ( up to 40) but the sizes from du was comparable.

As expected - fixing the post-EOF specualtive preallocation to
256kB means almost no consumed space beyond eof so they will always
be close (but not identical) for a non-sparse, non-shared file.

But that begs the question: why are you concerned about large files
consuming slightly more space than expected for a short period of
time?

We've been doing this since commit 055388a3188f ("xfs: dynamic
speculative EOF preallocation") which was committed in January 2011
- over a decade ago - and it's been well known for a couple of
decades before that that ls and du cannot be
relied to match on any filesystem that supports sparse files.

And these days with deduplication/reflink that share extents betwen
files, it's even less useful because du can be correct for every
individual file, but then still report that more blocks are being
used than the filesystem has capacity to store because it reports
shared blocks multiple times...

So why do you care that du and ls are different?

> b) for the speculative preallocation beyond EOF of my files as I understood have to run xfs_fsr to get the space back. 

No, you don't need to do anything, and you *most definitely* do
*not* want to run xfs_fsr to remove it. If you really must remove
specualtive prealloc, then run:

# xfs_spaceman -c "prealloc -m 0" <mntpt>

And that will remove all specualtive preallocation that is current
on all in-memory inodes via an immediate blockgc pass.

If you just want to remove post-eof blocks on a single file, then
find out the file size with stat and truncate it to the same size.
The truncate won't change the file size, but it will remove all
blocks beyond EOF.

*However*

You should not ever need to be doing this as there are several
automated triggers to remove it, all when the filesytem detects
there is no active modification of the file being performed. One
trigger is the last close of a file descriptor, another is the
periodic background blockgc worker, and another is memory reclaim
removing the inode from memory.

In all cases, these are triggers that indicate that the file is not
currently being written to, and hence the speculative prealloc is
not needed anymore and so can be removed.

So you should never have to remove it manually.

> but why the inodes of those files remains dirty  at least for 300 sec  after the  closing of the file and lost the automatic removal of the preallocation ?

What do you mean by "dirty"? A file with post-eof preallocation is
not dirty in any way once the data in the file has been written
back (usually within 30s).

> we are runing on CentOS Stream release 8 with 4.18.0-383.el8.x86_64 
> 
> but we never see something simliar on CentOS Linux release 7.9.2009 (Core) with  3.10.0-1160.45.1.el7.x86_64 
> (for similar pattern of file sizes, but truly with different distributed strorage application)

RHEL 7/CentOS 7 had this same behaviour - it was introduced in
2.6.38. All your observation means is that the application running
on RHEL 7 was writing the files in a way that didn't trigger
speculative prealloc beyond EOF, not that speculative prealloc
beyond EOF didn't exist....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
