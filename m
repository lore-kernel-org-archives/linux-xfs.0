Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 19:08:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U281b0022272
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 19:08:03 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC9A899FD4B
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 19:09:38 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 5cX161WHQaVFGuGp for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 19:09:38 -0700 (PDT)
Date: Tue, 30 Sep 2008 12:09:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] XFS: Account for allocated blocks when expanding
	directories
Message-ID: <20080930020934.GC16064@disturbed>
References: <1222737924-18884-1-git-send-email-david@fromorbit.com> <48E184E0.4020301@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E184E0.4020301@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs@oss.sgi.com, kevin@kevinjamieson.com

On Tue, Sep 30, 2008 at 11:46:08AM +1000, Mark Goodwin wrote:
> Hi Dave,
>
> by the looks of it, this is a proposed fix for the bug reported
> by Kevin Jamieson (and others in the past) :
>
> "xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c"

Yes, it's the main fix needed.

> Do you (or Kevin or anyone) have a reliable test case to reproduce
> this?

Sure - the metadump image that Kevin sent us a pointer to reproduces
it precisely. i.e:

# echo 255 > /proc/sys/fs/xfs/panic_mask
# mount /dev/ubd/5 /mnt/xfs
# cd /mnt/xfs/*/nerd/run1/*5st1\-
# touch aaaaaaaa

<shutdown>

With the patch I posted, it doesn't shut down any more and the
create succeeds. The patch has passed through xfsqa a couple of
times now....

Of the list of things I posted after analysing the problem,
this patch addresses item 1, via the indirect method noted in
item 2, and I've covered all the expansion cases (I think) in the
directory code (item 3).

Item 4 and 5 are less critical given that I don't think they can
cause shutdowns now that the directory reserved block accounting
is correct.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
