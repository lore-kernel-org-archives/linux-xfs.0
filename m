Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E70C432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 21:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B337E20706
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 21:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfKVVAp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 16:00:45 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42874 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfKVVAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 16:00:45 -0500
Received: from dread.disaster.area (pa49-181-174-87.pa.nsw.optusnet.com.au [49.181.174.87])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7EE9E7E81F2;
        Sat, 23 Nov 2019 08:00:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iYG2i-0007Tz-CI; Sat, 23 Nov 2019 08:00:40 +1100
Date:   Sat, 23 Nov 2019 08:00:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: Break block discard into chunks of 2 GB
Message-ID: <20191122210040.GK4614@dread.disaster.area>
References: <20191121214445.282160-1-preichl@redhat.com>
 <20191121214445.282160-2-preichl@redhat.com>
 <20191121231838.GH4614@dread.disaster.area>
 <20191122153807.GD6219@magnolia>
 <CAJc7PzX0sra12ikpVAY4LE-zRxamJK+JiNxj69MS+MOTmP730g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc7PzX0sra12ikpVAY4LE-zRxamJK+JiNxj69MS+MOTmP730g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3v0Do7u/0+cnL2zxahI5mg==:117 a=3v0Do7u/0+cnL2zxahI5mg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=Qf5iU-tGAgiwdPDwveYA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 22, 2019 at 04:59:21PM +0100, Pavel Reichl wrote:
> On Fri, Nov 22, 2019 at 4:38 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Also:
> > What is the end goal that you have in mind?  Is the progress reporting
> > the ultimate goal?  Or is it to break up the BLKDISCARD calls so that
> > someone can ^C a mkfs operation and not have it just sit there
> > continuing to run?
> 
> The goal is mainly the progress reporting but the possibility to do ^C
> is also convenient. It seems that some users are not happy about the
> BLKDISCARD taking too long and at the same time not being informed
> about that - so they think that the command actually hung.

Ok, that's a good summary to put in the commit description - it
tells the reviewer exactly what you are trying to acheive, and gives
them context to evaluate it against.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
