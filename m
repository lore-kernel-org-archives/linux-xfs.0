Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE178C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 01:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241556AbiD0B3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 21:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356654AbiD0B3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 21:29:43 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 473883E5F0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 18:26:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 74FDD10E5D46;
        Wed, 27 Apr 2022 11:26:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njWRp-004y8p-9C; Wed, 27 Apr 2022 11:26:29 +1000
Date:   Wed, 27 Apr 2022 11:26:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] metadump: handle corruption errors without aborting
Message-ID: <20220427012629.GB1098723@dread.disaster.area>
References: <20220426234453.682296-1-david@fromorbit.com>
 <20220426234453.682296-2-david@fromorbit.com>
 <20220427004503.GZ17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427004503.GZ17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62689bc7
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=2ALfA7hLeXvIWaf_jkUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 05:45:03PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 09:44:50AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Sean Caron reported that a metadump terminated after givin gthis
> > warning:
> > 
> > xfs_metadump: inode 2216156864 has unexpected extents
> > 
> > Metadump is supposed to ignore corruptions and continue dumping the
> > filesystem as best it can. Whilst it warns about many situations
> > where it can't fully dump structures, it should stop processing that
> > structure and continue with the next one until the entire filesystem
> > has been processed.
> > 
> > Unfortunately, some warning conditions also return an "abort" error
> > status, causing metadump to abort if that condition is hit. Most of
> > these abort conditions should really be "continue on next object"
> > conditions so that the we attempt to dump the rest of the
> > filesystem.
> > 
> > Fix the returns for warnings that incorrectly cause aborts
> > such that the only abort conditions are read errors when
> > "stop-on-read-error" semantics are specified. Also make the return
> > values consistently mean abort/continue rather than returning -errno
> > to mean "stop because read error" and then trying to infer what
> > the error means in callers without the context it occurred in.
> 
> I was almost about to say "This variable should be named success", but
> then noticed that there already /are/ variables named success.  Yuck.

Yeah, mess.

> rval==0 means abort?  and rval!=0 means continue?  If so,

Same as it was before.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Ta.

-Dave.

-- 
Dave Chinner
david@fromorbit.com
