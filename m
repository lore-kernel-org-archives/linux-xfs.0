Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754827AbeFZAkz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jun 2018 20:40:55 -0400
Date: Mon, 25 Jun 2018 17:40:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove deprecated barrier/nobarrier mount options
Message-ID: <20180626004038.GB5711@magnolia>
References: <56f0a68c-9c1b-712a-a0e8-e596f8272561@redhat.com>
 <20180626001620.GA5711@magnolia>
 <77374aad-a84d-9cd0-7a41-f5e8e0595dd2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77374aad-a84d-9cd0-7a41-f5e8e0595dd2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 25, 2018 at 07:34:20PM -0500, Eric Sandeen wrote:
> On 6/25/18 7:16 PM, Darrick J. Wong wrote:
> > On Mon, Jun 25, 2018 at 07:03:57PM -0500, Eric Sandeen wrote:
> >> The barrier mount options have been no-ops and deprecated since
> >>
> >> 4cf4573 xfs: deprecate barrier/nobarrier mount option
> >>
> >> i.e. kernel 4.10 / December 2016, with a stated deprecation schedule
> >> after v4.15.  Should be fair game to remove them now.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  Documentation/filesystems/xfs.txt |    4 ++--
> >>  fs/xfs/xfs_mount.h                |    1 -
> >>  fs/xfs/xfs_super.c                |   34 ++++------------------------------
> >>  3 files changed, 6 insertions(+), 33 deletions(-)
> >>
> >>
> >> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> >> index 4d9ff0a..07dbd4e 100644
> >> --- a/Documentation/filesystems/xfs.txt
> >> +++ b/Documentation/filesystems/xfs.txt
> >> @@ -223,8 +223,6 @@ Deprecated Mount Options
> >>  
> >>    Name				Removal Schedule
> >>    ----				----------------
> >> -  barrier			no earlier than v4.15
> >> -  nobarrier			no earlier than v4.15
> >>  
> >>  
> >>  Removed Mount Options
> >> @@ -236,6 +234,8 @@ Removed Mount Options
> >>    ihashsize			v4.0
> >>    irixsgid			v4.0
> >>    osyncisdsync/osyncisosync	v4.0
> >> +  barrier			v4.18
> >> +  nobarrier			v4.18
> > 
> > I'm not removing mount options this far into the 4.18 cycle. ;)
> > 
> > 4.19, perhaps?
> 
> Yeah I kinda figured.  Resend V2 later?  Edit on the way in and stash it
> for a while?  V2 now?

v2 now, I'll stuff it in the 4.19 branch when I get around to creating
it......

--D

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
