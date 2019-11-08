Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC17FC6199
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55829215EA
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 21:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ehGq8aZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfKHVvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 16:51:21 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHVvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 16:51:21 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8LmsEa010625
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8hOUInkB4wNDaVY9vq6IKNAkwbebsirnnh4oFbGkb/U=;
 b=ehGq8aZUOJZzO7lTxZsYRO+nxcHquoaqEj66FVnGJVoXr/mlipM7OxBbrk98JVZUoJ/R
 S/2Bsjh0ue6Mq1uSafdTluceNds7Hgu0dclkZ0mSjRVusav+ANLv9FdWictgZ+earhbH
 hq8zql4Zo+rvXV+ebKWCLd/tzfCIjKmBDrS5ORqf5eH+8kuZNKZjIoZ5IFsekX6ACDEG
 mjNO+1P2ihmiByxAaYK4jVuCQqjX7gDwMZ/Cfq3CCRF9RNb2IRRfONhpTCKst8QELVlj
 TjksJ1hcy22AQUtsCsayJWIMHQkO4E7P2n3Y5t8BuONVyZxFDyLSg+FM1MSh2ILE6g5e FA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w17uvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:51:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8Lmeob084998
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:51:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w4k34gjkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 21:51:19 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8LpI0m000982
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 21:51:18 GMT
Received: from localhost (/10.159.140.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 13:51:17 -0800
Date:   Fri, 8 Nov 2019 13:51:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 15/17] xfs: Check for -ENOATTR or -EEXIST
Message-ID: <20191108215116.GJ6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-16-allison.henderson@oracle.com>
 <20191108212833.GF6219@magnolia>
 <59ef241e-b7c3-bc9e-7786-073972b7af35@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59ef241e-b7c3-bc9e-7786-073972b7af35@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080209
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 02:42:52PM -0700, Allison Collins wrote:
> On 11/8/19 2:28 PM, Darrick J. Wong wrote:
> > On Wed, Nov 06, 2019 at 06:27:59PM -0700, Allison Collins wrote:
> > > Delayed operations cannot return error codes.  So we must check for
> > > these conditions first before starting set or remove operations
> > > 
> > > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++++++++++++++++
> > >   1 file changed, 25 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 5dcb19f..626d4a98 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -458,6 +458,27 @@ xfs_attr_set(
> > >   		goto out_trans_cancel;
> > >   	xfs_trans_ijoin(args.trans, dp, 0);
> > > +
> > > +	error = xfs_has_attr(&args);
> > > +	if (error == -EEXIST) {
> > > +		if (name->type & ATTR_CREATE)
> > > +			goto out_trans_cancel;
> > > +		else
> > > +			name->type |= ATTR_REPLACE;
> > > +	}
> > > +
> > > +	if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> > > +		goto out_trans_cancel;
> > > +
> > > +	if (name->type & ATTR_REPLACE) {
> > > +		name->type &= ~ATTR_REPLACE;
> > > +		error = xfs_attr_remove_args(&args);
> > > +		if (error)
> > > +			goto out_trans_cancel;
> > > +
> > > +		name->type |= ATTR_CREATE;
> > 
> > I thought _set_args already handled the remove part of replacing an
> > attr?
> No, IIRC in one of the other reviews we decided to break the rename into a
> set and then a remove.

But this looks like we remove the old attr before setting the new one,
which means that if we crash right here we'll come back up with no attr
at all.  The INCOMPLETE flag flipping trick only works for ATTR_REPLACE
if you add the new attr before removing the old one.

(Or am I misreading something here?)

> That way the error handling moves up here instead of
> trying to deal with it in the middle of the delayed operation

Sounds good.

> > And I thought that it did this with an atomic rename?  Won't this
> > break the atomicity of attr replacement?

> Hmm, think this worked for delayed operations, but not anymore since we're
> going back to supporting both delayed and inline in one code path.  I think
> what this means is that the flip flag has to get moved in here, right?  We
> flip on the incomplete flag before the remove and then set it when the
> rename is done?

Yeah.

--D

> 
> > 
> > --D
> > 
> > > +	}
> > > +
> > >   	error = xfs_attr_set_args(&args);
> > >   	if (error)
> > >   		goto out_trans_cancel;
> > > @@ -543,6 +564,10 @@ xfs_attr_remove(
> > >   	 */
> > >   	xfs_trans_ijoin(args.trans, dp, 0);
> > > +	error = xfs_has_attr(&args);
> > > +	if (error == -ENOATTR)
> > > +		goto out;
> > > +
> > >   	error = xfs_attr_remove_args(&args);
> > >   	if (error)
> > >   		goto out;
> > > -- 
> > > 2.7.4
> > > 
