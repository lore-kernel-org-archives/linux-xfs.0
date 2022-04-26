Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80792C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 23:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356246AbiDZXxQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 19:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356247AbiDZXxP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 19:53:15 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCC9EB7DB
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 16:50:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7D18E10E5FC1;
        Wed, 27 Apr 2022 09:50:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njUwU-004wO4-8X; Wed, 27 Apr 2022 09:50:02 +1000
Date:   Wed, 27 Apr 2022 09:50:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: separate out initial attr_set states
Message-ID: <20220426235002.GA1098723@dread.disaster.area>
References: <20220414094434.2508781-1-david@fromorbit.com>
 <20220414094434.2508781-5-david@fromorbit.com>
 <14c2f684d3c5319b57d36f2f0bee25f9986f7335.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14c2f684d3c5319b57d36f2f0bee25f9986f7335.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6268852b
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=35LiY9uipig3BqwxxQ8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 21, 2022 at 05:38:03PM -0700, Alli wrote:
> On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We current use XFS_DAS_UNINIT for several steps in the attr_set
> > state machine. We use it for setting shortform xattrs, converting
> > from shortform to leaf, leaf add, leaf-to-node and leaf add. All of
> > these things are essentially known before we start the state machine
> > iterating, so we really should separate them out:
> > 
> > XFS_DAS_SF_ADD:
> > 	- tries to do a shortform add
> > 	- on success -> done
> > 	- on ENOSPC converts to leaf, -> XFS_DAS_LEAF_ADD
> > 	- on error, dies.
> > 
> > XFS_DAS_LEAF_ADD:
> > 	- tries to do leaf add
> > 	- on success:
> > 		- inline attr -> done
> > 		- remote xattr || REPLACE -> XFS_DAS_FOUND_LBLK
> > 	- on ENOSPC converts to node, -> XFS_DAS_NODE_ADD
> > 	- on error, dies
> > 
> > XFS_DAS_NODE_ADD:
> > 	- tries to do node add
> > 	- on success:
> > 		- inline attr -> done
> > 		- remote xattr || REPLACE -> XFS_DAS_FOUND_NBLK
> > 	- on error, dies
....
> > @@ -874,6 +884,13 @@ xfs_attr_set_deferred(
> >  	if (error)
> >  		return error;
> >  
> > +	if (xfs_attr_is_shortform(args->dp))
> > +		new->xattri_dela_state = XFS_DAS_SF_ADD;
> > +	else if (xfs_attr_is_leaf(args->dp))
> > +		new->xattri_dela_state = XFS_DAS_LEAF_ADD;
> > +	else
> > +		new->xattri_dela_state = XFS_DAS_NODE_ADD;
> > +
> Mmmm, I dont know about putting this part here, because the
> xfs_attr_*_deferred routines do not get called during a replay, so this
> initial state config would get missed.  If you scoot it up into
> the xfs_attr_item_init call just a few lines up, then things should be
> fine since both code path start with that.  Rest looks ok though.

Yeah, recovery gets fixed up later on in the patchset. I managed
to get this through several rounds of fstests auto group and
several iterations of recoveryloop testing before I actually had
recovery hit the ASSERT(state != XFS_DAS_UNINIT) case....

I'm just getting back to this series now, so I'll look to clean this
aspect of it up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
