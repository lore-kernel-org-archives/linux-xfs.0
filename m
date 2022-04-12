Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F35F9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 11:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347953AbiDLLfa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 07:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352429AbiDLLfW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 07:35:22 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B560C76E13
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 03:14:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A9A9910C78EF;
        Tue, 12 Apr 2022 20:13:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1neDX4-00Gmtd-6m; Tue, 12 Apr 2022 20:13:58 +1000
Date:   Tue, 12 Apr 2022 20:13:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: hide log iovec alignment constraints
Message-ID: <20220412101358.GG1544202@dread.disaster.area>
References: <20220314220631.3093283-1-david@fromorbit.com>
 <20220314220631.3093283-2-david@fromorbit.com>
 <aa95f0d19f78a94e8bcdbcf76979253bf97f8bcb.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa95f0d19f78a94e8bcdbcf76979253bf97f8bcb.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625550e7
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=_fPKMViU61f-qTab1ncA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 10:23:09PM -0700, Alli wrote:
> On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Callers currently have to round out the size of buffers to match the
> > aligment constraints of log iovecs and xlog_write(). They should not
> > need to know this detail, so introduce a new function to calculate
> > the iovec length (for use in ->iop_size implementations). Also
> > modify xlog_finish_iovec() to round up the length to the correct
> > alignment so the callers don't need to do this, either.
> > 
> > Convert the only user - inode forks - of this alignment rounding to
> > use the new interface.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
.....
> >  void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct
> > xfs_log_iovec **vecp,
> >  		uint type);
> >  
> > @@ -29,6 +40,12 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct
> > xfs_log_iovec *vec, int len)
> >  {
> >  	struct xlog_op_header	*oph = vec->i_addr;
> >  
> > +	/*
> > +	 * Always round up the length to the correct alignment so
> > callers don't
> > +	 * need to know anything about this log vec layout requirement.
> > +	 */
> > +	len = xlog_calc_iovec_len(len);Hmm, what code base was this on?
> > > 
> Hmm, I'm getting some merge conflicts in this area.  It looks like the
> round_up logic was already added in:
> 
> bde7cff67c39227c6ad503394e19e58debdbc5e3
> "xfs: format log items write directly into the linear CIL buffer"
> 
> So I think it's ok to drop this bit about rounding length.

Ok, I think that's why you are getting rounding assert failures in
the log code - this code replaces the fixed 4 byte allocation
roundup that is done for the inode fork data buffers, and if you
remove both the round-up I added to xlog_finish_iovec() and the
inode fork roundup, you get unaligned regions and assert failures in
xlog_write()....

The posted patchset was based on top of the xlog-write-rewrite
patchset I posted before this one, so I'd say that's where the
conflicts applying this to a base 5.18-rc2 kernel came from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
