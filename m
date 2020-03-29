Return-Path: <SRS0=WYbU=5O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6082CC43331
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 16:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F5312073B
	for <linux-xfs@archiver.kernel.org>; Sun, 29 Mar 2020 16:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MzbemgCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgC2Qpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 12:45:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47842 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC2Qpr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 12:45:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02TGhNEn190411;
        Sun, 29 Mar 2020 16:45:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eKKE1PD0K6Ky5dSQ/a3Ptrs5v/9WRhCMf42gSc7Alv4=;
 b=MzbemgCbudS+GzH31lJhsKdpw6psd7RPHLvwet6nsrb5tMpUyRRUfNCPsNArVQ7bkF7T
 fWGHJ1fxxHFQI24ghk5ZwSAVVN9BjnnNjZ1d5lOIO49ggktB5haogtSVs45qxVfb6bJt
 NJ8wIf3QQ+YysIU/TM/18cA1Lsignk3u44/9wSFuUYe07iGibY6NIPc3Hi0FAETXuDVl
 9kVaCXbaDVKYHCeY6Fkcu7XugsBlHlM0AsxfwiBlq7+Jqqva4yFga04jSvf8JmcOG/U5
 BvFkhF+JMtH6Tkc/POKL8CotMiWyAL5AZgevrzr0y9W5wKWlL3TINrGUZJqz8/oO85tf rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 301x0qugte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Mar 2020 16:45:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02TGgoYG170736;
        Sun, 29 Mar 2020 16:43:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 302g2a5f62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Mar 2020 16:43:43 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02TGhhuh009986;
        Sun, 29 Mar 2020 16:43:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 29 Mar 2020 09:43:42 -0700
Date:   Sun, 29 Mar 2020 09:43:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: a couple AIL pushing trylock fixes
Message-ID: <20200329164342.GA56944@magnolia>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200327153205.GH29339@magnolia>
 <20200327164412.GA29156@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327164412.GA29156@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003290158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 clxscore=1015 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003290158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 27, 2020 at 12:44:12PM -0400, Brian Foster wrote:
> On Fri, Mar 27, 2020 at 08:32:05AM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 26, 2020 at 09:17:01AM -0400, Brian Foster wrote:
> > > Hi all,
> > > 
> > > Here's a couple more small fixes that fell out of the auto relog work.
> > > The dquot issue is actually a deadlock vector if we randomly relog dquot
> > > buffers (which is only done for test purposes), but I figure we should
> > > handle dquot buffers similar to how inode buffers are handled. Thoughts,
> > > reviews, flames appreciated.
> > 
> > Oops, I missed this one, will review now...
> > 
> > Do you think there needs to be an explicit testcase for this?  Or are
> > the current generic/{388,475} good enough?  I'm pretty sure I've seen
> > this exact deadlock on them every now and again, so we're probably
> > covered.
> > 
> 
> I'm actually not aware of a related upstream deadlock. That doesn't mean
> there isn't one of course, but the problem I hit was related to the
> random buffer relogging stuff in the auto relog series. I split these
> out because xfsaild is intended to be mostly async, so they seemed like a
> generic fixups..

<nod> FWIW I'd traced a generic/475 shutdown hang as far as "the AIL
seems to be stuck on a locked dquot buffer" but haven't really had a
chance to look into what was going on at the time.

Whereas before it would usually hang if I let it run more than about 15
minutes, now I've been able to get it to run all night to completion.

--D

> Brian
> 
> > --D
> > 
> > 
> > > Brian
> > > 
> > > Brian Foster (2):
> > >   xfs: trylock underlying buffer on dquot flush
> > >   xfs: return locked status of inode buffer on xfsaild push
> > > 
> > >  fs/xfs/xfs_dquot.c      |  6 +++---
> > >  fs/xfs/xfs_dquot_item.c |  3 ++-
> > >  fs/xfs/xfs_inode_item.c |  3 ++-
> > >  fs/xfs/xfs_qm.c         | 14 +++++++++-----
> > >  4 files changed, 16 insertions(+), 10 deletions(-)
> > > 
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
