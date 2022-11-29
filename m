Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FD1C4321E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 21:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiK2Vx0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235700AbiK2VxZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 16:53:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD67DED8;
        Tue, 29 Nov 2022 13:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D848F61929;
        Tue, 29 Nov 2022 21:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1D2C433C1;
        Tue, 29 Nov 2022 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669758804;
        bh=+o5URHgFOg4vHn4QcmDiS/DbLvNNMONoppjeXa5mHgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=szwuKG05DACIl4nCCAuHfAQc130/S8+t9Wue5HgvYGHut6jD/CXhoKhAKhBtM9Pcr
         S2Pk2fJOcLbLSsDIWRmDGQ2bX1lEHU+X7lqNGyjGHNgy60lbuotVmPzsP8/FInInjx
         5v7cbgL4+LXl02zbSzL16Eayy6RrgVeVff+ZU3qmBv1MQZhPWQHoi6wf2s9FPf25XO
         JRzFRHxDhYRtY4SfTzrSWWDMhxeeife+8tQfSCdXlaXJgGR0i7au8Q+Ycd3I2s8gbB
         vJursMLgaxkcQNwASw0bewWGmicdHCdHCULP239UulI13JcrfdzlZVNGnRmrPb6WB/
         hWdX96zBketew==
Date:   Tue, 29 Nov 2022 13:53:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 11/9] xfs: add debug knob to slow down write for fun
Message-ID: <Y4Z/U/oEA+MMqIsG@magnolia>
References: <20221123055812.747923-1-david@fromorbit.com>
 <Y4U3dj5qvpKSQuNM@magnolia>
 <Y4VeuqfVBU4/x9aB@magnolia>
 <20221129013744.GZ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129013744.GZ3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 12:37:44PM +1100, Dave Chinner wrote:
> On Mon, Nov 28, 2022 at 05:22:02PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a new error injection knob so that we can arbitrarily slow down
> > pagecahe writes to test for race conditions and aberrant reclaim
> 
> pagecache

Fixed.

--D

> > behavior if the writeback mechanisms are slow to issue writeback.  This
> > will enable functional testing for the ifork sequence counters
> > introduced in commit XXXXXXXXXXXX that fixes write racing with reclaim
> > writeback.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> > v2: this time with tracepoints
> > ---
> 
> Looks OK to me.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
