Return-Path: <SRS0=c4da=DV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFC6C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 21:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46EAB221FF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Oct 2020 21:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgJNVZD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:25:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54423 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726484AbgJNVZD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 17:25:03 -0400
Received: from dread.disaster.area (pa49-195-69-88.pa.nsw.optusnet.com.au [49.195.69.88])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4CE5E58C1E4;
        Thu, 15 Oct 2020 08:24:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSoGY-000YyK-Mh; Thu, 15 Oct 2020 08:24:58 +1100
Date:   Thu, 15 Oct 2020 08:24:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: dbench throughput on xfs over hardware limit(6Gb/s)
Message-ID: <20201014212458.GC7391@dread.disaster.area>
References: <20201013221113.F0A0.409509F4@e16-tech.com>
 <20201013230521.GB7391@dread.disaster.area>
 <20201014113211.2372.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014113211.2372.409509F4@e16-tech.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=5g0Hk5519kQvxAqikqd8LA==:117 a=5g0Hk5519kQvxAqikqd8LA==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=83GoWlhbdbGG2EoRCkMA:9 a=mtGRwOJSVpvi1bqE:21 a=oaFyXoszcu-ZlxHt:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 14, 2020 at 11:32:11AM +0800, Wang Yugui wrote:
> 
> > On Tue, Oct 13, 2020 at 10:11:13PM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > dbench throughput on xfs over hardware limit(6Gb/s=750MB/s).
> > > 
> > > Is this a bug or some feature of performance optimization?
> > 
> > dbench measures page cache throughput, not physical IO throughput.
> > This sort of results is expected.
> 
> We use 'dbench -s', so it should be physical IO.
>    -s     Use synchronous file IO on all file operations.

Reads can still be served from the page cache without doing physical
IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
