Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBA1C2BA2B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 04:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10E3E2064A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 04:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d86y2/Jv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388479AbgDOEOZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 00:14:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52442 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgDOEOY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Apr 2020 00:14:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F4CfVG080013;
        Wed, 15 Apr 2020 04:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fIcZBcObczel5qg43mMQ3o32G5B6CaC0wp/OXVTQLE8=;
 b=d86y2/JvBVTxm+S83/D/ms49/RTGTrlTmXYafzhjcw/pnkTcjrE/lTy74Zol/uThzbGn
 1hIXPphX4KTjhbxZRyM5MTu4t9Pn2YkmKUbQFPY50Bemyh2BazdeEWcT6ZbaZwM/e57N
 oCV1ZSqCrMMCZrLYZNVkE7j/7GAtoO59Zvbgi51lpi017YetEaNDsb00I1PFAvircLRF
 xtVExbJQKAMr995Pkjf7u0y9IbtSQJik1E75NTTzWOV683dN+a6ZBKKZngZ2Mi/yZMiM
 0yfeGeQOG9+neUdsLAw1Bjl2jyKPTMuzLsdCuRZ7OBN0Ku/kHZ3xZRNeefZYsx1Mu0g6 Hg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30dn9ch03v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 04:14:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F4D9hS089847;
        Wed, 15 Apr 2020 04:14:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 30dn8v8neq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 04:14:18 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03F4EGYS000467;
        Wed, 15 Apr 2020 04:14:16 GMT
Received: from localhost (/10.159.240.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 21:14:16 -0700
Date:   Tue, 14 Apr 2020 21:14:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move inode flush to a workqueue
Message-ID: <20200415041415.GK6742@magnolia>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
 <158674021749.3253017.16036198065081499968.stgit@magnolia>
 <20200413123109.GB57285@bfoster>
 <20200414003121.GD6742@magnolia>
 <20200414090625.GW24067@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414090625.GW24067@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 14, 2020 at 07:06:25PM +1000, Dave Chinner wrote:
> On Mon, Apr 13, 2020 at 05:31:21PM -0700, Darrick J. Wong wrote:
> > On Mon, Apr 13, 2020 at 08:31:09AM -0400, Brian Foster wrote:
> > > On Sun, Apr 12, 2020 at 06:10:17PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Move the inode dirty data flushing to a workqueue so that multiple
> > > > threads can take advantage of a single thread's flush work.  The
> > > > ratelimiting technique was not successful, because threads that skipped
> > > > the inode flush scan due to ratelimiting would ENOSPC early and
> > > > apparently now there are complaints about that.  So make everyone wait.
> > > > 
> > > > Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > 
> > > Seems reasonable in general, but do we really want to to dump a longish
> > > running filesystem sync to the system workqueue? It looks like there are
> > > a lot of existing users so I can't really tell if there are major
> > > restrictions or not, but it seems risk of disruption is higher than
> > > necessary if we dump one or more full fs syncs to it..
> > 
> > Hmm, I guess I should look at the other flush_work user (the CIL) to see
> > if there's any potential for conflicts.  IIRC the system workqueue will
> > spawn more threads if someone blocks too long, but maybe we ought to
> > use system_long_wq for these kinds of things...
> 
> Why isn't this being put on the mp->m_sync_workqueue?

Oh. Heh. I forgot we had one of those.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
