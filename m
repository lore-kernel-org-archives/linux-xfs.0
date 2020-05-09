Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80454C28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 19:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C28E20722
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 19:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kY3w0vIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgEITSQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 15:18:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgEITSP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 15:18:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049JCl3v132474;
        Sat, 9 May 2020 19:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JUQGWTCCkp0ctNksBQoqYeO9VMijc53OrMKKd5uCZ+4=;
 b=kY3w0vIbYaDYGa+tsN+GA0XOXen2t+02w55RSZlr1Z8UqcEMm7X2JnSLRSyqMS2i5WXV
 LwuY5a63EncxBDyZ2Pli6h0yev3fHnBZ/06QNKTtwneSXsNgYsNSKJH5G/Yr/EKSCQLY
 aGRdpt3/zzLP769FD8vHgRiK37Sj7Ny7ixy0djKsHXqdaQQ/O56JReUNbQAVOD79livH
 Zbs+UmrdhXT7+M+m2qhCtzCQXDlZ2JkUig5UfAasyreBq77UzKSmrNNv2yOUQGE3Ltj3
 dykqqh+ReXlzoCm+3ZjNCD6YnkSkNA1OZUM1V+rdOCwLNIZRceQHeN3m/BgT5EBEzEm4 Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30x0q104qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 19:18:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049JHgqk094294;
        Sat, 9 May 2020 19:18:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30wwxbamdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 19:18:07 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049JI4Ek010851;
        Sat, 9 May 2020 19:18:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 12:18:04 -0700
Date:   Sat, 9 May 2020 12:18:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] db: add a comment to agfl_crc_flds
Message-ID: <20200509191803.GW6714@magnolia>
References: <20200509170125.952508-1-hch@lst.de>
 <20200509170125.952508-4-hch@lst.de>
 <20200509170712.GQ6714@magnolia>
 <20200509171011.GA31656@lst.de>
 <d3683956-96b8-1308-9e66-2db56432da17@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3683956-96b8-1308-9e66-2db56432da17@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=971 adultscore=0
 suspectscore=1 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 suspectscore=1 phishscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 12:32:01PM -0500, Eric Sandeen wrote:
> On 5/9/20 12:10 PM, Christoph Hellwig wrote:
> > On Sat, May 09, 2020 at 10:07:12AM -0700, Darrick J. Wong wrote:
> >> On Sat, May 09, 2020 at 07:01:20PM +0200, Christoph Hellwig wrote:
> >>> Explain the bno field that is not actually part of the structure
> >>> anymore.
> >>>
> >>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >>> ---
> >>>  db/agfl.c | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/db/agfl.c b/db/agfl.c
> >>> index 45e4d6f9..ce7a2548 100644
> >>> --- a/db/agfl.c
> >>> +++ b/db/agfl.c
> >>> @@ -47,6 +47,7 @@ const field_t	agfl_crc_flds[] = {
> >>>  	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
> >>>  	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
> >>>  	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
> >>> +	/* the bno array really is behind the actual structure */
> >>
> >> Er... the bno array comes /after/ the actual structure, right?
> > 
> > Yes.  That's what I mean, but after seems to be less confusing.
> so:
> 
> /* the bno array is after the actual structure */
> 
> right?  I can just do that on merge.
> 

With that changed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

