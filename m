Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAC7C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F42D2084C
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:50:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0CSIxPq5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgETUt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:49:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38658 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgETUt7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:49:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKlI2t025946;
        Wed, 20 May 2020 20:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=km5tmzIakY69eA1+Ha/E1Clybf+9oN1WNtJ12g+zfaU=;
 b=0CSIxPq5QRSL2RXyc//ZfDoxgXjsp9DatQG4CCX022tPakTQEnIOBzjaqgyCjeIYFBTx
 oYhryYk6YneDlCV4KWEBKJLPlHw2283yUq1Dashd/MNnlyjo38rRdSwIBVfqjNI/THmT
 yMXSNLDzZGUJpEy+rLJcMYLLp2nXvHjDrg1GZuniWEgaH4Yz4i56NBGCCJY53JN4UMMG
 sGlQeAkz8dXHB+mxGNuM8XDLGe0KYKhz4IHD1x+xMc5LsM+RpavBHs5r0BKuqCv4o2pp
 enDqc469YXBeYqM1mMnDGBiJJhxeO13LoNsPMXvR7Qwq92XbqwVLp/oDt6b2U0mmJDuz sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krdcny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:49:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKnA9T150610;
        Wed, 20 May 2020 20:49:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t38s6gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:49:54 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KKnrZW004496;
        Wed, 20 May 2020 20:49:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:49:53 -0700
Date:   Wed, 20 May 2020 13:49:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4.5/6] xfs: switch xfs_get_defquota to take explicit type
Message-ID: <20200520204952.GG17627@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <842a7671-b514-d698-b996-5c1ccf65a6ad@redhat.com>
 <e27a2dff-f728-f69e-32b6-a83eee7effef@redhat.com>
 <0368b615-37af-27fb-b267-b7846f3b73d9@redhat.com>
 <20200520203655.GC17627@magnolia>
 <a969f025-9660-0e6c-3e4a-3b3f4cce1b53@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a969f025-9660-0e6c-3e4a-3b3f4cce1b53@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 03:41:03PM -0500, Eric Sandeen wrote:
> On 5/20/20 3:36 PM, Darrick J. Wong wrote:
> > On Wed, May 20, 2020 at 01:41:25PM -0500, Eric Sandeen wrote:
> >> xfs_get_defquota() currently takes an xfs_dquot, and from that obtains
> >> the type of default quota we should get (user/group/project).
> >>
> >> But early in init, we don't have access to a fully set up quota, and
> >> so we will fail to set these defaults.
> >>
> >> Switch xfs_get_defquota to take an explicit type, and add a helper 
> >> function to obtain that type from an xfs_dquot for the existing
> >> callers.
> > 
> > Ah, so this patch isn't itself fixing anything, it's preparing code for
> > something that happens in the next patch.
> 
> yeah sorry that could be clearer, "fix" on the brain, can edit commit log.

Sorry, stream of consciosuness on my part, nothing in this patch
actually said "fix".

> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ...
> 
> >>  
> >> +static inline int
> >> +xfs_dquot_type(struct xfs_dquot *dqp)
> >> +{
> >> +	if (XFS_QM_ISUDQ(dqp))
> >> +		return XFS_DQ_USER;
> >> +	else if (XFS_QM_ISGDQ(dqp))
> >> +		return XFS_DQ_GROUP;
> >> +	else {
> >> +		ASSERT(XFS_QM_ISPDQ(dqp));
> >> +		return XFS_DQ_PROJ;
> > 
> > /me suspects this could be tidier, e.g.
> > 
> > if (UDQ)
> > 	return XFS_DQ_USER;
> > if (GDQ)
> > 	return XFS_DQ_GROUP;
> > ASSERT(PDQ);
> > return XFS_DQ_PROJ;
> > 
> > Otherwise the rest looks ok.
> 
> I suppose, so respin or no?

I fixed up this patch and the next one in my test tree, let's see what
breaks.  I retested all the tests I whined about earlier and they're
fixed now except for generic/594 which might just be ... busted?  Or
maybe I forgot to send a patch...?

--D
