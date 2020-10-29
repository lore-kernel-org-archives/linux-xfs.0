Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA19C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E1602076E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:45:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="URbV5mRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgJ2Rp4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:45:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgJ2Rpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 13:45:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THdnsG150060;
        Thu, 29 Oct 2020 17:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/8mI6ZaxV64OME0YPmDo1WLYpTKloT6rNqpk4wkIg/U=;
 b=URbV5mRDmpCOKHbT9Flqw1pm2BpRLkBi6qvKbelQXnB0qXW4n71mjb/2GdhPAITJpuw0
 Ht9Ng6ylXcxEydruePO0BdyzJOWh9Qlk1qGkRVyst642HZ/HZ8ViF0DFrAmjOJl4FJtL
 swrY4Z9hwTx+UKzWTRITVq9C1rf9yhTXvDnCYoyFa8SEIA7sFpQigX3+Vv4nXz+skskr
 JjRrIyMU3pzOmSA7kKqRkZrdYf12ps60QlleIg7lNf24Ia+RQ/IxzuQ8vdzdk81oGLQ2
 bsNFJcQ1eWQ5m+vrMj5IVZKWTRs9GsazRlHlOILsla0ICSRWQxo6PRljEzykqMZMoeds 1A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7m66fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 17:45:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09THeQT6156104;
        Thu, 29 Oct 2020 17:45:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1tghue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 17:45:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09THjkP0015318;
        Thu, 29 Oct 2020 17:45:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 10:45:45 -0700
Date:   Thu, 29 Oct 2020 10:45:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/26] xfs_db: report bigtime format timestamps
Message-ID: <20201029174544.GR1061252@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
 <20201029095010.GO2091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029095010.GO2091@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 09:50:10AM +0000, Christoph Hellwig wrote:
> > +static void
> > +fp_time64(
> > +	time64_t		sec)
> >  {
> > +	time_t			tt = sec;
> >  	char			*c;
> > +
> > +	BUILD_BUG_ON(sizeof(long) != sizeof(time_t));
> 
> Why?

Trying to make the best of a braindead situation.  IIRC C99/11/18 don't
provide a specific definition of what time_t is supposed to be.  POSIX
2017 seems to hint that it should be an integer seconds counter, but
doesn't provide any further clarity.  (And then says it defers to ISO C,
having made that allusion to integerness.)

Since I'd rather print a raw s64 value than risk truncating a time and
printing a totally garbage prettyprinted timestamp, I added the
LONG_{MIN,MAX} checks, but that assumes that time_t is a long.

Hence adding a trap so that if xfsprogs ever does encounter C library
where time_t isn't a long int, we'd get to hear about it.  Granted that
further assumes that time_t isn't a float, but ... ugh.

I guess this could have assigned sec to a time_t value and then compared
it back to the original value to see if we ripped off any upper bits.

--D
