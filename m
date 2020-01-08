Return-Path: <SRS0=Z9mQ=25=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62F2C282DD
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 797E020692
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jan 2020 16:37:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aqcIK/gu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgAHQhg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 11:37:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgAHQhf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jan 2020 11:37:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GXEl4040870;
        Wed, 8 Jan 2020 16:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eXtD+v3PONlgMhXP5RuJgmw5cTbx4VzaKN74Sq31I/0=;
 b=aqcIK/guGbB4Ty8bvhNMOryNTuRXE2Ds6EsYAuiWdgJ/A1SO0oXx59uMxlaUubjsZ9aA
 oa3uBcBeqEK9pu3xbNv6CLd6lbJ3AyAjUiza2AIuVn2gUkZq5fnD/g2d60nUGKU/BXTy
 Nx2bUdQlG3trDuoFdjT+IDdfZqL6jwqqLedrztlPDmmxa+3+RzB8SX7fiJtr9NpSaPUn
 fwtQI7Wn96ULlLsyXmJvJl+oKu5B+odFnxgfnXFPPMY0RsvR+iP3uy4J+5i9K2P+zhUi
 9x0x1FE2EnTKBeT/c+x474/eczbuNi8Ea9Rr2SXpE61x9rZGogl5fVkWmWJLYQLSAlw7 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xakbqw024-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:37:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 008GY20I020134;
        Wed, 8 Jan 2020 16:37:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xcqbpm0p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jan 2020 16:37:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 008GbTCf018779;
        Wed, 8 Jan 2020 16:37:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 08 Jan 2020 08:37:28 -0800
Date:   Wed, 8 Jan 2020 08:37:27 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: truncate should remove all blocks, not just to
 the end of the page cache
Message-ID: <20200108163727.GG5552@magnolia>
References: <157845705246.82882.11480625967486872968.stgit@magnolia>
 <157845706502.82882.5903950627987445484.stgit@magnolia>
 <20200108081157.GB25201@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200108081157.GB25201@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001080136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9494 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001080136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 08, 2020 at 12:11:57AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 07, 2020 at 08:17:45PM -0800, Darrick J. Wong wrote:
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
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c |   23 +++++++++++------------
> >  1 file changed, 11 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index fc3aec26ef87..79799ab30c93 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1518,7 +1518,6 @@ xfs_itruncate_extents_flags(
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_trans	*tp = *tpp;
> >  	xfs_fileoff_t		first_unmap_block;
> > -	xfs_fileoff_t		last_block;
> >  	xfs_filblks_t		unmap_len;
> >  	int			error = 0;
> >  
> > @@ -1540,21 +1539,21 @@ xfs_itruncate_extents_flags(
> >  	 * the end of the file (in a crash where the space is allocated
> >  	 * but the inode size is not yet updated), simply remove any
> >  	 * blocks which show up between the new EOF and the maximum
> > -	 * possible file size.  If the first block to be removed is
> > -	 * beyond the maximum file size (ie it is the same as last_block),
> > -	 * then there is nothing to do.
> > +	 * possible file size.
> > +	 *
> > +	 * We have to free all the blocks to the bmbt maximum offset, even if
> > +	 * the page cache can't scale that far.
> >  	 */
> >  	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
> > -	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
> > -	if (first_unmap_block == last_block)
> > +	if (first_unmap_block == XFS_MAX_FILEOFF)
> >  		return 0;
> >  
> > -	ASSERT(first_unmap_block < last_block);
> > -	unmap_len = last_block - first_unmap_block + 1;
> > -	while (!done) {
> > +	ASSERT(first_unmap_block < XFS_MAX_FILEOFF);
> 
> Instead of the assert we could just do the early return for
> 
> 	first_unmap_block >= XFS_MAX_FILEOFF
> 
> and throw in a WARN_ON_ONCE, as that condition really should be nothing
> but a sanity check.
> 
> Otherwise this looks good to me.

Ok, done.

--D
