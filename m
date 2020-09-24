Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D74C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B5B42311B
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vYfqCj/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgIXRtW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:49:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgIXRtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:49:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OHdYRt180047;
        Thu, 24 Sep 2020 17:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Fpg+BA0X/C6g8rTeT63NdAMxDcm5xCf1C+JfQ0OglhM=;
 b=vYfqCj/+lN7zUYFJRcH1WMQeqapECDqc7uUTjVinjBNh4t+YPy1lqF1KJ5PZjniga74M
 QKl9RxCbmYxzUK15r8iYrdIajjw3UkPcDKx6PqUwNfDl0GXQj9PXnVFsBIAYYQVx4dp0
 xKCQbsEH19NdRLBsNdP/PuN6RwyRrcrsJkR5y3PMkPRsqKjtm0MqXxProOda7aQlHfY1
 xtKY/DBCkWaCs0wAtT2Kqj+fuEvHr66OarHRvUbm0noiuMTRfpWqaWrqCDbhsMF37GaN
 JKmM7C+nRBpOQENdbjbz012L+Ogp4VlUJIXJRetbPHSejmrDGqQ4exum1pkzWP1i1vFv PA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33q5rgr2pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 17:49:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OHeVFP087309;
        Thu, 24 Sep 2020 17:49:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33nurwgrwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 17:49:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08OHnEm7014946;
        Thu, 24 Sep 2020 17:49:17 GMT
Received: from localhost (/10.159.232.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 10:49:14 -0700
Date:   Thu, 24 Sep 2020 10:49:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
Message-ID: <20200924174913.GI7955@magnolia>
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com>
 <20200924172600.GG7955@magnolia>
 <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be017461-6ce9-1d64-51d6-7e85a3e45055@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=1 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240131
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 12:39:07PM -0500, Eric Sandeen wrote:
> On 9/24/20 12:26 PM, Darrick J. Wong wrote:
> > On Thu, Sep 24, 2020 at 07:07:46PM +0200, Pavel Reichl wrote:
> >> ikeep/noikeep was a workaround for old DMAPI code which is no longer
> >> relevant.
> >>
> >> attr2/noattr2 - is for controlling upgrade behaviour from fixed attribute
> >> fork sizes in the inode (attr1) and dynamic attribute fork sizes (attr2).
> >> mkfs has defaulted to setting attr2 since 2007, hence just about every
> >> XFS filesystem out there in production right now uses attr2.
> >>
> >> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> >> ---
> >>  Documentation/admin-guide/xfs.rst |  2 ++
> >>  fs/xfs/xfs_super.c                | 30 +++++++++++++++++-------------
> >>  2 files changed, 19 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> >> index f461d6c33534..413f68efccc0 100644
> >> --- a/Documentation/admin-guide/xfs.rst
> >> +++ b/Documentation/admin-guide/xfs.rst
> >> @@ -217,6 +217,8 @@ Deprecated Mount Options
> >>  ===========================     ================
> >>    Name				Removal Schedule
> >>  ===========================     ================
> >> +  ikeep/noikeep			TBD
> >> +  attr2/noattr2			TBD
> > 
> > Er... what date did you have in mind?

June 65th, 2089 it is, then. ;)

> >>  ===========================     ================
> >>  
> >>  
> >> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> >> index 71ac6c1cdc36..4c26b283b7d8 100644
> >> --- a/fs/xfs/xfs_super.c
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -1234,25 +1234,12 @@ xfs_fc_parse_param(
> >>  	case Opt_nouuid:
> >>  		mp->m_flags |= XFS_MOUNT_NOUUID;
> >>  		return 0;
> >> -	case Opt_ikeep:
> >> -		mp->m_flags |= XFS_MOUNT_IKEEP;
> >> -		return 0;
> >> -	case Opt_noikeep:
> >> -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> >> -		return 0;
> >>  	case Opt_largeio:
> >>  		mp->m_flags |= XFS_MOUNT_LARGEIO;
> >>  		return 0;
> >>  	case Opt_nolargeio:
> >>  		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
> >>  		return 0;
> >> -	case Opt_attr2:
> >> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> >> -		return 0;
> >> -	case Opt_noattr2:
> >> -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> >> -		mp->m_flags |= XFS_MOUNT_NOATTR2;
> >> -		return 0;
> >>  	case Opt_filestreams:
> >>  		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
> >>  		return 0;
> >> @@ -1304,6 +1291,23 @@ xfs_fc_parse_param(
> >>  		xfs_mount_set_dax_mode(mp, result.uint_32);
> >>  		return 0;
> >>  #endif
> >> +	case Opt_ikeep:
> >> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> >> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> > 
> > It's a little odd that you didn't then remove these XFS_MOUNT_ flags.
> > It's strange to declare a mount option deprecated but still have it
> > change behavior.
> 
> but ... this doesn't change behavior, right?  The flag is still set.
> 
> I think it makes sense to announce deprecation, with a date set for future
> removal, but keep all other behavior the same.  That gives people who still
> need it (if any exist) time to complain, right?

Ok.  I'm fine with these knobs continuing to affect xfs behavior right
up to the deprecation date.

> > In this case, I guess we should keep ikeep/noikeep in the mount options
> > table so that scripts won't fail, but then we remove XFS_MOUNT_IKEEP and
> > change the codebase to always take the IKEEP behavior and delete the
> > code that handled the !IKEEP behavior.
> > 
> >> +		return 0;
> >> +	case Opt_noikeep:
> >> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> >> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> >> +		return 0;
> >> +	case Opt_attr2:
> >> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> >> +		mp->m_flags |= XFS_MOUNT_ATTR2;

Side note: shouldn't this clause be clearing XFS_MOUNT_NOATTR2?

> > 
> > If the kernel /does/ encounter an attr1 filesystem, what will it do now?
> 
> The same as it did yesterday; the flag is still set for now.
> 
> > IIRC the default (if there is no attr2/noattr2 mount option) is to
> > auto-upgrade the fs, right?  So will we stop doing that, or are we
> > making the upgrade mandatory now?
> > 
> >> +		return 0;
> >> +	case Opt_noattr2:
> >> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> >> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> >> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> > 
> > Also, uh, why move these code hunks?
> 
> That's my fault, I had suggested moving all the deprecated options to the end.
> 
> Maybe with a comment, /* REMOVE ME 2089 */ or whatever we pick?

Ah.

--D

> -Eric
