Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C15FC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 17:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06E6520780
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 17:03:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4Dw2h+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbgFWRDC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:03:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44050 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgFWRDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 13:03:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NGvt1m072879;
        Tue, 23 Jun 2020 17:02:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Icz6ZHF8BnBdq3F2AfWjJCPJ02D7fk8MLyAxpgF5Ujk=;
 b=J4Dw2h+kyFQtW5vAVdL9pH6945+3kotubtngk9Z5sNtplRUzOsk6iXcP2hG2Fns4SdsE
 Z+xvht4nalJIZWZyLLvcQPgNVSck5lowjEn7/ac5PWwqGVE5mZOXDlhjgWexd3mI7Qvd
 1kPmmeXamBpjxw8RoW0UjH3LV0xni0CpRAijhHGU0xJDpaSiiFkS0n6FKsvr3UJQfXAS
 399i6HH7oG5C2ALi5DgLRhS3tAgdPjZRzMRaDzXT/Oh3oZNnyLgTwJYOtNPMyYFic+Rk
 vetMtUNf5L3B9xOszNGg8VH6DvUnsLvj98VfR1YPws4NUU4X0iYY6WoLxYwNtZWzjHys bA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31uk3c13b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 17:02:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NGriw4072877;
        Tue, 23 Jun 2020 17:00:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uk3cftam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 17:00:56 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05NH0tsl030225;
        Tue, 23 Jun 2020 17:00:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 17:00:55 +0000
Date:   Tue, 23 Jun 2020 10:00:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't eat an EIO/ENOSPC writeback error when
 scrubbing data fork
Message-ID: <20200623170054.GF7625@magnolia>
References: <20200623035010.GF7606@magnolia>
 <20200623121031.GB55038@bfoster>
 <20200623152350.GE7625@magnolia>
 <20200623164934.GA56510@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623164934.GA56510@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006120000
 definitions=main-2006230122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006120000
 definitions=main-2006230122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 12:49:34PM -0400, Brian Foster wrote:
> On Tue, Jun 23, 2020 at 08:23:50AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 23, 2020 at 08:10:31AM -0400, Brian Foster wrote:
> > > On Mon, Jun 22, 2020 at 08:50:10PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > The data fork scrubber calls filemap_write_and_wait to flush dirty pages
> > > > and delalloc reservations out to disk prior to checking the data fork's
> > > > extent mappings.  Unfortunately, this means that scrub can consume the
> > > > EIO/ENOSPC errors that would otherwise have stayed around in the address
> > > > space until (we hope) the writer application calls fsync to persist data
> > > > and collect errors.  The end result is that programs that wrote to a
> > > > file might never see the error code and proceed as if nothing were
> > > > wrong.
> > > > 
> > > > xfs_scrub is not in a position to notify file writers about the
> > > > writeback failure, and it's only here to check metadata, not file
> > > > contents.  Therefore, if writeback fails, we should stuff the error code
> > > > back into the address space so that an fsync by the writer application
> > > > can pick that up.
> > > > 
> > > > Fixes: 99d9d8d05da2 ("xfs: scrub inode block mappings")
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > > v2: explain why it's ok to keep going even if writeback fails
> > > > ---
> > > >  fs/xfs/scrub/bmap.c |   19 ++++++++++++++++++-
> > > >  1 file changed, 18 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > > index 7badd6dfe544..0d7062b7068b 100644
> > > > --- a/fs/xfs/scrub/bmap.c
> > > > +++ b/fs/xfs/scrub/bmap.c
> > > > @@ -47,7 +47,24 @@ xchk_setup_inode_bmap(
> > > >  	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
> > > >  		inode_dio_wait(VFS_I(sc->ip));
> > > >  		error = filemap_write_and_wait(VFS_I(sc->ip)->i_mapping);
> > > > -		if (error)
> > > > +		if (error == -ENOSPC || error == -EIO) {
> > > > +			/*
> > > > +			 * If writeback hits EIO or ENOSPC, reflect it back
> > > > +			 * into the address space mapping so that a writer
> > > > +			 * program calling fsync to look for errors will still
> > > > +			 * capture the error.
> > > > +			 *
> > > > +			 * However, we continue into the extent mapping checks
> > > > +			 * because write failures do not necessarily imply
> > > > +			 * anything about the correctness of the file metadata.
> > > > +			 * The metadata and the file data could be on
> > > > +			 * completely separate devices; a media failure might
> > > > +			 * only affect a subset of the disk, etc.  We properly
> > > > +			 * account for delalloc extents, so leaving them in
> > > > +			 * memory is fine.
> > > > +			 */
> > > > +			mapping_set_error(VFS_I(sc->ip)->i_mapping, error);
> > > 
> > > I think the more appropriate thing to do is open code the data write and
> > > wait and use the variants of the latter that don't consume address space
> > > errors in the first place (i.e. filemap_fdatawait_keep_errors()). Then
> > > we wouldn't need the special error handling branch or perhaps the first
> > > part of the comment. Hm?
> > 
> > Yes, it's certainly possible.  I don't want to go opencoding more vfs
> > methods (like some e4 filesystems do) so I'll propose that as a second
> > patch for 5.9.
> > 
> 
> What's the point of fixing it twice when the generic code already
> exports the appropriate helpers? filemap_fdatawrite() and
> filemap_fdatawait_keep_errors() are used fairly commonly afaict. That
> seems much more straightforward to me than misusing a convenience helper
> and trying to undo the undesirable effects after the fact.

Blergh.  Apparently my eyes suck at telling fdatawait from fdatawrite
and I got all twisted around.  Now I realize that I think you were
asking why I didn't simply call:

filemap_flush()
filemap_fdatawait_keep_errors()

one after the other?  And yes, that's way better than throwing error
codes back into the mapping.  I'll do that, thanks.

> > On second thought, I wonder if I should just drop the flush entirely?
> > It's not a huge burden to skip past the delalloc reservations.
> > 
> > Hmmm.  Any preferences?
> > 
> 
> The context for the above is not clear to me. If the purpose is to check
> on-disk metadata, shouldn't we flush the in-core content first? It would seem
> a little strange to me for one file check to behave differently from
> another if the only difference between the two is that some or more of a
> file had been written back, but maybe I'm missing details..

Originally it was because the bmap scrubber didn't handle delalloc
extents, but that was changed long ago.  Nowadays it only exists as a
precautionary "try to push everything to disk" tactic.

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > > +		} else if (error)
> > > >  			goto out;
> > > >  	}
> > > >  
> > > > 
> > > 
> > 
> 
