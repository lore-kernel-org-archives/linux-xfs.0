Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A48C35249
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC6421927
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 06:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UZ88FKus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgBEGC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Feb 2020 01:02:29 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgBEGC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 01:02:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155x2rr121759;
        Wed, 5 Feb 2020 06:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Np/HyAlB4S2dwxndsm1Wltkr4yVMBikePwpgjefWQOs=;
 b=UZ88FKusm8NuKJbAZj+EUK5i5ID062480BPohhSg+3VcOJlCfYPAw2g8G8PgBmGanN5N
 rhA7/P3NfIofpcdqn3gay184MuTjOByAm496NjQ6PY7gL4WoBasmi/iP90rSr2SJeWJZ
 S9gCZ6dAaNaqHmgt/4/6+e9jM/4jlGgenHsMbJ+bNUJl0H/Y5OPC5l7YA1mpLqh1awRy
 0YIeSaExSj0b4t5nAGNN0/00VOvCzuBVTiuVbq+6ZX0HYNp9Gbwz7vh/wri/Hi3a1C6m
 9var+OyKGeAlmNBqbA1mtF8GcFfUXY6KlWRquV8NEAXcnsW/u0nlhet5t15h9Neu9lrK HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xykbp0vj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 06:02:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0155x3ak132599;
        Wed, 5 Feb 2020 06:02:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xykc47kgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 06:02:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01562NAk013398;
        Wed, 5 Feb 2020 06:02:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 22:02:22 -0800
Date:   Tue, 4 Feb 2020 22:02:22 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix invalid pointer dereference in
 xfs_attr3_node_inactive
Message-ID: <20200205060222.GE6870@magnolia>
References: <20200204070636.25572-1-zlang@redhat.com>
 <20200204213932.GM20628@dread.disaster.area>
 <20200205035830.GN14282@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205035830.GN14282@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050049
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 05, 2020 at 11:58:30AM +0800, Zorro Lang wrote:
> On Wed, Feb 05, 2020 at 08:39:32AM +1100, Dave Chinner wrote:
> > On Tue, Feb 04, 2020 at 03:06:36PM +0800, Zorro Lang wrote:
> > > This patch fixes below KASAN report. The xfs_attr3_node_inactive()
> > > gets 'child_bp' at there:
> > >   error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
> > >                             child_blkno,
> > >                             XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
> > >                             &child_bp);
> > >   if (error)
> > >           return error;
> > >   error = bp->b_error;
> > > 
> > > But it turns to use 'bp', not 'child_bp'. And the 'bp' has been freed by:
> > >   xfs_trans_brelse(*trans, bp);
> > 
> > ....
> > > ---
> > >  fs/xfs/xfs_attr_inactive.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > > index bbfa6ba84dcd..26230d150bf2 100644
> > > --- a/fs/xfs/xfs_attr_inactive.c
> > > +++ b/fs/xfs/xfs_attr_inactive.c
> > > @@ -211,7 +211,7 @@ xfs_attr3_node_inactive(
> > >  				&child_bp);
> > >  		if (error)
> > >  			return error;
> > > -		error = bp->b_error;
> > > +		error = child_bp->b_error;
> > >  		if (error) {
> > >  			xfs_trans_brelse(*trans, child_bp);
> > >  			return error;
> > 
> > Isn't this dead code now? i.e. any error that occurs on the buffer
> > during a xfs_trans_get_buf() call is returned directly and so it's
> > caught by the "if (error)" check. Hence this whole child_bp->b_error
> > check can be removed, right?
> 
> Thanks, by looking into the xfs_trans_get_buf() code, I think you're right. Sorry
> I didn't recognise that before.
> 
> But when should we check the bp->b_error? and when's it not necessary?
> In other words, when XFS set the bp->b_error? Looks like it's set in some *verify*
> functions and ioend time?

"Always check b_error after reading."

But please do note that the the buffer read functions will return it for
you now, so you don't have to check it separately in those cases.

(The verifiers and ioend functions are lower level and have to check it
explicitly.)

--D

> Thanks,
> Zorro
> 
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
