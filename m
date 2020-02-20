Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67A1C5ACC4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 03:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5915206E2
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 03:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgBTDlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 22:41:15 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60473 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727506AbgBTDlP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 22:41:15 -0500
Received: from dread.disaster.area (pa49-195-185-106.pa.nsw.optusnet.com.au [49.195.185.106])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BC8E482026B;
        Thu, 20 Feb 2020 14:41:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4ci2-0005hm-Pk; Thu, 20 Feb 2020 14:41:06 +1100
Date:   Thu, 20 Feb 2020 14:41:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Richard Wareing <rwareing@fb.com>, linux-xfs@vger.kernel.org,
        Anthony Iliopoulos <ailiopoulos@suse.de>
Subject: Re: Modern uses of CONFIG_XFS_RT
Message-ID: <20200220034106.GO10776@dread.disaster.area>
References: <20200219135715.GZ30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219135715.GZ30113@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=bkRQb8bsQZKWSSj4M57YXw==:117 a=bkRQb8bsQZKWSSj4M57YXw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=95owZCbt67vcucCyqxcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 01:57:15PM +0000, Luis Chamberlain wrote:
> I hear some folks still use CONFIG_XFS_RT, I was curious what was the
> actual modern typical use case for it. I thought this was somewhat
> realted to DAX use but upon a quick code inspection I see direct
> realtionship.

Facebook use it in production systems to separate large file data
from metadata and small files. i.e. they use a small SSD based
partition for the filesytem metadata and a spinning disk for
the large scale data storage. Essentially simple teired storage.

It's also commonly still used in multi-stream DVRs (think
multi-camera security systems), and other similar sequential access
data applications...

That's just a couple off the top of my head...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
