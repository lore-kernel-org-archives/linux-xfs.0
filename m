Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E22C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A1C20716
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 22:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AzR2IICD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgAZW3P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 17:29:15 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZW3P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:29:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMRxiq074896
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2020 22:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=fwiKxR5Zbc0FCap+F5d+jOqMaN/fF/QfqpmdlWvv3v0=;
 b=AzR2IICDUeEFqSt2BVdirJzFonb4qVveJAsaqJBT5S49XO+a1vkUYAtrmSfhi4gCkj2H
 kTROWrdKEPtpbTqr6luP1cfGACrMueUFQCxva6+o10UlipHpIcPO+dh/fJwh0l0Q1hKU
 TnmVZH2/oPP0z9XrkY+Hbh7TNuMkYcpG5+2M/M1errTI8y/dlGw6n4z0yEf3JNYvNwG6
 SNXqe2Ub5/AbPZ4dv0EFeBVq7DYXKx3r03TIPiAVv5lLzJWuMXsbUx0+Fj7Z/oynhRFJ
 TW/Ak0REE+vsuP29lzOKjo5HrFjiKBYpaS5VBnAqD/L4pygZe0H+83YrKzRaXgCCsEbA sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xrd3tvhee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2020 22:29:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMT90T173390
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2020 22:29:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xryu83dhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2020 22:29:11 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QMSLIQ010435
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2020 22:28:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:28:21 -0800
Date:   Sun, 26 Jan 2020 14:28:20 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20200126222820.GL3447196@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-12-allison.henderson@oracle.com>
 <20200121231530.GK8247@magnolia>
 <68dcf7a7-9e10-2d64-9c5c-d520d2372c2b@oracle.com>
 <26a49cf4-52df-55bd-67bb-9c0c981a860d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26a49cf4-52df-55bd-67bb-9c0c981a860d@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260195
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260195
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 25, 2020 at 09:41:47AM -0700, Allison Collins wrote:
> On 1/21/20 9:29 PM, Allison Collins wrote:
> > 
> > 
> > On 1/21/20 4:15 PM, Darrick J. Wong wrote:
> > > On Sat, Jan 18, 2020 at 03:50:30PM -0700, Allison Collins wrote:
> > > > Delayed operations cannot return error codes.  So we must check for
> > > > these conditions first before starting set or remove operations
> > > 
> > > Answering my own question from earlier -- I see here you actually /are/
> > > checking the attr existence w.r.t. ATTR_{CREATE,REPLACE} right after we
> > > allocate a transaction and ILOCK the inode, so
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Alrighty, thank you!
> > 
> > > 
> > > Though I am wondering if you could discard the predicates from the
> > > second patch in favor of doing a normal lookup of the attr with a zero
> > > valuelen to determine if there's already an attribute?
> > I think I likely answered this in the response to that patch.  Because
> > it's used as part of the remove procedures, we still need it.  We could
> > make a simpler version just for this application I suppose, but it seems
> > like it'd just be extra code since we still need the former.
> > 
> > Thank you for the reviews!
> > Allison
> > 
> > > 
> > > --D
> > > 
> > > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > > ---
> > > >   fs/xfs/libxfs/xfs_attr.c | 12 ++++++++++++
> > > >   1 file changed, 12 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > > index a2673fe..e9d22c1 100644
> > > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > > @@ -457,6 +457,14 @@ xfs_attr_set(
> > > >           goto out_trans_cancel;
> > > >       xfs_trans_ijoin(args.trans, dp, 0);
> > > > +
> > > > +    error = xfs_has_attr(&args);
> > > > +    if (error == -EEXIST && (name->type & ATTR_CREATE))
> > > > +        goto out_trans_cancel;
> > > > +
> > > > +    if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> > > > +        goto out_trans_cancel;
> > > > +
> > > >       error = xfs_attr_set_args(&args);
> So I was thinking of adding this one to a smaller 3 patch series I mentioned
> earlier.  I was also thinking of adding in some asserts here:
> 
> ASSERT(error != -EEXIST)
> ASSERT(error != -ENOATTR)
> 
> Just to make sure the changes are enforcing the behavioral changes that we
> want.  I thought this might be a good stabilizer to the rest of the delayed
> attr series.  Because chasing this bug back up through the log replay is a
> much bigger PITA than catching it here.  Thoughts?

Er, are the asserts to check that xfs_attr_set_args never returns
EEXIST/ENOATTR?  I'm not sure why you'd have to chase this through log
replay?

/me is in this funny place where he thinks that in general adding
asserts (or WARN_ON) to check assumptions is a good idea, but not sure
what's going on here.

--D

> > > >       if (error)
> > > >           goto out_trans_cancel;
> > > > @@ -545,6 +553,10 @@ xfs_attr_remove(
> > > >        */
> > > >       xfs_trans_ijoin(args.trans, dp, 0);
> > > > +    error = xfs_has_attr(&args);
> > > > +    if (error != -EEXIST)
> > > > +        goto out;
> > > > +
> Here too:
> ASSERT(error != -EEXIST)
> 
> Let me know what folks think.  Thanks!
> 
> Allison
> 
> > > >       error = xfs_attr_remove_args(&args);
> > > >       if (error)
> > > >           goto out;
> > > > -- 
> > > > 2.7.4
> > > > 
