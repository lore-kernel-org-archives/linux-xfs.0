Return-Path: <SRS0=ZINu=ZC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A7EC43331
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 00:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB8A420842
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Nov 2019 00:19:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UPV6k7N0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfKJATu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Nov 2019 19:19:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfKJATu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Nov 2019 19:19:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAA0ApCI002768;
        Sun, 10 Nov 2019 00:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qhobQCToVqd/69INeYKd8g8R6O0UlrBHXJvTCK+oJjI=;
 b=UPV6k7N0ZrM7Fa+CXpjJ2k3AzqeizpysuAsxFyvemgFmEgqx6SulPr9m5GXnKWpZkD9X
 3gFwGdoIeThD+1XgXAcnxvr7xS7bGmTti1FrQORT0ZEwQLKmSdj8S8pk/2+ATPDrUzvc
 R3eHI7h9ySqxDtpOCFgW5xIYsKNAin6prYChr9HScd+yF3mYKEEQEhLOeI/mov5wgg5y
 P0A71z25qsT0MiaKtIsufcEQqej43CNwzbAuFiGmMEOdftAEF7cVst/XOWrtGgvoDBeo
 dTV2ktTc2NG28Q9bFl2T25P3xwfhKlCyxIuUpWSkDf40Tsll8WIVZkWApbcWy3/SP9n/ hw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndpt4hw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 00:18:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAA07xJH120998;
        Sun, 10 Nov 2019 00:18:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w67kx91c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 10 Nov 2019 00:18:10 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAA0I4pe029887;
        Sun, 10 Nov 2019 00:18:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Nov 2019 16:18:03 -0800
Date:   Sat, 9 Nov 2019 16:18:03 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191110001803.GP6219@magnolia>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319672136.834699.13051359836285578031.stgit@magnolia>
 <20191109223238.GH4614@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109223238.GH4614@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911100000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9436 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911100000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 10, 2019 at 09:32:38AM +1100, Dave Chinner wrote:
> On Thu, Nov 07, 2019 at 11:05:21PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the last of the open coded corruption check and report idioms to
> > use the XFS_IS_CORRUPT macro.
> 
> hmmm.
> 
> > +	if (XFS_IS_CORRUPT(mp,
> > +	    ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
> 
> This pattern is weird. It looks like there are two separate logic
> statements to the if() condition, when in fact the second line is
> part of the XFS_IS_CORRUPT() macro.
> 
> It just looks wrong to me, especially when everything other
> multi-line macro is indented based on the indenting of the macro
> parameters....
> 
> Yes, in this case it looks a bit strange, too:
> 
> 	if (XFS_IS_CORRUPT(mp,
> 			   ir.loaded != XFS_IFORK_NEXTENTS(ip, whichfork))) {
> 
> but there is no mistaking it for separate logic statements.

They're all ugly, because of all the stupid identing when the
conditional gets too long.

> I kinda value being able to glance at the indent levels to see
> separate logic elements....
> 
> > -		if (unlikely(
> > -		       be32_to_cpu(sib_info->back) != last_blkno ||
> > -		       sib_info->magic != dead_info->magic)) {
> > -			XFS_ERROR_REPORT("xfs_da_swap_lastblock(3)",
> > -					 XFS_ERRLEVEL_LOW, mp);
> > +		if (XFS_IS_CORRUPT(mp,
> > +		    be32_to_cpu(sib_info->back) != last_blkno ||
> > +		    sib_info->magic != dead_info->magic)) {

They're both ugly, IMHO.  One has horrible indentation that's too close
to the code in the if statement body, the other is hard to read as an if
statement.

> >  			error = -EFSCORRUPTED;
> >  			goto done;
> >  		}
> 
> This is kind of what I mean - is it two or three  logic statments
> here? No, it's actually one, but it has two nested checks...
> 
> There's a few other list this that are somewhat non-obvious as to
> the logic...

I'd thought about giving it the shortest name possible, not bothering to
log the fsname that goes with the error report, and making the if part
of the macro:

#define IFBAD(cond) if ((unlikely(cond) ? assert(...), true : false))

IFBAD(be32_to_cpu(sib_info->back) != last_blkno ||
      sib_info->magic != dead_info->magic)) {
	xfs_whatever();
	return -EFSCORRUPTED;
}

Is that better?

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
