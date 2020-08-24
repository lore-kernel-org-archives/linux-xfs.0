Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7660BC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52B03206F7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 02:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GNUZa3i0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgHXCf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 22:35:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHXCfz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 22:35:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2Xvp2119324;
        Mon, 24 Aug 2020 02:35:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oEjGg+JMiaoMzOVnAdvvFthqxXC+uNPRgd5aT74cZ0k=;
 b=GNUZa3i0SpdvkSVusQenM4gOtXOvercqiBtwQnENc6Q9yJStw6CSZZeQDE/muhrJcgKu
 RdiCxLUf/HvtJRmFenpaa8SkGR33w7Dh0Ly1xnit8IyYreDPQAdXpSL53pHy3ie5BHjt
 mL7/bRXZpgRQO8WJTFfDi3A8QagNKLcXIruqIbbcxnw3r7mkuyQZqdjND9c5n4CJ+Uyz
 OxEwNwEQiAT4T3tGYDsnS6YuVDmGlN5JJyNhJu4Ed+PpAqUfTRcIDEFCcvpcH+nVrh/q
 isvXHanNiZts4wj6octe+zUFopGQwvpIET/JhrTuUnBjFLzTllrlHtTYoaBT8CdJLyY5 uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 333dbrj2r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 02:35:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O2ZAtQ063796;
        Mon, 24 Aug 2020 02:35:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 333r9gm8me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 02:35:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07O2ZiiR008973;
        Mon, 24 Aug 2020 02:35:44 GMT
Received: from localhost (/10.159.140.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Aug 2020 19:35:44 -0700
Date:   Sun, 23 Aug 2020 19:35:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 07/11] xfs: convert struct xfs_timestamp to union
Message-ID: <20200824023543.GQ6096@magnolia>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797593518.965217.18264791906308377426.stgit@magnolia>
 <20200822071830.GG1629@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200822071830.GG1629@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 22, 2020 at 08:18:30AM +0100, Christoph Hellwig wrote:
> On Thu, Aug 20, 2020 at 07:12:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the xfs_timestamp struct to a union so that we can overload it
> > in the next patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h     |   16 +++++++++-------
> >  fs/xfs/libxfs/xfs_inode_buf.c  |    4 ++--
> >  fs/xfs/libxfs/xfs_inode_buf.h  |    4 ++--
> >  fs/xfs/libxfs/xfs_log_format.h |   16 +++++++++-------
> >  fs/xfs/scrub/inode.c           |    2 +-
> >  fs/xfs/xfs_inode_item.c        |    6 +++---
> >  fs/xfs/xfs_ondisk.h            |    4 ++--
> >  7 files changed, 28 insertions(+), 24 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 1f3a2be6c396..772113db41aa 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -856,9 +856,11 @@ struct xfs_agfl {
> >   * Inode timestamps consist of signed 32-bit counters for seconds and
> >   * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
> >   */
> > -struct xfs_timestamp {
> > -	__be32		t_sec;		/* timestamp seconds */
> > -	__be32		t_nsec;		/* timestamp nanoseconds */
> > +union xfs_timestamp {
> > +	struct {
> > +		__be32		t_sec;		/* timestamp seconds */
> > +		__be32		t_nsec;		/* timestamp nanoseconds */
> > +	};
> >  };
> 
> Wouldn't it make sense to merge the typedef removal patch into this
> one to avoid touching all the users twice?

Will fix.  I wasn't sure if people would howl about making both changes
at once, and it's easier to combine two patches. ;)

--D
