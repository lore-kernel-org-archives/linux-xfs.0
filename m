Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918ABC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E0DD2173E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 17:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R/pK0JsI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgEARl0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 13:41:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbgEARlZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 13:41:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041HXTMf178051;
        Fri, 1 May 2020 17:41:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=0FaliTDGaUHyl7iNtd0inIJ8sfu48uAzV6EuLkpvrzE=;
 b=R/pK0JsIsmHf7b/zJBRkxqlo1m0iO5xkFxGmBEfgPlnW5uH9weFAR8gedDff2RieWlk+
 jpJD2A4kqiJmUAR2hbCo9PWuraDvYBP+3+0vwx6Dm245Kn5iwG7wTiUMt+PWixnhcbtm
 CkExpfMyAEbP6HeNxUQ/9CzwUuHcy/pJilwOKd239Kf8ljwP+jppRAmAzWQ491P+zDje
 LAHGp+B+D8dLtPCYoaccNzfhibRWT1eZSy8QGyB0Nl9PNqK2WxTCXVFinbS9JzeOgfhb
 +iOW695iSY+uo0wQD7x8ZYs6dYSFH9uruegk6+Mi2YjB9hiNVUXx35bKJiM2luYokF67 Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30r7f5uaux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:41:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041HZ8cO015531;
        Fri, 1 May 2020 17:41:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30r7fbch0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:41:22 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 041HfLUZ013147;
        Fri, 1 May 2020 17:41:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 10:41:21 -0700
Date:   Fri, 1 May 2020 10:41:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/21] xfs: remove log recovery quotaoff item dispatch
 for pass2 commit functions
Message-ID: <20200501174120.GV6742@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
 <158820770710.467894.3729357655928662895.stgit@magnolia>
 <8827324.aB63qXBn3K@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8827324.aB63qXBn3K@localhost.localdomain>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 08:39:21PM +0530, Chandan Rajendra wrote:
> On Thursday, April 30, 2020 6:18 AM Darrick J. Wong wrote: 
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Quotaoff doesn't actually do anything, so take advantage of the
> > commit_pass2_fn pointer being optional and get rid of the switch
> > statement clause.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_log_recover.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 6ba3d64d08de..dba38fb99af7 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2538,9 +2538,6 @@ xlog_recover_commit_pass2(
> >  		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
> >  	case XFS_LI_BUD:
> >  		return xlog_recover_bud_pass2(log, item);
> > -	case XFS_LI_QUOTAOFF:
> > -		/* nothing to do in pass2 */
> > -		return 0;
> 
> If there is a XFS_LI_QUOTAOFF item in the log, wouldn't XLOG_RECOVER_PASS2
> step end up executing the statements under the "default" case given below?

Hmm, good point, this breaks bisectability.  This patch should be the
last of the pass2 conversion patches, and it can take care of removing
all the old function dispatch infrastructure and whatnot.

--D

> >  	default:
> >  		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
> >  			__func__, ITEM_TYPE(item));
> > 
> > 
> 
> 
> -- 
> chandan
> 
> 
> 
