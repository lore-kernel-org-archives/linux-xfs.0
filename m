Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42596 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754035AbeCFXYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Mar 2018 18:24:31 -0500
Date: Tue, 6 Mar 2018 15:24:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/16] xfs_scrub: don't ask user to run xfs_repair for
 only warnings
Message-ID: <20180306232424.GQ18989@magnolia>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993160036.22223.2742740914776483127.stgit@magnolia>
 <63982341-7cce-68c0-144c-b24b279ddc3f@sandeen.net>
 <20180306172711.GG18989@magnolia>
 <7c273ea8-7d46-b686-481a-016df18a38f0@sandeen.net>
 <20180306185343.GH18989@magnolia>
 <0fa61794-39c8-564b-ae68-523eb22ff6f1@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fa61794-39c8-564b-ae68-523eb22ff6f1@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Mar 06, 2018 at 01:00:47PM -0600, Eric Sandeen wrote:
> On 3/6/18 12:53 PM, Darrick J. Wong wrote:
> > On Tue, Mar 06, 2018 at 12:34:20PM -0600, Eric Sandeen wrote:
> 
> ...
> 
> >> My other quibble is that if (scrub ioctl ran && errors remain) is true only
> >> because "-n" was specified, it seems a little odd to instruct the user
> >> to run repair, when the errors may remain only because of -n.  But that's
> >> a separate issue, I guess.
> > 
> > My thought process here is that any time we leave errors behind on the
> > filesystem we should advise the caller to run xfs_repair, whether that's
> > because the caller told us to fix things and we failed, or because the
> > caller trusts xfs_scrub to find the errors but not to fix them and
> > therefore ran xfs_scrub -n.  Either way you have a broken fs and need to
> > repair it.
> > 
> > However, I wonder if you're thinking "the user told (scrub) they didn't
> > want to change anything, so why would we advise the user to run a
> > (repair) tool that changes things"?
> 
> I guess my thinking is that in reality the user has two options and the
> tool is issuing a specific instruction to use only one of them.  I don't
> think we can guess what the user does or doesn't trust.
> 
> Perhaps just something along the lines of
> 
>         if (ctx->need_repair) {
>                 fprintf(stderr, _("%s: Unmount and run xfs_repair.\n"),
>                                 ctx->mntpoint);

"need_repair" has been changed to "scrub_setup_succeeded".

>                 if (ctx->mode = SCRUB_MODE_DRY_RUN)
>                         fprintf(stderr, _("%s: Or, re-run without '-n'.\n"),
>                                         ctx->mntpoint);

I'll do that, but not until the patch that adds fs repair
functionality to xfs_scrub.

--D

>         }
> 
> or whatever ordering/phrasing makes sense?
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
