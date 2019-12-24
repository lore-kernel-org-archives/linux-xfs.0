Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE8AC2D0CF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1BD720643
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 16:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkoquLlV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfLXQaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 11:30:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39420 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfLXQaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 11:30:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGOQJa103069;
        Tue, 24 Dec 2019 16:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=xlNqNPICMYLCCS6Nj/m+9YBsegxuXLh1nh95UtQ29/o=;
 b=BkoquLlVx9zPHqPvIQWIrajW9jJz5EdFoz4pRklyMXPtprto3JkFdUYAxD06YHiWNX7M
 Jc4JkWnpl9Z6WYKhJ1RxesrO1pnkakSJYi3F69mSfw0vuqAoUz9IHqyQ3vyk1ecqrONR
 9yuFlpljN5Tr+/5WJfI8/cJYjGYLbVxXf4Pl2hX8hvmbdlGi4a+O3gLQMhHn5knhAu4i
 naMTLf9eMqa/CYAbw/iyfD65F4a/WYr/kMm4uAco4gsZjtUVt5IaGRAe4OUrU0jV7aNP
 SYmIRLpjduND3KMW/LdsAT62jTAk6CLv1MJAoGACpEZPW32yLaJczd3En+S1ZIYccfTq yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x1attmcp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:30:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBOGOBhH130232;
        Tue, 24 Dec 2019 16:30:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x3brdrgfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Dec 2019 16:30:10 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBOGU5iv009353;
        Tue, 24 Dec 2019 16:30:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Dec 2019 08:30:04 -0800
Date:   Tue, 24 Dec 2019 08:30:04 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: truncate should remove all blocks, not just to the
 end of the page cache
Message-ID: <20191224163004.GX7489@magnolia>
References: <20191222163630.GS7489@magnolia>
 <20191224082127.GA26649@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224082127.GA26649@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912240143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9481 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912240143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 24, 2019 at 12:21:27AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 22, 2019 at 08:36:30AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_itruncate_extents_flags() is supposed to unmap every block in a file
> > from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
> > bunmapi range, even though s_maxbytes reflects the highest offset the
> > pagecache can support, not the highest offset that XFS supports.
> > 
> > The result of this confusion is that if you create a 20T file on a
> > 64-bit machine, mount the filesystem on a 32-bit machine, and remove the
> > file, we leak everything above 16T.  Fix this by capping the bunmapi
> > request at the maximum possible block offset, not s_maxbytes.
> > 
> > Fixes: 32972383ca462 ("xfs: make largest supported offset less shouty")
> 
> Why would that fix that commit?  The commit just changed how do derive
> the value, but not the value itself.

I'm not sure what to put for a fixes tag when the code in question is
from the bitkeeper era.

> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 401da197f012..eaa85d5933cb 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1544,9 +1544,12 @@ xfs_itruncate_extents_flags(
> >  	 * possible file size.  If the first block to be removed is
> >  	 * beyond the maximum file size (ie it is the same as last_block),
> >  	 * then there is nothing to do.
> > +	 *
> > +	 * We have to free all the blocks to the bmbt maximum offset, even if
> > +	 * the page cache can't scale that far.
> >  	 */
> >  	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
> > -	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > +	last_block = (1ULL << BMBT_STARTOFF_BITLEN) - 1;
> >  	if (first_unmap_block == last_block)
> >  		return 0;
> 
> That check is now never true.  I think that whole function wants some
> attenttion instead.  Kill that whole last_block calculation, switch to
> __xfs_bunmapi and pass ULLONG_MAX for the rlen input and just exit the
> loop once rlen is 0.

I'll give that a try.

--D
