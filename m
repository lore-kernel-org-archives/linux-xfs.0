Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086C6C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D629321556
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 18:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vibh7eqh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgBYSsy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:48:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50526 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYSsy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 13:48:54 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIgrhb109089;
        Tue, 25 Feb 2020 18:48:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bIkRvwgqFfLC8wfm++ZsynS7NP1b6RdNlppPDRdrkz4=;
 b=vibh7eqhmH+wcZ8oAa/i2G49il75v8Ffjk0If3e3C0i6/Bfe59uAVv1hAFWjSME/4lHe
 4Gu1r7et8ccW4v/NAzofcP541AZK5HeujXKef66srTS0UIMxfVl6PZ/dnKf4fcBQNMgl
 mkiMi78Q1Hbx5PAbLWrXHDdTWQOA0WHbDoAD+TGncgiaaF90ZN7xn8fuX+uGUk+c+nVN
 s2m3x4IhO8COXZptMEDX91Se0DNorR+MRCjAUebwS+ocuNxd0eksbTMWneWYQjU0rVkr
 OiOgXhiuBVxb6V0kyF/LqjXQ6iONG5omddNM1tUmase3k296yZkWTn1faZZFm/xeooJ0 OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yd0m1udje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:48:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PIiEOn014681;
        Tue, 25 Feb 2020 18:48:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yd17qkhf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 18:48:49 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PImmkn023439;
        Tue, 25 Feb 2020 18:48:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 10:48:48 -0800
Date:   Tue, 25 Feb 2020 10:48:47 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/25] libxfs: convert libxfs_log_clear to use uncached
 buffers
Message-ID: <20200225184847.GL6740@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
 <158258957631.451378.6297312804413916157.stgit@magnolia>
 <20200225174941.GO20570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225174941.GO20570@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 09:49:41AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 24, 2020 at 04:12:56PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the log clearing function to use uncached buffers like
> > everything else, instead of using the raw buffer get/put functions.
> > This will eventually enable us to hide them more effectively.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/rdwr.c |   16 ++++++----------
> >  1 file changed, 6 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index d607a565..739f4aed 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -1413,15 +1413,13 @@ libxfs_log_clear(
> >  	/* write out the first log record */
> >  	ptr = dptr;
> >  	if (btp) {
> > -		bp = libxfs_getbufr(btp, start, len);
> > +		bp = libxfs_getbufr_uncached(btp, start, len);
> 
> Any reason this isn't using the public libxfs_buf_get_uncached
> function?  Yes, that requires setting up the address, but it avoids
> a dependency on internal helpers.
> 
> And I think we should add initializing the block, zeroing the buffer
> and setting up ops into (lib)xfs_buf_get_uncached, basically moving
> most of xfs_get_aghdr_buf into and improve the API eventually.

We can certainly do that for kernel 5.7, but please keep in mind that
we're currently reviewing changes for xfsprogs 5.6, and it's too late in
the kernel 5.6 cycle to be messing around with core xfs apis.

--D
