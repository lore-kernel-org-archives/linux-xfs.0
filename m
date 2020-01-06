Return-Path: <SRS0=XUqT=23=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0524C33C8C
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 23:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCE0D2080A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jan 2020 23:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgAFXds (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jan 2020 18:33:48 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58979 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbgAFXds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jan 2020 18:33:48 -0500
Received: from dread.disaster.area (pa49-180-68-255.pa.nsw.optusnet.com.au [49.180.68.255])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B141A3A0F8B;
        Tue,  7 Jan 2020 10:33:44 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iobsV-0006Xz-KI; Tue, 07 Jan 2020 10:33:43 +1100
Date:   Tue, 7 Jan 2020 10:33:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 05/14] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20200106233343.GD23128@dread.disaster.area>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-6-allison.henderson@oracle.com>
 <20191224121410.GB18379@infradead.org>
 <07284127-d9d7-e3eb-8e25-396e36ffaa93@oracle.com>
 <20200106144650.GB6799@bfoster>
 <af903a9f-2e2c-ac21-37a4-093be64f113d@oracle.com>
 <20200106214500.GA472651@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106214500.GA472651@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=sbdTpStuSq8iNQE8viVliQ==:117 a=sbdTpStuSq8iNQE8viVliQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=7-415B0cAAAA:8 a=GL8j6hCzjZu6FFPWmo8A:9 a=gsZ_OMfrtA_LO8UT:21
        a=D0J2j-ms7_TrVp2q:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 06, 2020 at 01:45:01PM -0800, Darrick J. Wong wrote:
> On Mon, Jan 06, 2020 at 11:29:29AM -0700, Allison Collins wrote:
> > 
> > 
> > On 1/6/20 7:46 AM, Brian Foster wrote:
> > > On Wed, Dec 25, 2019 at 10:43:15AM -0700, Allison Collins wrote:
> > > > 
> > > > 
> > > > On 12/24/19 5:14 AM, Christoph Hellwig wrote:
> > > > > On Wed, Dec 11, 2019 at 09:15:04PM -0700, Allison Collins wrote:
> > > > > > Break xfs_attr_rmtval_set into two helper functions
> > > > > > xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> > > > > > xfs_attr_rmtval_set rolls the transaction between the
> > > > > > helpers, but delayed operations cannot.  We will use
> > > > > > the helpers later when constructing new delayed
> > > > > > attribute routines.
> > > > > 
> > > > > Please use up the foll 72-ish characters for the changelog (also for
> > > > > various other patches).
> > > > Hmm, in one of my older reviews, we thought the standard line wrap length
> > > > was 68.  Maybe when more folks get back from holiday break, we can have more
> > > > chime in here.
> > > > 
> > > 
> > > I thought it was 68 as well (I think that qualifies as 72-ish" at
> > > least), but the current commit logs still look short of that at a
> > > glance. ;P
> > > 
> > > Brian
> > Ok I doubled checked, the last few lines do wrap a little early, but the
> > rest is correct for 68 because of the function names.  We should probably
> > establish a number though.  In perusing around some of the other patches on
> > the list, it looks to me like people are using 81?
> 
> I use 72 columns for emails and commit messages, and 79 for code.

Typically 68-72 columns for commit messages, often 68 because git
log output adds a 4 space indent to the commit message and that
often gets quoted directly in email...

> Though to be honest that's just my editor settings; I'm sure interested
> parties could find plenty of instances where my enforcement of even that
> is totally lax --
> 
> I have enough of a difficult time finding all the subtle bugs and corner
> case design problems in the kernel code (which will cause problems in
> our users' lives) that so long as you're not obviously going past the
> flaming red stripe that I told vim to put at column 80, I don't really
> care (because maxcolumns errors don't usually cause data loss). :)

Yeah, I have the flaming red column set to 80 by default, 68 for
email and commit messages...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
