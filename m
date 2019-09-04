Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83329C3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5157B21670
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 23:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfIDXkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 19:40:46 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38084 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729919AbfIDXkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 19:40:45 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D2D7843D26B;
        Thu,  5 Sep 2019 09:40:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5etG-0000B0-NE; Thu, 05 Sep 2019 09:40:42 +1000
Date:   Thu, 5 Sep 2019 09:40:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] libfrog: move workqueue.h to libfrog/
Message-ID: <20190904234042.GZ1119@dread.disaster.area>
References: <156757174409.1838135.8885359673458816401.stgit@magnolia>
 <156757181354.1838135.14750040578517707289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156757181354.1838135.14750040578517707289.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=3GyV7S7Y3v6tiexnUv8A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 09:36:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this header to libfrog since the code is there already.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/Makefile   |    1 -
>  include/input.h    |    2 +-
>  include/project.h  |   39 ---------------------------------------
>  libfrog/Makefile   |    1 +
>  libfrog/paths.c    |    2 +-
>  libfrog/projects.c |    2 +-
>  libfrog/projects.h |   39 +++++++++++++++++++++++++++++++++++++++
>  quota/quota.h      |    2 +-
>  8 files changed, 44 insertions(+), 44 deletions(-)
>  delete mode 100644 include/project.h
>  create mode 100644 libfrog/projects.h

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
