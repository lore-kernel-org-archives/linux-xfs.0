Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46470 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932105AbeEHUwi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 May 2018 16:52:38 -0400
Subject: Re: [PATCH 21/21] xfsprogs: implement the upper half of parent
 pointers
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
 <1525754479-12177-22-git-send-email-allison.henderson@oracle.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f31ce664-7173-7b99-7d65-39abd810a372@sandeen.net>
Date: Tue, 8 May 2018 15:52:37 -0500
MIME-Version: 1.0
In-Reply-To: <1525754479-12177-22-git-send-email-allison.henderson@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>, linux-xfs@vger.kernel.org

On 5/7/18 11:41 PM, Allison Henderson wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> Add ioctl definitions to libxfs, build the necessary helpers into
> libfrog and libhandle to iterate parents (and parent paths), then wire
> up xfs_scrub to be able to query parent pointers from userspace.  The
> goal of this patch is to exercise userspace, and is nowhere near a
> complete solution.  A basic xfs_io parent command implementation
> replaces ... whatever that is that's there now.

I wonder if it'd be better to send a patch to nuke the current parent code,
and then another to add back something that works.  Same result in the end,
but it doesn't look like you're trying to fix old code; the patch itself is
pretty meaningless since it diffs against nonfunctional(?) code.

Not a huge deal, just a thought.

-Eric
