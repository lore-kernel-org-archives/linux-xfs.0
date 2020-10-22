Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60553C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 08:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03EBE223C7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 08:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgJVIX5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 04:23:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49150 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgJVIX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 04:23:56 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 8C67F58BB17;
        Thu, 22 Oct 2020 19:23:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kVVt4-00373H-2i; Thu, 22 Oct 2020 19:23:54 +1100
Date:   Thu, 22 Oct 2020 19:23:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] repair: don't duplicate names in phase 6
Message-ID: <20201022082354.GU7391@dread.disaster.area>
References: <20201022051537.2286402-1-david@fromorbit.com>
 <20201022051537.2286402-6-david@fromorbit.com>
 <20201022062152.GQ9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022062152.GQ9832@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=afefHYAZSVUA:10 a=7-415B0cAAAA:8
        a=SI0Ruv5vGkQRBez8TP8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 11:21:52PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 04:15:35PM +1100, Dave Chinner wrote:
....
> > @@ -1387,6 +1371,7 @@ dir2_kill_block(
> >  		res_failed(error);
> >  	libxfs_trans_ijoin(tp, ip, 0);
> >  	libxfs_trans_bjoin(tp, bp);
> > +	libxfs_trans_bhold(tp, bp);
> 
> Why hold on to the buffer?  We killed the block, why keep the reference
> around so that someone else has to remember to drop it later?

Consistency in buffer handling. This "kill block" path nulled out
the buffer in the bplist array (the reason it's passed as a **bpp
to longform_dir2_entry_check_data(). This path releases the buffer
through the trans_commit(), the alternate path here:

> > @@ -1558,10 +1541,8 @@ longform_dir2_entry_check_data(
> >  			dir2_kill_block(mp, ip, da_bno, bp);
> >  		} else {
> >  			do_warn(_("would junk block\n"));
> > -			libxfs_buf_relse(bp);
> >  		}
> >  		freetab->ents[db].v = NULLDATAOFF;
> > -		*bpp = NULL;
> >  		return;
> >  	}

does an explicit release, and all other paths end up with the
buffers being released way back where the bplist is defined.

If the directory is in block form, nulling out the buffer in the
bplist here will result in dereferencing a null pointer later when
the buffer is pulled from bplist[0] without checking.

So I changed longform_dir2_entry_check_data() to never release the
buffer so that the caller knows that it has always got a valid
buffer reference and the isblock path will always work correctly....

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
