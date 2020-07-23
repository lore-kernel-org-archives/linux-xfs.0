Return-Path: <SRS0=I6cU=BC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B6CC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 22:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DC99206C1
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 22:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgGWWK2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 18:10:28 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49911 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726173AbgGWWK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 18:10:28 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id D15251A9CC4;
        Fri, 24 Jul 2020 08:10:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jyjPw-0000uT-2s; Fri, 24 Jul 2020 08:10:20 +1000
Date:   Fri, 24 Jul 2020 08:10:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] io/attr.c: Disallow specifying both -D and -R options
 for chattr command
Message-ID: <20200723221020.GG2005@dread.disaster.area>
References: <20200723052723.30063-1-yangx.jy@cn.fujitsu.com>
 <20200723060850.GA14199@infradead.org>
 <5F19308A.2060109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F19308A.2060109@cn.fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=_gBv2pkiZCLgo5qkfUoA:9 a=CjuIK1q_8ugA:10 a=-RoEEKskQ1sA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 23, 2020 at 02:39:06PM +0800, Xiao Yang wrote:
> On 2020/7/23 14:08, Christoph Hellwig wrote:
> > On Thu, Jul 23, 2020 at 01:27:23PM +0800, Xiao Yang wrote:
> > > -D and -R options are mutually exclusive actually but chattr command
> > > doesn't check it so that always applies -D option when both of them
> > > are specified.  For example:
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig<hch@lst.de>
> Hi,
> 
> Ah,  I have a question after sending the patch:
> Other commands(e.g. cowextsize) including the same options seem to avoid the
> issue by accepting the last option, as below:
> --------------------------------------------------------
> io/cowextsize.c
> 141         while ((c = getopt(argc, argv, "DR")) != EOF) {
> 142                 switch (c) {
> 143                 case 'D':
> 144                         recurse_all = 0;
> 145                         recurse_dir = 1;
> 146                         break;
> 147                 case 'R':
> 148                         recurse_all = 1;
> 149                         recurse_dir = 0;
> 150                         break;
> 
> Test:
> # xfs_io -c "cowextsize -D -R" testdir
> [0] testdir/tdir
> [0] testdir/tfile
> [0] testdir
> [root@Fedora-31 ~]# xfs_io -c "cowextsize -R -D" testdir
> [0] testdir/tdir
> [0] testdir
> --------------------------------------------------------
> 
> Perhaps, we should use the same solution. (not sure) :-)

They should all operate the same way and, IMO, the order of the
parameters on the command line should not change the behaviour of
the command. Hence I think erroring out is better than what the
cowextsize code does above.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
