Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6530BC3F2CE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 03:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 431862468D
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 03:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgCBDK1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 22:10:27 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57119 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbgCBDK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Mar 2020 22:10:27 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8F34A3A1969;
        Mon,  2 Mar 2020 14:10:25 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8bTL-00061Y-Pz; Mon, 02 Mar 2020 14:10:23 +1100
Date:   Mon, 2 Mar 2020 14:10:23 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_admin: revert online label setting ability
Message-ID: <20200302031023.GI10776@dread.disaster.area>
References: <db83a9fb-251f-5d7f-921e-80a1c329f343@redhat.com>
 <20200301205531.GD10776@dread.disaster.area>
 <3d7b7a5c-c1bf-1fc9-686e-707165181d07@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d7b7a5c-c1bf-1fc9-686e-707165181d07@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=eXzvKcBt0p5zFmQ6IAMA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 01, 2020 at 03:13:07PM -0600, Eric Sandeen wrote:
> On 3/1/20 12:55 PM, Dave Chinner wrote:
> > On Sun, Mar 01, 2020 at 09:50:03AM -0800, Eric Sandeen wrote:
> >> The changes to xfs_admin which allowed online label setting via
> >> ioctl had some unintended consequences in terms of changing command
> >> order and processing.  It's going to be somewhat tricky to fix, so
> >> back it out for now.
> > 
> > What are the symptoms and behaviour of these "unintended
> > consequences"? And why are they tricky to fix?
> 
> Yeah, I should have probably said more in the commit log.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206429
> 
> was the first clue,
> 
> "xfs_admin can't print both label and UUID for mounted filesystems"
> 
> The main problem is that if /any/ options that trigger xfs_io get specified,
> they are the only ones that get run:
> 
>                 # Try making the changes online, if supported
>                 if [ -n "$IO_OPTS" ] && mntpt="$(find_mntpt_for_arg "$1")"
>                 then
>                         eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
>                         test "$?" -eq 0 && exit 0
>                 fi
> 
> and the non-io / db opts don't get run at all.
> 
> So sure, we could then move on to the db commands, but we actually built them
> all up along the way as well:
> 
>         l)      DB_OPTS=$DB_OPTS" -r -c label"
>                 IO_OPTS=$IO_OPTS" -r -c label"
>                 ;;
> 
> so we'd need to keep those separate, and not re-run them in db.
> 
> And another thing that I struggled with was preserving the order; you'd
> kind of expect that if you specify commands in a certain order 
> they'd be executed in that order, and that used to be true.  Now it's not,
> even if we don't exit in the "if IO_OPTS" case above.
> 
> So I experimented with building up an array of commands, invoking xfs_db
> or xfs_io one command at a time as needed for each, and ... it just got worse
> and worse, TBH.

And there's your new commit message. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
