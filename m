Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E403C2D0A8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A861A206B8
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 16:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OxK/3gBh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgIWQKw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 12:10:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58534 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgIWQKw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 12:10:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NG56XN180026;
        Wed, 23 Sep 2020 16:09:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Q/6kIi8t05haBOzoON5G5FX3SeVwRCdxzBlE8081TtE=;
 b=OxK/3gBhY47QU+giudmoTp1MivA6EVmL6QDon8Rq6kWjkW6hw1BynZ2C/vRCFjnsDxWf
 gIQxdYhIUTE5ctYNBJOmaqJYcO05V/7mR2xDWghUORWw3/W3SCNuUezeUc5Du1ngmfNO
 Qf4VHRF2n/zZ+ZoggL7LpHiZUSFEttBFlpaUoPqETr/Mkd57gbbg1XSVEUU7blVdIVag
 2+OyBYwY18XjcT74Gub74gbOBcDIHcy9U7hrCBYBbR4c7fv9nh7U7lj4VP6S8NqJFnQy
 2nwy2fp5ebDea+9xIm2fA/a805MDRzpxU0BqiONLLCMu1WkC9w75YVbqeQ7AyKut7W0v ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33ndnukgqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 16:09:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NG0679068190;
        Wed, 23 Sep 2020 16:09:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33r28vshha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 16:09:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08NG9YGq000629;
        Wed, 23 Sep 2020 16:09:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 09:09:34 -0700
Date:   Wed, 23 Sep 2020 09:09:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 1/3] xfs: directly return if the delta equal to zero
Message-ID: <20200923160933.GP7955@magnolia>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
 <20200922174347.GG2175303@bfoster>
 <2818363e-a860-99e4-5b55-9721abb5058a@gmail.com>
 <20200923132745.GA2228661@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923132745.GA2228661@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 09:27:45AM -0400, Brian Foster wrote:
> On Wed, Sep 23, 2020 at 10:42:10AM +0800, kaixuxia wrote:
> > 
> > 
> > On 2020/9/23 1:43, Brian Foster wrote:
> > > On Tue, Sep 22, 2020 at 05:04:00PM +0800, xiakaixu1987@gmail.com wrote:
> > >> From: Kaixu Xia <kaixuxia@tencent.com>
> > >>
> > >> It is useless to go on when the variable delta equal to zero in
> > >> xfs_trans_mod_dquot(), so just return if the value equal to zero.
> > >>
> > >> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> > >> ---
> > >>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
> > >>  1 file changed, 6 insertions(+), 6 deletions(-)
> > >>
> > >> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > >> index 133fc6fc3edd..23c34af71825 100644
> > >> --- a/fs/xfs/xfs_trans_dquot.c
> > >> +++ b/fs/xfs/xfs_trans_dquot.c
> > >> @@ -215,10 +215,11 @@ xfs_trans_mod_dquot(
> > >>  	if (qtrx->qt_dquot == NULL)
> > >>  		qtrx->qt_dquot = dqp;
> > >>  
> > >> -	if (delta) {
> > >> -		trace_xfs_trans_mod_dquot_before(qtrx);
> > >> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> > >> -	}
> > >> +	if (!delta)
> > >> +		return;
> > >> +
> > > 
> > > 
> > > This does slightly change behavior in that this function currently
> > > unconditionally results in logging the associated dquot in the
> > > transaction. I'm not sure anything really depends on that with a delta
> > > == 0, but it might be worth documenting in the commit log.
> > >> Also, it does seem a little odd to bail out after we've potentially
> > > allocated ->t_dqinfo as well as assigned the current dquot a slot in the
> > > transaction. I think that means the effect of this change is lost if
> > > another dquot happens to be modified (with delta != 0) in the same
> > > transaction (which might also be an odd thing to do).
> > >
> > Since the dquot value doesn't changes if the delta == 0, we shouldn't
> > set the XFS_TRANS_DQ_DIRTY flag to current transaction. Maybe we should
> > do the judgement at the beginning of the function, we will do nothing if
> > the delta == 0. Just like this,
> > 
> >  xfs_trans_mod_dquot(
> >  {
> >    ...
> >    if (!delta)
> >      return;
> >    if (tp->t_dqinfo == NULL)
> >      xfs_trans_alloc_dqinfo(tp);
> >    ...
> >  }
> > 
> > I'm not sure...What's your opinion about that?
> > 
> 
> Yes, I think that makes more sense than bailing out after at least.
> Otherwise if some other path sets XFS_TRANS_DQ_DIRTY, then this dquot is
> still associated with the transaction. I'm not sure that's currently
> possible, but it's an odd wart where the current code is at least
> readable/predictable. That said, note again that this changes behavior,
> so it's not quite sufficient for the commit log description to just say
> bail out early since delta is zero. That much is obvious from the code
> change. We need to audit the behavior change and provide a few sentences
> in the commit log description to explain why it is safe.

Agreed.  Sorry I didn't notice the TRANS_DQ_DIRTY thing earlier. :/

TBH I wonder if we even need that flag, since the only thing it seems to
do nowadays is shortcut checking if tp->t_dqinfo == NULL in
xfs_trans_apply_dquot_deltas and its unreserve variant.

--D

> 
> Brian
> 
> > Thanks,
> > Kaixu
> > 
> > > Brian
> > > 
> > >> +	trace_xfs_trans_mod_dquot_before(qtrx);
> > >> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> > >>  
> > >>  	switch (field) {
> > >>  
> > >> @@ -284,8 +285,7 @@ xfs_trans_mod_dquot(
> > >>  		ASSERT(0);
> > >>  	}
> > >>  
> > >> -	if (delta)
> > >> -		trace_xfs_trans_mod_dquot_after(qtrx);
> > >> +	trace_xfs_trans_mod_dquot_after(qtrx);
> > >>  
> > >>  	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
> > >>  }
> > >> -- 
> > >> 2.20.0
> > >>
> > > 
> > 
> > -- 
> > kaixuxia
> > 
> 
