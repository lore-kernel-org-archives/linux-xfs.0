Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C055C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4667E20575
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:40:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="btfIoLIY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgD1WkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:40:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49260 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1WkO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:40:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMdHcI135564;
        Tue, 28 Apr 2020 22:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FU8ZN3i84z4hTWLCsi0IDS2WEjMlII5UwkRPKpH5MN8=;
 b=btfIoLIYIBTX+wfGhveMhTG6GcXJ69uDnBHrsUSRLXihNZbf1Y8aYgyzNxca0CCfo9E/
 UT7ihPBKrm5TFVGKhYezxE8uW4oILzTe3LeP0U1PwKCpmi7NcwU/2mN9E5hfP8pwkqk+
 320E+8hnZp+Sjq4vA9iEPcoyuUDUrEMe8azvM4zUBKyUFWwyu7q+To/XOI7oHDZ6smPa
 f4CFid6X4O2ExhIuTobSuaq3nXe7dsxmfbhpR7kmgDZNwM49oCsw/Oo0/z3IX9DSVwJN
 qrB2X4CsiCBfHHqxQkX/GsorGsaTcvN3f20mYFrMRJARZs6cHiG6etnmJ3ryWXdxiFZc kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01ns8me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:40:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMb9k7180121;
        Tue, 28 Apr 2020 22:40:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30my0en0y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:40:10 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMeA7p004108;
        Tue, 28 Apr 2020 22:40:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:40:10 -0700
Date:   Tue, 28 Apr 2020 15:40:08 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/19] xfs: refactor releasing finished intents during
 log recovery
Message-ID: <20200428224008.GN6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752125867.2140829.718007064092831514.stgit@magnolia>
 <20200425183410.GG16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425183410.GG16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004280175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 11:34:10AM -0700, Christoph Hellwig wrote:
> > +STATIC bool
> > +xlog_release_bui(
> > +	struct xlog		*log,
> > +	struct xfs_log_item	*lip,
> > +	uint64_t		intent_id)
> > +{
> > +	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
> > +	struct xfs_ail		*ailp = log->l_ailp;
> > +
> > +	if (buip->bui_format.bui_id == intent_id) {
> > +		/*
> > +		 * Drop the BUD reference to the BUI. This
> > +		 * removes the BUI from the AIL and frees it.
> > +		 */
> > +		spin_unlock(&ailp->ail_lock);
> > +		xfs_bui_release(buip);
> > +		spin_lock(&ailp->ail_lock);
> > +		return true;
> > +	}
> > +
> > +	return false;
> 
> Early returns for the no match case would seem a little more clear for
> all the callbacks.

Done.

> Also the boilerplate comments in all the callback
> seem rather pointless.  If you think they have enough value I'd
> consolidate that information once in the xlog_recover_release_intent
> description.

Yeah, I'll move it.

> 
> > +	spin_lock(&ailp->ail_lock);
> > +	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > +	while (lip != NULL) {
> > +		if (lip->li_type == intent_type && fn(log, lip, intent_id))
> > +			break;
> > +		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> > +	}
> 
> What about:
> 
> 	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip;
> 	     lip = xfs_trans_ail_cursor_next(ailp, &cur) {
> 		if (lip->li_type != intent_type)
> 			continue;
> 		if (fn(log, lip, intent_id))
> 			break;
> 	}

Done.

--D
