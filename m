Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E71C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B18C4205CB
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 16:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rQzkegp+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgIVQmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 12:42:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgIVQmW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 12:42:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGdFOT092375;
        Tue, 22 Sep 2020 16:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RWXckNgSGK5YoxeMmJEHvGgb68wKDl8qPkkYro8lFgM=;
 b=rQzkegp+baavaPaUSuT68ha4P/PusEln8doWr+8h7DV+LUSqdxv9YbsqgSx/qj4bMSIx
 AJ8FCeTgBr0bEiWc/wZ3ZKLqDoGtSzfs2vBeA9xEPFvQc0FX9NMIYagWScdURyYaGYPR
 3h+9qlQMuDnZ02rCq+3/7oHhWh8G7OjIVVHBRHcNaZLjUggog6ycySklYb2HUe/9gxfx
 zNv6wzkgLWSe8X82jFN2uiM//F2ZvD8ILN+GQqD4JUXKze7L+EQPvAm1GjwN4Rryhf2A
 MbsJaJe+0RbuoRgxB3gS8WCHngvObJuC5c+1yCrDH5a6wJls3Wb9slaEGL2X14YSAqD5 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33q5rgc90k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 16:42:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MGZNoN016430;
        Tue, 22 Sep 2020 16:40:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33nuwynksq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 16:40:17 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08MGeGqS016384;
        Tue, 22 Sep 2020 16:40:16 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 09:40:15 -0700
Date:   Tue, 22 Sep 2020 09:40:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: drop the obsolete comment on filestream locking
Message-ID: <20200922164014.GK7955@magnolia>
References: <20200922034249.20549-1-hsiangkao.ref@aol.com>
 <20200922034249.20549-1-hsiangkao@aol.com>
 <20200922044428.GA4284@xiangao.remote.csb>
 <20200922160328.GG7955@magnolia>
 <20200922162328.GA1077@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922162328.GA1077@xiangao.remote.csb>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=1 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 12:23:28AM +0800, Gao Xiang wrote:
> Hi Darrick,
> 
> On Tue, Sep 22, 2020 at 09:03:28AM -0700, Darrick J. Wong wrote:
> > On Tue, Sep 22, 2020 at 12:44:28PM +0800, Gao Xiang wrote:
> > > On Tue, Sep 22, 2020 at 11:42:49AM +0800, Gao Xiang wrote:
> > > > From: Gao Xiang <hsiangkao@redhat.com>
> > > > 
> > > > Since commit 1c1c6ebcf52 ("xfs: Replace per-ag array with a radix
> > > > tree"), there is no m_peraglock anymore, so it's hard to understand
> > > > the described situation since per-ag is no longer an array and no
> > > > need to reallocate, call xfs_filestream_flush() in growfs.
> > > > 
> > > > In addition, the race condition for shrink feature is quite confusing
> > > > to me currently as well. Get rid of it instead.
> > > > 
> > > 
> > > (Add some words) I think I understand what the race condition could mean
> > > after shrink fs is landed then, but the main point for now is inconsistent
> > > between code and comment, and there is no infrastructure on shrinkfs so
> > > when shrink fs is landed, the locking rule on filestream should be refined
> > > or redesigned and xfs_filestream_flush() for shrinkfs which was once
> > > deleted by 1c1c6ebcf52 might be restored to drain out in-flight
> > > xfs_fstrm_item for these shrink AGs then.
> > > 
> > > From the current code logic, the comment has no use and has been outdated
> > > for years. Keep up with the code would be better IMO to save time.
> > 
> > Not being familiar with the filestream code at all, I wonder, what
> > replaced all that stuff?  Does that need a comment?  I can't really tell
> > at a quick glance what coordinates growfs with filestreams.
> 
> (try to cc Dave...)
> 
> I'm not quite familiar with filestream as well. After several days random
> glance about the constraint of shrink feature in XFS, I found such comment
> and try to understand such constraint.
> 
> Finally, I think it was useful only when perag was once an array and need
> to be reallocated (before 1c1c6ebcf52). So need to close the race by the
> m_peraglock (which is now deleted) and drain out in-flight AG filestream
> by xfs_filestream_flush() in growfs code (I think due to pag array
> reallocation). 
> 
> For now, m_peraglock and xfs_filestream_flush() in xfs_growfs_data_private()
> no longer exist... and we don't need to reallocate perag array but rather
> to use radix tree instead.

Yeah.  I guess you could shrink the comment to warn that any code
wanting to /remove/ an AG would need to be careful of the racy sequence
outlined in the three bullet points.  OTOH others have argued against
leaving comments that describe features we don't support.

But maybe it's better just to kill the whole comment like you proposed?

> but IMO, shrink an AG might need to restore to drain in-flight filestream,
> I couldn't tell much more of it... Overall, the current comment is quite
> confusing. I'd suggest it'd be better with some more reasonable comment
> about this at least...

Yes, you have to drain /all/ the incore state that pertains to an AG if
you're going to remove the AG.

--D

> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> 
