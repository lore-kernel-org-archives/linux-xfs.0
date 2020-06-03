Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F99BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47C9C2072F
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 00:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bILA3MZ9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFCAs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 20:48:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47012 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgFCAs6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 20:48:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530mU34025252;
        Wed, 3 Jun 2020 00:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5Jt73x/FO8jdIR1mpM5Hc886u/HNlPaeFUt3+VFqxOY=;
 b=bILA3MZ9IvUhZA8uhZpQEXC0Puyi96QIFrco6lEUw6Co5cj5uLZpjLDml5VUzxV8ar01
 YtSksPGiBZvW3pU+RlQCtt4kfxPnt4UWeaqFa52spNTM+Q2O761gNGmfx3MM+dRa5iPA
 joayLqJb7Hz+zuJWw/fwVndX1mD25s0ky2UZLnrZfTwMpv2aV35/PIpRHPEv8RJX4KSM
 WEfQZTSyrXdxKndavcfzvka0ieO30CeolIISsrFlD/6lSxTJOX+DpcMrwKCrDBVxRp24
 YsO2Ja98HYe34wJz3mPEcEWxjxsB0Aab905Ia5m6IeajYeVBlqpi97JJeygHbgEifeNV dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31bewqxpwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 03 Jun 2020 00:48:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0530hwlo104143;
        Wed, 3 Jun 2020 00:48:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31c25qg177-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jun 2020 00:48:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0530mrrM012253;
        Wed, 3 Jun 2020 00:48:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 17:48:53 -0700
Date:   Tue, 2 Jun 2020 17:48:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200603004852.GY8230@magnolia>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603002222.GU8230@magnolia>
 <20200603004429.GK2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603004429.GK2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=1 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006030002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 10:44:29AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2020 at 05:22:22PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 02, 2020 at 10:52:38PM +0800, Gao Xiang wrote:
> > > Sometimes no need to play with perag_tree since for many
> > > cases perag can also be accessed by agbp reliably.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> ....
> > > @@ -2447,32 +2443,22 @@ xfs_iunlink_remove(
> > >  	 * this inode's backref to point from the next inode.
> > >  	 */
> > >  	if (next_agino != NULLAGINO) {
> > > -		pag = xfs_perag_get(mp, agno);
> > > -		error = xfs_iunlink_change_backref(pag, next_agino,
> > > +		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
> > >  				NULLAGINO);
> > >  		if (error)
> > > -			goto out;
> > > +			return error;
> > >  	}
> > >  
> > > -	if (head_agino == agino) {
> > > -		/* Point the head of the list to the next unlinked inode. */
> > > -		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> > > -				next_agino);
> > > -		if (error)
> > > -			goto out;
> > > -	} else {
> > > +	if (head_agino != agino) {
> > >  		struct xfs_imap	imap;
> > >  		xfs_agino_t	prev_agino;
> > >  
> > > -		if (!pag)
> > > -			pag = xfs_perag_get(mp, agno);
> > > -
> > >  		/* We need to search the list for the inode being freed. */
> > >  		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
> > >  				&prev_agino, &imap, &last_dip, &last_ibp,
> > > -				pag);
> > > +				agibp->b_pag);
> > >  		if (error)
> > > -			goto out;
> > > +			return error;
> > >  
> > >  		/* Point the previous inode on the list to the next inode. */
> > >  		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
> > > @@ -2486,15 +2472,13 @@ xfs_iunlink_remove(
> > >  		 * change_backref takes care of deleting the backref if
> > >  		 * next_agino is NULLAGINO.
> > >  		 */
> > > -		error = xfs_iunlink_change_backref(pag, agino, next_agino);
> > > -		if (error)
> > > -			goto out;
> > > +		return xfs_iunlink_change_backref(agibp->b_pag, agino,
> > > +				next_agino);
> > >  	}
> > >  
> > > -out:
> > > -	if (pag)
> > > -		xfs_perag_put(pag);
> > > -	return error;
> > > +	/* Point the head of the list to the next unlinked inode. */
> > > +	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
> > > +			next_agino);
> > 
> > Why not cut out the agno argument here too?  Surely you could obtain it
> > from agibp->b_pag->pag_agno.  Ditto for xfs_iunlink_map_prev.
> 
> Those functions go away completely in the patchset I'm currently
> working on for tracking dirty inodes in ordered buffers. The
> in-memory unlinked list code needs to be completely reworked to
> acheive this (due to lock order constraints), so I'd much prefer
> unnecessary cleanup changes in this area are kept to a minimum
> because it will all away real soon.
> 
> FWIW, it was the discovery we could use agibp->b_pag instead of
> get/put in my iunlink list rework that prompted me to ask Xiang to
> look at the rest of the code and see where the same pattern could be
> applied...

Aha!  I wondered.  Ok, let's just leave this part alone then?  No harm
nor foul letting it stay in the meantime. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
