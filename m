Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62969 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdFSNv1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jun 2017 09:51:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 70FD7C06586F
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2017 13:51:27 +0000 (UTC)
Date: Mon, 19 Jun 2017 09:51:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170619135120.GD25516@bfoster.bfoster>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616105445.3314-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 16, 2017 at 12:54:43PM +0200, Carlos Maiolino wrote:
> Hi,
> 
> there goes a new version of this patchset based on previous reviews on V3.
> 
> Changelogs added separated to each patch.
> 

Hi Carlos,

I pointed out the last things that I'm aware of that I think need to be
fixed in this series (along with a few nits here and there). That said,
it's already been pointed out that we probably want an xfstests test
case to go along with this before it would be merged. Is that something
you are still planning on?

I'd actually like to take this a bit farther than a regression test and
see if we can improve our ability to test the error handling code in
general. What do you (or anybody else..) think about including a patch
in this series that introduces the ability to inject metadata writeback
errors on DEBUG kernels? For example, consider something that just sets
b_error at the top of xfs_buf_iodone_callbacks() based on a random value
and configurable error frequency. This could use XFS_TEST_ERROR() or
something like a new DEBUG sysfs attribute in the error configuration
(see log_badcrc_factor for a similar example).

This would facilitate longer running tests where iodone callback errors
occur randomly and transiently and we can thus actually exercise the
error handling and recovery code. I'd love to run some fsstress testing,
for example, as I'm hoping that would help wring out any further issues
that could be lurking (particularly with the tricky xfs_iflush_done()
logic and whatnot). If implemented generally enough, that could also be
reused for a more simple xfstests regression test for the original
problem (e.g., mount fs, set error frequency = 100%, modify an inode,
set error frequency = 0, umount), albeit it would require debug mode.
Thoughts?

Brian

> 
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
