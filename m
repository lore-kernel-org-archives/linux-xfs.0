Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65035C3F2D1
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 01:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383B82465E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 01:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCCBSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 20:18:12 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55607 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726752AbgCCBSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 20:18:12 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3FB197E8D52;
        Tue,  3 Mar 2020 12:18:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j8wCH-0005Jr-9f; Tue, 03 Mar 2020 12:18:09 +1100
Date:   Tue, 3 Mar 2020 12:18:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs_admin: revert online label setting ability
Message-ID: <20200303011809.GQ10776@dread.disaster.area>
References: <db83a9fb-251f-5d7f-921e-80a1c329f343@redhat.com>
 <b4d2d6cf-dbae-2a2e-7580-3b6fd13aad9a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4d2d6cf-dbae-2a2e-7580-3b6fd13aad9a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=szuWVjIbUXDjSIgQpHsA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 02, 2020 at 08:35:02AM -0600, Eric Sandeen wrote:
> "xfs_admin can't print both label and UUID for mounted filesystems"
> https://bugzilla.kernel.org/show_bug.cgi?id=206429
> 
> alerted us to the problem that if /any/ options that use xfs_io get
> specified to xfs_admin, they are the /only/ ones that get run:
> 
>                 # Try making the changes online, if supported
>                 if [ -n "$IO_OPTS" ] && mntpt="$(find_mntpt_for_arg "$1")"
>                 then
>                         eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
>                         test "$?" -eq 0 && exit 0
>                 fi
> 
> and thanks to the exit, the xfs_db operations don't get run at all.
> 
> We could move on to the xfs_db commands after executing the xfs_io
> commands, but we build them all up in parallel at this time:
> 
>         l)      DB_OPTS=$DB_OPTS" -r -c label"
>                 IO_OPTS=$IO_OPTS" -r -c label"
>                 ;;
> 
> so we'd need to keep track of these, and not re-run them in xfs_db.
> 
> Another issue is that prior to this commit, we'd run commands in
> command line order.
> 
> So I experimented with building up an array of commands, invoking xfs_db
> or xfs_io one command at a time as needed for each, and ... it got overly
> complicated.
> 
> It's broken now, and so far a clean solution isn't evident, and I hate to
> leave it broken across another release.  So revert it for now.
> 
> Reverts: 3f153e051a ("xfs_admin: enable online label getting and setting")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks fine, I understand why now :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
