Return-Path: <SRS0=IeGX=YO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C8FCA9EAF
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 18:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 093C720873
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Oct 2019 18:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b2MIAzHM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbfJUSPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Oct 2019 14:15:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSPQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Oct 2019 14:15:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LI8u1R066269;
        Mon, 21 Oct 2019 18:15:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=hVM46QrmiNcPb3DxdmmMs9gccVkrnqIk8d5JuBzHqLU=;
 b=b2MIAzHM4xO4UTjRYzrX/KyRWdtGtgOm5gxzzRBYYFgeCiJav+gOH1J0yQapd0k7gfjF
 1jBspET9iLUjPDSaJklekgnRm+EUZ7zeOJH8/gncCETfAPSytzJ1pndi34FNNbtQp//E
 oMn4g0VbUxzYGQFnJdk+im8wBMIONiqGUL+3ELbfiECC6S+NrdU2YhTsfzNJ41x0+PYA
 kVf8cnCujW5VR9Hq8N94FjSmZoI5K8tcOSOJtxrOl1N53POZDiDvS4nBvHoB/66b6rIw
 rmp1THHNL9BTSkBSR+p/wUCouzhPrpJzxfgkd2mQuK/HqjJ43wy++XNUFUWdcGJAiPT+ iQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswt9m2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 18:15:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9LIDPdJ064908;
        Mon, 21 Oct 2019 18:15:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vrc005kuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Oct 2019 18:15:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9LIFChI005133;
        Mon, 21 Oct 2019 18:15:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 11:15:12 -0700
Date:   Mon, 21 Oct 2019 11:15:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs_scrub: request fewer bmaps when we can
Message-ID: <20191021181511.GE913374@magnolia>
References: <156944736739.300131.5717633994765951730.stgit@magnolia>
 <156944741018.300131.13838435268141846825.stgit@magnolia>
 <220f16b6-8604-7f83-924c-3a148e0dd5cb@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <220f16b6-8604-7f83-924c-3a148e0dd5cb@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910210174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910210174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 01:05:06PM -0500, Eric Sandeen wrote:
> On 9/25/19 4:36 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In xfs_iterate_filemaps, we query the number of bmaps for a given file
> > that we're going to iterate, so feed that information to bmap so that
> > the kernel won't waste time allocating in-kernel memory unnecessarily.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/filemap.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/scrub/filemap.c b/scrub/filemap.c
> > index bdc6d8f9..aaaa0521 100644
> > --- a/scrub/filemap.c
> > +++ b/scrub/filemap.c
> > @@ -71,7 +71,6 @@ xfs_iterate_filemaps(
> >  		map->bmv_length = ULLONG_MAX;
> >  	else
> >  		map->bmv_length = BTOBB(key->bm_length);
> > -	map->bmv_count = BMAP_NR;
> >  	map->bmv_iflags = BMV_IF_NO_DMAPI_READ | BMV_IF_PREALLOC |
> >  			  BMV_IF_NO_HOLES;
> >  	switch (whichfork) {
> > @@ -96,6 +95,7 @@ xfs_iterate_filemaps(
> >  		moveon = false;
> >  		goto out;
> >  	}
> > +	map->bmv_count = min(fsx.fsx_nextents + 2, BMAP_NR);
> 
> Was going to ask you to document the magical +2 here but IRC discussion suggests
> that it is in case fsx_nextents is 0, and we need to send in a count of at least
> 2 (header + 1 structure?)
> 
> But if there are no extents, what are we trying to map in the loop below,
> anyway?

Nothing.  Will rework it with:

if (fsx_nextents == 0)
	return 0;

bmv_count = min(fsx_nextents + 1, BMAP_NR);

while ((error = ioctl(...))) {

--D

> >  
> >  	while ((error = ioctl(fd, XFS_IOC_GETBMAPX, map)) == 0) {
> >  		for (i = 0, p = &map[i + 1]; i < map->bmv_entries; i++, p++) {
> > 
