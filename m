Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80FACA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 839912067D
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iKk7dj31"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfKEBI0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:08:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKEBIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 20:08:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA50wvQA137439;
        Tue, 5 Nov 2019 01:08:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KnyqAiL1QopRctpCxj5rpPDH/H+fRwNNlCp5UJoWLTU=;
 b=iKk7dj31LUGs2pUlQHW2cAQotD0qxeCyopSwdqL6D6PjB66cD+EnmBvOwGbz2qpjMkQT
 uhnM/EHqUyckwoiIKT41HoJAPwK32VeZbmXwE3kEYXUCQ0W/rTUaU4fIRHwV3rlNDWtg
 a+UZHiVQCPbSuKiKP0ZPIC1AiM5kvJ/OK8EWcnGWyl/TY9qTqgiopZdUT74cZENT28B3
 jtEB4QtQJtcCwk3OCfN5FOr8abXpWicHxnxKmmz0/dAe+PNPQt2ylnmO5rXeaIDBl/L5
 zs7bYYxqdGyFbifSW86IYVeMvPGNCE53FTtacB5jFoOUobYQVVQOtCyxyKlygbFM5A20 wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w117ttyu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:08:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA513wkY101443;
        Tue, 5 Nov 2019 01:08:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2w1kxnbp01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:08:19 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA518Hjx028310;
        Tue, 5 Nov 2019 01:08:17 GMT
Received: from localhost (/10.159.233.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 17:08:17 -0800
Date:   Mon, 4 Nov 2019 17:08:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: make the assertion message functions take a
 mount parameter
Message-ID: <20191105010811.GV4153244@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281986300.4151907.2698280321479729910.stgit@magnolia>
 <20191105004544.GC22247@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105004544.GC22247@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050006
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 04:45:44PM -0800, Christoph Hellwig wrote:
> >  void
> > -asswarn(char *expr, char *file, int line)
> > +asswarn(struct xfs_mount *mp, char *expr, char *file, int line)
> >  {
> > -	xfs_warn(NULL, "Assertion failed: %s, file: %s, line: %d",
> > +	xfs_warn(mp, "Assertion failed: %s, file: %s, line: %d",
> >  		expr, file, line);
> >  	WARN_ON(1);
> >  }
> >  
> >  void
> > -assfail(char *expr, char *file, int line)
> > +assfail(struct xfs_mount *mp, char *expr, char *file, int line)
> 
> Might be worth to change it to our usual prototype style while you're
> at it.
> 
> > -extern void assfail(char *expr, char *f, int l);
> > -extern void asswarn(char *expr, char *f, int l);
> > +extern void assfail(struct xfs_mount *mp, char *expr, char *f, int l);
> > +extern void asswarn(struct xfs_mount *mp, char *expr, char *f, int l);
> 
> And drop the pointless externs?
> 
> Otherwise this looks sane to me.

Fixed both of those.

--D
