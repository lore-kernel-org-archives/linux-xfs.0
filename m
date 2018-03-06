Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbeCFSxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 13:53:50 -0500
Date: Tue, 6 Mar 2018 10:53:43 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/16] xfs_scrub: don't ask user to run xfs_repair for
 only warnings
Message-ID: <20180306185343.GH18989@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993160036.22223.2742740914776483127.stgit@magnolia>
 <63982341-7cce-68c0-144c-b24b279ddc3f@sandeen.net>
 <20180306172711.GG18989@magnolia>
 <7c273ea8-7d46-b686-481a-016df18a38f0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c273ea8-7d46-b686-481a-016df18a38f0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Mar 06, 2018 at 12:34:20PM -0600, Eric Sandeen wrote:
> 
> 
> On 3/6/18 11:27 AM, Darrick J. Wong wrote:
> > On Tue, Mar 06, 2018 at 11:16:50AM -0600, Eric Sandeen wrote:
> >>
> >>
> >> On 3/1/18 1:13 PM, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>>
> >>> Don't advise the user to run xfs_repair on a filesystem that triggers
> >>> warnings but no errors; there's no corruption for it to fix.
> >>>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> I went looking for why ->need_repair is set if repair isn't needed, and:
> >>
> >> C symbol: need_repair
> >>
> >>   File              Function	   Line
> >> 0 scrub/xfs_scrub.h <global>        98 bool need_repair;
> >> 1 scrub/phase1.c    xfs_setup_fs   239 ctx->need_repair = true;
> >> 2 scrub/xfs_scrub.c report_outcome 517 if (ctx->need_repair)
> >>
> >> um, when is ->need_repair ever false?  What am I missing?
> > 
> > In main():
> > 
> > struct scrub_ctx	ctx = {0};
> > 
> > ctx.need_repair is false from the start of the program until the end of
> > phase 1 when we've decided that yes we can check this xfs filesystem.
> 
> Ok so after more looking & discussion, what ->need_repair really means
> is "we got far enough to run the scrub ioctl?"
> 
> If that's true, and errors remain for any reason (?), the user is told
> to run repair.
> 
> So while I see that this patch improves the user experience, I wonder
> if we shouldn't take this opportunity to improve the developer experience
> by renaming ->need_repair to ->scrub_ran or something, because I think
> that makes a bit more sense semantically:
> 
> if (scrub ioctl ran && errors remain)
> 	tell_user("run repair")

Ok.  I'll update the name.

> My other quibble is that if (scrub ioctl ran && errors remain) is true only
> because "-n" was specified, it seems a little odd to instruct the user
> to run repair, when the errors may remain only because of -n.  But that's
> a separate issue, I guess.

My thought process here is that any time we leave errors behind on the
filesystem we should advise the caller to run xfs_repair, whether that's
because the caller told us to fix things and we failed, or because the
caller trusts xfs_scrub to find the errors but not to fix them and
therefore ran xfs_scrub -n.  Either way you have a broken fs and need to
repair it.

However, I wonder if you're thinking "the user told (scrub) they didn't
want to change anything, so why would we advise the user to run a
(repair) tool that changes things"?

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
