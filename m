Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586C7C2BA19
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281012312D
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 18:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392189AbhASSQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 13:16:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:49710 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392416AbhASSQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 13:16:35 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAPJ3079482;
        Tue, 19 Jan 2021 18:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : reply-to : references : mime-version :
 content-type : in-reply-to; s=corp-2020-01-29;
 bh=u78pb4rUqotNubZsWb2K90m1cMSnQLh16IpjHAt5kvE=;
 b=VMzmj17L2zWCbMBWnEXmeY8xLP8hBouWo6bYlZy1tLwrpLWYNdjdLmTbd4Zqesw0wIIA
 DiOtlRw4mNDhEw64H1P6mpvHtIScPwY1waMpo1X6EJRA/Ktp87U8HjDMNSAzQwqyzzwq
 6/KIZku7WaW4roSrzeC2/AFOtU3Ca5dTERaLm1q/HEz1pC7YqURJgdRabtFdbsxRzpFV
 cVuaQJbvEqoVOe/Bq6uy3yI1+/BP7a4RWTOIYi5VsIjkC8q5XzxQvyK3OKggr8yFa4y/
 E4wmUBxEYVkySrBk8x0Hcn/Re75aoJF8TJz1IL9kGGtCigyQ4gd+mcBL6KhtqTzRjQX8 +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 363nnajjps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:15:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAZLG063686;
        Tue, 19 Jan 2021 18:15:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3649qppmcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:15:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIFom3018378;
        Tue, 19 Jan 2021 18:15:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:15:50 -0800
Date:   Tue, 19 Jan 2021 10:15:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210119180318.GP3134581@magnolia>
Reply-To: "Darrick J. Wong" <djwong@kernel.org>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
 <20210119143754.GB1646807@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119143754.GB1646807@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 19, 2021 at 09:37:54AM -0500, Brian Foster wrote:
> On Fri, Jan 15, 2021 at 05:24:53PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Clear the needsrepair flag, since it's used to prevent mounting of an
> > inconsistent filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Code/errors look much cleaner. Though looking at the repair code again,
> I wonder... if we clear the needsrepair bit and dirty/write the sb in
> phase 2 and then xfs_repair happens to crash, do we risk clearing the
> bit and thus allowing a potential mount before whatever requisite
> metadata updates have been made?

[Oh good, now mail.kernel.org is having problems...]

Yes, though I think that falls into the realm of "sysadmins should be
sufficiently self-aware not to expect mount to work after repair
fails/system crashes during an upgrade".

I've thought about how to solve the general problem of preventing people
from mounting filesystems if repair doesn't run to completion.  I think
xfs_repair could be modified so that once it finds the primary super, it
writes it back out with NEEDSREPAIR set (V5) or inprogress set (V4).
Once we've finished the buffer cache flush at the end of repair, we
clear needsrepair/inprogress and write the primary super again.

An optimization on that would be to find a way to avoid that first super
write until we flush the first dirty buffer.

Another way to make repair more "transactional" would be to do it would
be to fiddle with the buffer manager so that writes are sent to a
metadump file which could be mdrestore'd if repair completes
successfully.  But that's a short-circuit around the even bigger project
of porting the kernel logging code to userspace and use that in repair.

--D

> Brian
> 
> >  repair/agheader.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > 
> > diff --git a/repair/agheader.c b/repair/agheader.c
> > index 8bb99489..d9b72d3a 100644
> > --- a/repair/agheader.c
> > +++ b/repair/agheader.c
> > @@ -452,6 +452,21 @@ secondary_sb_whack(
> >  			rval |= XR_AG_SB_SEC;
> >  	}
> >  
> > +	if (xfs_sb_version_needsrepair(sb)) {
> > +		if (!no_modify)
> > +			sb->sb_features_incompat &=
> > +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +		if (i == 0) {
> > +			if (!no_modify)
> > +				do_warn(
> > +	_("clearing needsrepair flag and regenerating metadata\n"));
> > +			else
> > +				do_warn(
> > +	_("would clear needsrepair flag and regenerate metadata\n"));
> > +		}
> > +		rval |= XR_AG_SB_SEC;
> > +	}
> > +
> >  	return(rval);
> >  }
> >  
> > 
> 
