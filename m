Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756355AbeAHOIp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 09:08:45 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 809A7155E0
        for <linux-xfs@vger.kernel.org>; Mon,  8 Jan 2018 14:08:45 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61E0760BEC
        for <linux-xfs@vger.kernel.org>; Mon,  8 Jan 2018 14:08:45 +0000 (UTC)
Date: Mon, 8 Jan 2018 09:08:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/7] xfs: inode transaction reservation fixups
Message-ID: <20180108140843.GA41128@bfoster.bfoster>
References: <20171130185836.18481-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130185836.18481-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, Nov 30, 2017 at 01:58:29PM -0500, Brian Foster wrote:
> Hi all,
> 
> Here's v2 of the inode tx reservation fixups. This drops the agfl fixup
> patch for the time being and adds some additional reservation fixups and
> refactoring based on Dave's feedback. This survives xfstests in a few
> different configurations and also happens to survive my inode unlink
> reservation overrun tests.
> 
> Thoughts, reviews, flames appreciated.
> 
> Brian
> 
> v2:
> - Update AGI unlinked list and truncate reservations
> - Update commit log for ifree refactor patch.
> - Additional refactoring patches.
> - Dropped agfl fixup patch.
> v1: https://marc.info/?l=linux-xfs&m=151181428031884&w=2
> 

Ping...

It looks like this is all reviewed, but perhaps just not merged yet (or
I'm just not looking in the right place)..?

Brian

> Brian Foster (7):
>   xfs: print transaction log reservation on overrun
>   xfs: include inobt buffers in ifree tx log reservation
>   xfs: fix up agi unlinked list reservations
>   xfs: truncate transaction does not modify the inobt
>   xfs: include an allocfree res for inobt modifications
>   xfs: refactor inode chunk alloc/free tx reservation
>   xfs: eliminate duplicate icreate tx reservation functions
> 
>  fs/xfs/libxfs/xfs_trans_resv.c | 202 ++++++++++++++++++++---------------------
>  fs/xfs/xfs_log.c               |   4 +-
>  2 files changed, 99 insertions(+), 107 deletions(-)
> 
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
