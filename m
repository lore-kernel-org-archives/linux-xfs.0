Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78F89C32771
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 494002071A
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 04:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iMZkrsn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbgAXEVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 23:21:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbgAXEVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 23:21:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4DchR185800;
        Fri, 24 Jan 2020 04:21:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=yTQWinuOZKZgWV0HeJtDSYX98yOn53KCSUxTTlIys3Y=;
 b=iMZkrsn0A2+h6pmfqQZhf4ZiCD28RRRSb/9Pc0iP2UQkRiXN1VUaNUYIFx9OAN7lB5wl
 FGdhfRKEjQjvha8a6TmWk7xqJYyk4b45K8+DTAI+sH7Iwj7HC89lcLz7JTd7+ToNephL
 DqinCG3wbZyHouIz0C5VLNIqWVicr5hfwlUmW5rE/BP6Nl+QeMGldAyyp1L4HGRztRvh
 yDe/TpSJK2BP/0IF5PY3vaSR3G7sHmi5C4GfkxEJEqAR7atF2uxEXPqT9+FfbwY90s4N
 JZtluKY501KsIvNhDEaGqaLZL2s0ps3jdowDC0H75voS42HNyDfH0tuaVf+ePYzLRqid JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnrpkhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:21:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O4EIu7038000;
        Fri, 24 Jan 2020 04:21:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xqmuy0jf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 04:21:29 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O4LM5B023930;
        Fri, 24 Jan 2020 04:21:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 20:21:21 -0800
Date:   Thu, 23 Jan 2020 20:21:19 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 12/12] xfs: fix xfs_buf_ioerror_alert location reporting
Message-ID: <20200124042119.GB8247@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976538741.2388944.8089997383572416484.stgit@magnolia>
 <20200124020727.GM7090@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124020727.GM7090@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 24, 2020 at 01:07:27PM +1100, Dave Chinner wrote:
> On Wed, Jan 22, 2020 at 11:43:07PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Instead of passing __func__ to the error reporting function, let's use
> > the return address builtins so that the messages actually tell you which
> > higher level function called the buffer functions.  This was previously
> > true for the xfs_buf_read callers, but not for the xfs_trans_read_buf
> > callers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_buf.c         |   12 +++++++-----
> >  fs/xfs/xfs_buf.h         |    7 ++++---
> >  fs/xfs/xfs_buf_item.c    |    2 +-
> >  fs/xfs/xfs_log_recover.c |    4 ++--
> >  fs/xfs/xfs_trans_buf.c   |    5 +++--
> >  5 files changed, 17 insertions(+), 13 deletions(-)
> 
> Makes sense, but I have a concern that this series now has added two
> new parameters to the buffer read functions. Perhaps we should consider
> wrapping this all up in an args structure?

Yes.  Next cycle I'll try to cough up a patchset to turn this into an
args structure so that callers can pass additional things like health
reporting breadcrumbs to the verifiers so that we can update that status
without having to explode a ton of error handling boilerplate all over
the place.

--D

> That's a separate piece
> of work, not for this patchset.
> 
> So far this patch,
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> -- 
> Dave Chinner
> david@fromorbit.com
