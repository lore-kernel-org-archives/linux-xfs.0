Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98841C282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 22:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6869820692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 22:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LKAm9INB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAHWeT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 17:34:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHWeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 17:34:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008MXG3n148936;
        Wed, 8 Jan 2020 22:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=YmNHml4PsKblUIIChXKrFxwsKFEZ+44OpH8dDU+WcQ4=;
 b=LKAm9INBIibOKqojG2PqkAbsG5jAvJM2zdMf1G2VGTEUr3I4w+rYpD6PGZnkhu65IWvD
 ymEIzTtoEwZMPaoG/C67/KaJmwEYA6NIzkPPtZtEPkJDiEkRJ+n7GMlHVWUUULmA+9Eo
 rbyv9c5NPiXmqkMUz+Kq5EUiVQNnfcgY1sXdSnzSd9AGjco69cRjIQoKTgE62aY2qdJs
 eiYxEO68GjAwqJwg3ESkGJm4811mLgpDO8rzcOl6yptaVU+UgD3WfaqAy34XCPydbR3z
 xiTAE9LDSnxNqMFgr4XWYdY+IwNiKySfMjTZAiJC4qiQ2TnszgJo3toapYpDjXyT08uW Gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbqxwej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 22:34:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008MY48L040236;
        Wed, 8 Jan 2020 22:34:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xdmrwtqff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 22:34:09 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 008MXk6B015383;
        Wed, 8 Jan 2020 22:33:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 14:33:46 -0800
Date:   Wed, 8 Jan 2020 14:33:45 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: make struct xfs_buf_log_format have a
 consistent size
Message-ID: <20200108223345.GL5552@magnolia>
References: <157845708352.84011.17764262087965041304.stgit@magnolia>
 <157845710512.84011.14528616369807048509.stgit@magnolia>
 <20200108215120.GG23128@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108215120.GG23128@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 09, 2020 at 08:51:20AM +1100, Dave Chinner wrote:
> On Tue, Jan 07, 2020 at 08:18:25PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Increase XFS_BLF_DATAMAP_SIZE by 1 to fill in the implied padding at the
> > end of struct xfs_buf_log_format.  This makes the size consistent so
> > that we can check it in xfs_ondisk.h, and will be needed once we start
> > logging attribute values.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h |    9 +++++----
> >  fs/xfs/xfs_ondisk.h            |    1 +
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index 8ef31d71a9c7..5d8eb8978c33 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -462,11 +462,12 @@ static inline uint xfs_log_dinode_size(int version)
> >  #define	XFS_BLF_GDQUOT_BUF	(1<<4)
> >  
> >  /*
> > - * This is the structure used to lay out a buf log item in the
> > - * log.  The data map describes which 128 byte chunks of the buffer
> > - * have been logged.
> > + * This is the structure used to lay out a buf log item in the log.  The data
> > + * map describes which 128 byte chunks of the buffer have been logged.  Note
> > + * that XFS_BLF_DATAMAP_SIZE is an odd number so that the structure size will
> > + * be consistent between 32-bit and 64-bit platforms.
> >   */
> > -#define XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
> > +#define XFS_BLF_DATAMAP_SIZE	(1 + ((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD))
> 
> Shouldn't this do something like:
> 
> #define __XFS_BLF_DATAMAP_SIZE	((XFS_MAX_BLOCKSIZE / XFS_BLF_CHUNK) / NBWORD)
> #define XFS_BLF_DATAMAP_SIZE	(__XFS_BLF_DATAMAP_SIZE + (__XFS_BLF_DATAMAP_SIZE & 1))
> 
> or use an appropriate round up macro so that if we change the log
> chunk size or the max block size, it still evaluates correctly for
> all platforms?

Ok, works for me.

> /me has prototype patches around somewhere that change
> XFS_BLF_CHUNK...

I remember those...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
