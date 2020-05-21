Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB147C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 17:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADB720759
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 17:19:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BFuTmJJp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgEURTw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 13:19:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbgEURTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 13:19:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LH8Kgi142204;
        Thu, 21 May 2020 17:19:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Gj6+A4+wqZgYofSIK882vPDk1CaxzH7Clndc/2DlUwY=;
 b=BFuTmJJpvyVEorPE+5rI2nZWCCdItYyxfQRKMpnl1fCHklsLOEfbjXV9waUlHNB3z3Mr
 h5YFZZFt6ZhHUlSvdh6p40mubhcEWlZMdDTxxbm1kjsLVr7BgYF/Lu7lKjfqcqxcGri7
 oO5Nd1uaZAaq2JcHvEKSBeOXtj/TdIe8A7HEkQ9zi1oL3UgPa4u0molYgyRMi7TsR1L4
 e1Ic/eAbI0XbJ5s3ZxlmCZnipszwWHViXps/U6pjz62bDVnokidygmR5qr7/gtKcb8Tq
 LdtDzCJxvbIKDgkt5RuokPaxNMrSZb5geYslnJINKpJ2gEBr7QzqIo7dqFzruhQolrLE Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284m9rdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 17:19:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHJGmN117035;
        Thu, 21 May 2020 17:19:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t3bta6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 17:19:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LHJhhm023989;
        Thu, 21 May 2020 17:19:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 10:19:42 -0700
Date:   Thu, 21 May 2020 10:19:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: measure all contiguous previous extents for
 prealloc size
Message-ID: <20200521171941.GJ17627@magnolia>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984936387.619853.12262802837092587871.stgit@magnolia>
 <20200519125437.GA15081@infradead.org>
 <20200520211716.GH17627@magnolia>
 <20200521093140.GA17015@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521093140.GA17015@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 21, 2020 at 02:31:40AM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 02:17:16PM -0700, Darrick J. Wong wrote:
> > On Tue, May 19, 2020 at 05:54:37AM -0700, Christoph Hellwig wrote:
> > > The actual logic looks good, but I think the new helper and another
> > > third set of comment explaining what is going on makes this area even
> > > more confusing.  What about something like this instead?
> > 
> > This seems reasonable, but the callsite cleanups ought to be a separate
> > patch from the behavior change.
> 
> Do you want me to send prep patches, or do you want to split it our
> yourself?

I split them already, so I'll send v2 shortly.

> > > +	if (eof && offset + count > XFS_ISIZE(ip)) {
> > > +		/*
> > > +		 * Determine the initial size of the preallocation.
> > > + 		 * We clean up any extra preallocation when the file is closed.
> > > +		 */
> > > +		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
> > > +			prealloc_blocks = mp->m_allocsize_blocks;
> > > +		else
> > > +			prealloc_blocks = xfs_iomap_prealloc_size(ip, allocfork,
> > > +						offset, count, &icur);
> > 
> > I'm not sure how much we're really gaining from moving the
> > MOUNT_ALLOCSIZE check out to the caller, but I don't feel all that
> > passionate about this.
> 
> From the pure code stats point of view it doensn't matter.  But from the
> software architecture POV it does - now xfs_iomap_prealloc_size contains
> the dynamic prealloc size algorithm, while the hard coded case is
> handled in the caller.

<nod>

--D
