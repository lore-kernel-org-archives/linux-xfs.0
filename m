Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2F6C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 15:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F335214D9
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 15:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ijCQRRpm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388969AbfIPPRf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 11:17:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42308 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfIPPRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 11:17:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GFGxTs113780;
        Mon, 16 Sep 2019 15:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=IZWeFMojzX1f62nckIOe77ibhaJnQEjirjZjCj+Xshk=;
 b=ijCQRRpmDl+zrf8E0ETqbqe40fbYj+1YXMlG+IwbMwz6SoCQohqoWtRcCuglol7UpNKa
 PgqCARI0Ne9o1BuEh33zBeKBbx91Gt2f6FLEiiUm0WntCfd/NEdA8MUXC2ID2+nNqoe9
 At1kev4C0eSjAv0fQWtqvUbAqcSt94NzzXtKRFNXxwAVeRXylAhyD1XSINeRORyTl8Zg
 xGYigPi6dMdpuQdcpQD9h9Wopz70rBcLa0bCl/9G1o7INeHOhwOfcStbZy4aPn2H28Un
 cEL9tRgk9uryq6fyBSoLLMhpamWntHehNL4EIsIHQaph7iHmYne/RkdiUVngMZ0eFm9T xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v2bx2reab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 15:17:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8GFGPHW169050;
        Mon, 16 Sep 2019 15:17:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v0nb4usw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 15:17:22 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8GFHLRX017262;
        Mon, 16 Sep 2019 15:17:21 GMT
Received: from localhost (/10.159.225.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Sep 2019 08:17:20 -0700
Date:   Mon, 16 Sep 2019 08:17:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 04/10] man: document the new health reporting fields in
 various ioctls
Message-ID: <20190916151720.GT568270@magnolia>
References: <156757182283.1838441.193482978701233436.stgit@magnolia>
 <156757184781.1838441.4746750117807426676.stgit@magnolia>
 <36de43a2-9adb-73db-81a1-eecb665113ea@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36de43a2-9adb-73db-81a1-eecb665113ea@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909160156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9382 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909160156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 09, 2019 at 02:19:42PM -0500, Eric Sandeen wrote:
> On 9/3/19 11:37 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Update the manpages to conver the new health reporting fields in the
> > fs geometry, ag geometry, and bulkstat ioctls.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  man/man2/ioctl_xfs_ag_geometry.2   |   48 +++++++++++++++++++++++++++++++
> >  man/man2/ioctl_xfs_fsbulkstat.2    |   52 +++++++++++++++++++++++++++++++++
> >  man/man2/ioctl_xfs_fsop_geometry.2 |   56 +++++++++++++++++++++++++++++++++++-
> >  3 files changed, 154 insertions(+), 2 deletions(-)
> > 
> > 
> ...
> 
> > diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
> > index a8b22dc4..3e13cfa8 100644
> > --- a/man/man2/ioctl_xfs_fsbulkstat.2
> > +++ b/man/man2/ioctl_xfs_fsbulkstat.2
> > @@ -94,7 +94,9 @@ struct xfs_bstat {
> >  	__u16             bs_projid_lo;
> >  	__u16             bs_forkoff;
> >  	__u16             bs_projid_hi;
> > -	unsigned char     bs_pad[6];
> > +	uint16_t          bs_sick;
> > +	uint16_t          bs_checked;
> > +	unsigned char     bs_pad[2];
> >  	__u32             bs_cowextsize;
> >  	__u32             bs_dmevmask;
> >  	__u16             bs_dmstate;
> > @@ -184,6 +186,54 @@ is unused on Linux.
> >  .I bs_aextents
> >  is the number of storage mappings associated with this file's extended
> >  attributes.
> > +.PP
> > +The fields
> > +.IR bs_sick " and " bs_checked
> > +indicate the relative health of various allocation group metadata:
> 
> 
> This should probably say "inode metadata?" 

Yes it should have, thanks for fixing that.

--D

> I can fix that on the way in, the rest looks ok
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
