Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C816DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 06:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E0FF2081B
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 06:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfIIGVA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 02:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbfIIGVA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Sep 2019 02:21:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C3B4A30A00CF;
        Mon,  9 Sep 2019 06:20:59 +0000 (UTC)
Received: from rh (ovpn-116-55.phx2.redhat.com [10.3.116.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E92110016EB;
        Mon,  9 Sep 2019 06:20:59 +0000 (UTC)
Received: from [::1] (helo=rh)
        by rh with esmtps (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <dchinner@redhat.com>)
        id 1i7D2i-0001wB-HC; Mon, 09 Sep 2019 16:20:52 +1000
Date:   Mon, 9 Sep 2019 16:20:49 +1000
From:   Dave Chinner <dchinner@redhat.com>
To:     Rong Chen <rong.a.chen@intel.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@01.org
Subject: Re: [xfs] 610125ab1e: fsmark.app_overhead -71.2% improvement
Message-ID: <20190909062049.GQ2254@rh>
References: <20190909015849.GN15734@shao2-debian>
 <20190909053236.GP2254@rh>
 <df5f4105-58a9-492d-882e-0963fd5cb23f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df5f4105-58a9-492d-882e-0963fd5cb23f@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 09 Sep 2019 06:20:59 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 09, 2019 at 02:06:54PM +0800, Rong Chen wrote:
> Hi Dave,
> 
> On 9/9/19 1:32 PM, Dave Chinner wrote:
> > On Mon, Sep 09, 2019 at 09:58:49AM +0800, kernel test robot wrote:
> > > Greeting,
> > > 
> > > FYI, we noticed a -71.2% improvement of fsmark.app_overhead due to commit:
> > A negative improvement? That's somewhat ambiguous...
> 
> Sorry for causing the misunderstanding, it's a improvement not a regression.
> 
> 
> > 
> > > 0e822255f95db400 610125ab1e4b1b48dcffe74d9d8
> > > ---------------- ---------------------------
> > >           %stddev     %change         %stddev
> > >               \          |                \
> > >   1.095e+08           -71.2%   31557568        fsmark.app_overhead
> > >        6157           +95.5%      12034        fsmark.files_per_sec
> > So, the files/s rate doubled, and the amount of time spent in
> > userspace by the fsmark app dropped by 70%.
> > 
> > >      167.31           -47.3%      88.25        fsmark.time.elapsed_time
> > >      167.31           -47.3%      88.25        fsmark.time.elapsed_time.max
> > Wall time went down by 50%.
> > 
> > >       91.00            -8.8%      83.00        fsmark.time.percent_of_cpu_this_job_got
> > >      148.15           -53.2%      69.38        fsmark.time.system_time
> > As did system CPU.
> > 
> > IOWs, this change has changed create performance by a factor of 4 -
> > the file create is 2x faster for half the CPU spent.
> > 
> > I don't think this is a negative improvement - it's a large positive
> > improvement.  I suspect that you need to change the metric
> > classifications for this workload...
> To avoid misunderstanding, we'll use fsmark.files_per_sec instead of
> fsmark.app_overhead in the subject.

Well, the two are separate ways of measuring improvement. A change
in one without a change in the other is just as significant as
a change in both...

Cheers,

Dave.
-- 
Dave Chinner
dchinner@redhat.com
