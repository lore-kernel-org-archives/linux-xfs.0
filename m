Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28F4C2D0DB
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 22:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E2BD214D8
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 22:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgA1W1C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jan 2020 17:27:02 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53350 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbgA1W1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jan 2020 17:27:01 -0500
Received: from dread.disaster.area (pa49-195-111-217.pa.nsw.optusnet.com.au [49.195.111.217])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8F1CB7EA233;
        Wed, 29 Jan 2020 09:26:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iwZJy-00053N-0w; Wed, 29 Jan 2020 09:26:58 +1100
Date:   Wed, 29 Jan 2020 09:26:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: do not redeclare globals provided by libraries
Message-ID: <20200128222657.GE18610@dread.disaster.area>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
 <20200128032907.GM3447196@magnolia>
 <332e4c3a-ddac-4e48-b236-e4c2248163a5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <332e4c3a-ddac-4e48-b236-e4c2248163a5@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=0OveGI8p3fsTA6FL6ss4ZQ==:117 a=0OveGI8p3fsTA6FL6ss4ZQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=tkYm24j_SQg2SOd9-TUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 28, 2020 at 08:48:40AM -0600, Eric Sandeen wrote:
> On 1/27/20 9:29 PM, Darrick J. Wong wrote:
> > On Mon, Jan 27, 2020 at 04:56:02PM -0600, Eric Sandeen wrote:
> > > From: Eric Sandeen <sandeen@redhat.com>
> > > 
> > > In each of these cases, db, logprint, and mdrestore are redeclaring
> > > as a global variable something which was already provided by a
> > > library they link with.
> > 
> > Er... which library?
> 
> libxfs and libxlog ...
> 
> 
>   File                Line
> 0 libxlog/util.c      10 int print_exit;
> 1 logprint/logprint.c 27 int print_exit = 1;
> 
>   File           Line
> 0 db/init.c      30 libxfs_init_t x;
> 1 libxlog/util.c 13 libxfs_init_t x;
> 
>   File                      Line
> 0 fsr/xfs_fsr.c              31 char *progname;
> 1 io/init.c                  14 char *progname;
> 2 libxfs/init.c              28 char *progname = "libxfs";
> 3 mdrestore/xfs_mdrestore.c  10 char *progname;
> 
> (fsr & io don't link w/ libxfs; mdrestore does)
> 
> 
> > 
> > Also, uh...maybe we shouldn't be exporting globals across libraries?
> > 
> > (He says having not looked for how many there are lurki... ye gods)
> 
> Well, it's ugly for sure.
> 
> We could either try to re-architect this to
> 
> 1) pass stuff like progname all over the place, or
> 2) consistently make the library provide it as a global, or
> 3) consistently make utils provide it to the library as a global (?)

IIRC, I chose #2 way back when I was consolidating all the libxfs
library code. There was code that declared libxfs_init_t x; on
stack, as local globals, in the libraries, etc. So I simply made the
library global the One True Global, and then had everyone use it
everywhere.

That was just the simplest solution at the time to minimise the
amount of work to get userspace up to date with the kernel to allow
integration of the CRC work (userspace was years out of date at that
point). It was not pretty (like a lot of my code), but it worked.

Feel free to do what you think is best :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
