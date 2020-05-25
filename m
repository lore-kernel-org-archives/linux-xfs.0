Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E32C7C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 18:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B701C20776
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 18:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590431785;
	bh=8UgDgyFop8uNbOoPf4sH4yNtuhlOjxxulvXLnKi//GM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=H5nUMWoW60RDOVumDANIqwVRTQaaKAt755s4q6xZkBUYFd1ilCt55jd3nrbmJSxSd
	 8QXS++K7h0vQ5ZE34UoGea/T/NscPKIFWqnRKHDMpwFTjDhiqUf2c4tjkKyUkiyfH8
	 803t1glyyg7cFqmsUvfGGebrvVT6seXQb6xe+LtY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389703AbgEYSgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 May 2020 14:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389505AbgEYSgZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 May 2020 14:36:25 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 345402071C;
        Mon, 25 May 2020 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590431784;
        bh=8UgDgyFop8uNbOoPf4sH4yNtuhlOjxxulvXLnKi//GM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dSdVJjLPxm80dQJW8VhGN5D248DSstO/gDKNhtLWz2OezMRZeS/oRsLmWOyBtzmIs
         Rz49TQTT730/mg7VbvSlkIfDSKAlYJtv+lCxKRFOFh39WWtceJZu+uz6fQERo94TvT
         7BrIakhgvvVcIf8Hw3XzgXTusIKFrV+l+0kDRp/Y=
Date:   Mon, 25 May 2020 13:41:19 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Replace one-element arrays with flexible-array
 members
Message-ID: <20200525184119.GB9247@embeddedor>
References: <20200522215542.GA18898@embeddedor>
 <202005221606.A1647A0@keescook>
 <20200523202149.GI29907@embeddedor>
 <20200524022555.GA252930@magnolia>
 <20200524232315.GQ2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524232315.GQ2040@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

On Mon, May 25, 2020 at 09:23:15AM +1000, Dave Chinner wrote:
> On Sat, May 23, 2020 at 07:25:55PM -0700, Darrick J. Wong wrote:
> > Please always cc linux-xfs when you're changing fs/xfs code.
> > 
> > *Especially* when it involves changes to ondisk structures.
> 
> I can't find this patch in lkml or -fsdevel on lore.kernel.org, so I
> have no idea where this patch even came from. Which means I can't
> even check what the structure change is because it wasn't quoted in
> full.
> 

Yeah, there was a bug in one of my scripts that was messing up with
some email addresses. I just fixed it up.

> So, NACK on this until the entire patch is resent to linux-xfs and
> run through all the shutdown and error recovery tests in fstests....
> 

I've added the patch[1] to my testing/xfs branch. I'll wait for
Kernel test robot <lkp@intel.com> to help me test it.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/commit/?h=testing/xfs

