Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333B1C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED059206F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 23:34:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vYqORvBX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELXey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 19:34:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38280 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELXey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:34:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNX7Iu196008;
        Tue, 12 May 2020 23:34:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D8sqhhL61S5VjJ6VlxrKEgOpz0K1Yw0W+wdT4Oh1czU=;
 b=vYqORvBXYBbIZtmL5Kw10yguJsfiZUEEqkrmau/b4NT3EyF4nsOVMnWTuAYtVCIFtEsz
 rR1nNb5XJhn6Xb+8ol+1IsDozBWBVLLlTsh9s4TjyxfuHjU725+K7E6KJ6m8UW/3kly4
 Fqk6WpansIK8D/NKCvJVNLCikWMm/gdZVXrsOL0IDd8sAxUl2IOQmJJ+GEHnGkpbwMYe
 JVjS+Bl3CKbjLkccfAtW2oCzRdN8I3eLuahZU3FqnWoHZEHxIn4YRAikt6vi1E4xEeyp
 49dtoiJZrDmjLJtVK7+S2jhwGbW3/FhR+A6lJmEQ0HRrk8l6JEabq0GEH6pDhYhnqmm4 HQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3100xwh85w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 23:34:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CNWPDd046066;
        Tue, 12 May 2020 23:34:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3100yjtcs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 23:34:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CNYiBw008626;
        Tue, 12 May 2020 23:34:44 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 16:34:44 -0700
Date:   Tue, 12 May 2020 16:34:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: remove XFS_QMOPT_ENOSPC flag
Message-ID: <20200512233443.GP6714@magnolia>
References: <447d7fec-2eff-fa99-cd19-acdf353c80d4@redhat.com>
 <11a44fb8-d59d-2e57-73bd-06e216efa5e7@redhat.com>
 <20200508130154.GC27577@bfoster>
 <57c07fd1-9dd1-8a03-da29-2b1b99cfa2ed@sandeen.net>
 <20200508162129.GJ27577@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508162129.GJ27577@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 12:21:29PM -0400, Brian Foster wrote:
> On Fri, May 08, 2020 at 10:45:48AM -0500, Eric Sandeen wrote:
> > On 5/8/20 8:01 AM, Brian Foster wrote:
> > > On Thu, May 07, 2020 at 11:00:34PM -0500, Eric Sandeen wrote:
> > >> The only place we return -EDQUOT, and therefore need to make a decision
> > >> about returning -ENOSPC for project quota instead, is in xfs_trans_dqresv().
> > >>
> > >> So there's no reason to be setting and clearing XFS_QMOPT_ENOSPC at higher
> > >> levels; if xfs_trans_dqresv has failed, test if the dqp we were were handed
> > >> is a project quota and if so, return -ENOSPC instead of EDQUOT.  The
> > >> complexity is just a leftover from when project & group quota were mutually
> > >> exclusive and shared some codepaths.
> > >>
> > >> The prior patch was the trivial bugfix, this is the slightly more involved
> > >> cleanup.
> > >>
> > >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > >> ---
> > > 
> > > Hmm so what about callers that don't pass QMOPT_ENOSPC? For example, it
> > > looks like various xfs_trans_reserve_quota() calls pass a pdqp but don't
> > > set the flag.
> > 
> > Oh, interesting.  I bet that was an oversight, tbh, but let's see.
> > 
> > <rewinds 14 years>
> > 
> > commit 9a2a7de268f67fea0c450ed3e99a2d31f43d7166
> > Author: Nathan Scott <nathans@sgi.com>
> > Date:   Fri Mar 31 13:04:49 2006 +1000
> > 
> >     [XFS] Make project quota enforcement return an error code consistent with
> >     its use.
> > 
> > so yeah, even back then, stuff like xfs_symlink returned EDQUOT not ENOSPC.
> > 
> > Today, these call the reservation w/o the special ENOSPC flag:
> > 
> > xfs_unmap_extent
> > xfs_create
> > xfs_create_tmpfile
> > xfs_symlink
> > 
> > and so will return EDQUOT instead of ENOSPC even for project quota.
> > 
> > You're right that my patch changes these to ENOSPC.
> > 
> > > Is the intent to change behavior such that -ENOSPC is
> > > unconditional for project quota reservation failures?
> > 
> > Now it's a conundrum.  I /think/ the current behavior is due to an oversight, but 
> > 
> > a) I'm not certain, and
> > b) can we change it now?
> > 
> 
> Heh, I can't really tell what the intended/expected behavior is. For
> whatever it's worth, it seems reasonable enough to me to change it based
> on the fact that project quotas have been expected to return -ENOSPC in
> at least some common cases for many years. It seems unlikely that users
> would know or care about the change in behavior in the subset noted
> above, but who knows. It might be good to get some other opinions. :P

"I bet you a beer at the next conference (if they ever happen again)
that nobody will notice"? :P

TBH while I find it a little odd that project quota gets to return
ENOSPC instead of EDQUOT, I find it more odd that sometimes it doesn't.
This at least gets us to consistent behavior (EDQUOT for user/group,
ENOSPC for project) so for the series:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Let's see what an fstests run spits out...)

--D

> Brian
> 
> > -Eric
> > 
> 
