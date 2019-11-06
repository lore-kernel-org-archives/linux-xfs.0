Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2ACFC5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 16:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83D572075C
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 16:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/MxUDsb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfKFQNZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 11:13:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbfKFQNY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 11:13:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6GBn6n112923;
        Wed, 6 Nov 2019 16:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=I0DJWno1AIe+k5abobaMoeRn9tVqWR0gId8YXBLkfLU=;
 b=Z/MxUDsbCUmW5zQ2T/RfJyCzyM0BeSDW3UJsAxGkPJFljV9zNpvrMWBZVSdOpLWuHRIQ
 5ljA/IXWHREzUmFCsWejP9lOp5QGWBRCfyLtmyaPsZUukRue2g4EqEa0G3UPkAjEeTSm
 BugzEkF06N3MUL9PUbhm7su/VxW/C9Ls7JT+d9IU+BWcdc2hF3haBHygQCBcCZof4NBB
 nGYsrE8q9HsKSuaCFs9o8nruCwVOngerCQlR+KHViO1nVYDs6NcL5iWcX1OsxmCiWe/N
 vYGTkpZvUBiXGvP//FxbgnvJEJWrEa0CqDcOxY8VI9X+r72eMVhuBCrtuPhely5INPii EQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117u7vwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 16:13:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6G8GqG181508;
        Wed, 6 Nov 2019 16:13:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w3xc2x3ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 16:13:14 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA6GDDQv027261;
        Wed, 6 Nov 2019 16:13:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 08:13:13 -0800
Date:   Wed, 6 Nov 2019 08:13:12 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: periodically yield scrub threads to the
 scheduler
Message-ID: <20191106161312.GL4153244@magnolia>
References: <157301537390.678524.16085197974806955970.stgit@magnolia>
 <157301538629.678524.5328247190031479757.stgit@magnolia>
 <20191106144446.GB17196@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106144446.GB17196@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060155
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 03:44:46PM +0100, Christoph Hellwig wrote:
> On Tue, Nov 05, 2019 at 08:43:06PM -0800, Darrick J. Wong wrote:
> > +++ b/fs/xfs/scrub/common.h
> > @@ -14,8 +14,20 @@
> >  static inline bool
> >  xchk_should_terminate(
> >  	struct xfs_scrub	*sc,
> > -	int				*error)
> > +	int			*error)
> >  {
> > +#if !IS_ENABLED(CONFIG_PREEMPT)
> > +	/*
> > +	 * If preemption is disabled, we need to yield to the scheduler every
> > +	 * few seconds so that we don't run afoul of the soft lockup watchdog
> > +	 * or RCU stall detector.
> > +	 */
> > +	if (sc->next_yield != 0 && time_after(jiffies, sc->next_yield))
> > +		return false;
> > +	schedule();
> > +	sc->next_yield = jiffies + msecs_to_jiffies(5000);
> > +#endif
> 
> This looks weird.  Can't we just do a cond_resched() here?

DOH.  Yes, probably.  Dave even suggested it a few nights ago to fix a
similar problem and apparently I forgot.  Will fix. :(

--D
