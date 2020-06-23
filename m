Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2489AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D612075A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 02:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o07jD3vo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgFWCmM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:42:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42808 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731434AbgFWCmM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 22:42:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2ffuQ122184;
        Tue, 23 Jun 2020 02:42:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zZJHqYXVuemuynHkLcJU1LwpdB0SikIOcw9PdPxFl44=;
 b=o07jD3volWQzoxyFVZ75URKIRZHhTGU3Q4wvZKY34mnI/pCjrLDE/SpuiAqdWHFhnEsA
 Y1dQBq78UCYkvl+wPucIFflHpY+wRp2OXW4noFppteNtOmzJu2LVZPDzT/Xz2casX5g0
 mEgKj5MGOy2Z1g8484akeik/KfLTjyXXvJA9Kn339CUs6RJ9xfE46b/HbEil1OIWZNBr
 XXHqqtawjEfDr8Vmo96JFxtqclLcSW6hDCV0jmidXI6hGFSnTvxRHtaK8HmfRNCJVdJh
 6CuesAxuayUKuFOfbhFVc9SrLFdfp7BbvuaJj3N9htoSvMF98ofRvPBsSquoo8YxkHHA uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31sebban6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 02:42:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05N2c6LG021681;
        Tue, 23 Jun 2020 02:42:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31sv7r1yy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 02:42:09 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05N2g8Tv018994;
        Tue, 23 Jun 2020 02:42:08 GMT
Received: from localhost (/10.159.143.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 02:42:08 +0000
Date:   Mon, 22 Jun 2020 19:42:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200623024207.GE7606@magnolia>
References: <20200622171713.GG11245@magnolia>
 <20200622220839.GV2005@dread.disaster.area>
 <20200622232843.GA7625@magnolia>
 <20200622235800.GX2005@dread.disaster.area>
 <20200623010240.GB7625@magnolia>
 <20200623023710.GY2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623023710.GY2005@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9660 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 cotscore=-2147483648
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006230019
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 12:37:10PM +1000, Dave Chinner wrote:
> On Mon, Jun 22, 2020 at 06:02:40PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 23, 2020 at 09:58:00AM +1000, Dave Chinner wrote:
> > > On Mon, Jun 22, 2020 at 04:28:43PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jun 23, 2020 at 08:08:39AM +1000, Dave Chinner wrote:
> > > > > On Mon, Jun 22, 2020 at 10:17:13AM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > 
> > > > > > The data fork scrubber calls filemap_write_and_wait to flush dirty pages
> > > > > > and delalloc reservations out to disk prior to checking the data fork's
> > > > > > extent mappings.  Unfortunately, this means that scrub can consume the
> > > > > > EIO/ENOSPC errors that would otherwise have stayed around in the address
> > > > > > space until (we hope) the writer application calls fsync to persist data
> > > > > > and collect errors.  The end result is that programs that wrote to a
> > > > > > file might never see the error code and proceed as if nothing were
> > > > > > wrong.
> > > > > > 
> > > > > > xfs_scrub is not in a position to notify file writers about the
> > > > > > writeback failure, and it's only here to check metadata, not file
> > > > > > contents.  Therefore, if writeback fails, we should stuff the error code
> > > > > > back into the address space so that an fsync by the writer application
> > > > > > can pick that up.
> > > > > > 
> > > > > > Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
> > > > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > > > ---
> > > > > >  fs/xfs/scrub/bmap.c |   10 +++++++++-
> > > > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > > > > index 7badd6dfe544..03be7cf3fe5a 100644
> > > > > > --- a/fs/xfs/scrub/bmap.c
> > > > > > +++ b/fs/xfs/scrub/bmap.c
> > > > > > @@ -47,7 +47,15 @@ xchk_setup_inode_bmap(
> > > > > >  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
> > > > > >  		inode_dio_wait(VFS_I(sc->ip));
> > > > > >  		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> > > > > > -		if (error)
> > > > > > +		if (error == -ENOSPC || error == -EIO) {
> > > > > > +			/*
> > > > > > +			 * If writeback hits EIO or ENOSPC, reflect it back
> > > > > > +			 * into the address space mapping so that a writer
> > > > > > +			 * program calling fsync to look for errors will still
> > > > > > +			 * capture the error.
> > > > > > +			 */
> > > > > > +			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);
> > > > > > +		} else if (error)
> > > > > >  			goto out;
> > > > > 
> > > > > calling mapping_set_error() seems reasonable here and you've
> > > > > explained that well, but shouldn't the error then be processed the
> > > > > same way as all other errors? i.e. by jumping to out?
> > > > > 
> > > > > If we are now continuing to scrub the bmap after ENOSPC/EIO occur,
> > > > > why?
> > > > 
> > > > Heh, ok, more explanation is needed.  How about this?
> > > > 
> > > > 	/*
> > > > 	 * If writeback hits EIO or ENOSPC, reflect it back into the
> > > > 	 * address space mapping so that a writer program calling fsync
> > > > 	 * to look for errors will still capture the error.
> > > > 	 *
> > > > 	 * However, we continue into the extent mapping checks because
> > > > 	 * write failures do not necessarily imply anything about the
> > > > 	 * correctness of the file metadata.  The metadata and the file
> > > > 	 * data could be on completely separate devices; a media failure
> > > > 	 * might only affect a subset of the disk, etc.
> > > > 	 */
> > > 
> > > Ok. Does scrub deal with left-over delalloc extents correctly in
> > > this case?
> > 
> > It ignores the ones in the incore extent tree and flags them if they
> > show up in the ondisk metadata.
> 
> OK. Perhaps add this to the comment?

Will do.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
