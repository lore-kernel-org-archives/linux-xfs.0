Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A8EC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 22:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDFE721582
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 22:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aqnPmxpr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfLQWV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:21:59 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51004 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLQWV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 17:21:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHMKEj9078171;
        Tue, 17 Dec 2019 22:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JZpOpyUt+YcGCSq+PGUGl08TK+rFo7IlK70EFDBARgI=;
 b=aqnPmxprV9i9grW994Zo2dCPoPW+wfPGA/qcGGUpfjPv1mFJxq38CmztJdtB1rIyhIzF
 ChcMa8ERalwWnYIHAwrsMhKxex0D2uWlDX6l9mYHb49f4RtxBTirfY9plBVALjoSTAZd
 MKKJLCj6niFNdhike1V3+tx4DgY4CqdCwGp1Kd2i9X7vr/3m0Qiemmfur0FRJHIVG1Im
 LmMiRuSex4gUPW8LliGrAbx5/PPUnf17nK7Z1mRwCIH51LhS01gWfsSps0eNfdhaaScA
 7HxHoXsT3e+BV3V0I5xap+TKPT3Fp/uPmCQqCycrwxiZJM4qegsCCpXSsiQMPW9EJMaS JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wvrcr9kps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 22:21:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHMDmTn163825;
        Tue, 17 Dec 2019 22:21:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wxm5kr4b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 22:21:54 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBHMLpCS023470;
        Tue, 17 Dec 2019 22:21:51 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 14:21:51 -0800
Date:   Tue, 17 Dec 2019 14:21:48 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: open code insert range extent split helper
Message-ID: <20191217222148.GF12765@magnolia>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-2-bfoster@redhat.com>
 <d1d7f488-c10a-2c34-39b7-09b537994d89@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1d7f488-c10a-2c34-39b7-09b537994d89@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170177
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 10:02:42AM -0700, Allison Collins wrote:
> On 12/13/19 10:12 AM, Brian Foster wrote:
> > The insert range operation currently splits the extent at the target
> > offset in a separate transaction and lock cycle from the one that
> > shifts extents. In preparation for reworking insert range into an
> > atomic operation, lift the code into the caller so it can be easily
> > condensed to a single rolling transaction and lock cycle and
> > eliminate the helper. No functional changes.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Looks ok to me.
> 
> Reviewed by: Allison Collins <allison.henderson@oracle.com>

"Reviewed-by", with dash?

--D

> > ---
> >   fs/xfs/libxfs/xfs_bmap.c | 32 ++------------------------------
> >   fs/xfs/libxfs/xfs_bmap.h |  3 ++-
> >   fs/xfs/xfs_bmap_util.c   | 14 +++++++++++++-
> >   3 files changed, 17 insertions(+), 32 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index a9ad1f991ba3..2bba0f983e4f 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -6021,8 +6021,8 @@ xfs_bmap_insert_extents(
> >    * @split_fsb is a block where the extents is split.  If split_fsb lies in a
> >    * hole or the first block of extents, just return 0.
> >    */
> > -STATIC int
> > -xfs_bmap_split_extent_at(
> > +int
> > +xfs_bmap_split_extent(
> >   	struct xfs_trans	*tp,
> >   	struct xfs_inode	*ip,
> >   	xfs_fileoff_t		split_fsb)
> > @@ -6138,34 +6138,6 @@ xfs_bmap_split_extent_at(
> >   	return error;
> >   }
> > -int
> > -xfs_bmap_split_extent(
> > -	struct xfs_inode        *ip,
> > -	xfs_fileoff_t           split_fsb)
> > -{
> > -	struct xfs_mount        *mp = ip->i_mount;
> > -	struct xfs_trans        *tp;
> > -	int                     error;
> > -
> > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> > -			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> > -	if (error)
> > -		return error;
> > -
> > -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > -
> > -	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
> > -	if (error)
> > -		goto out;
> > -
> > -	return xfs_trans_commit(tp);
> > -
> > -out:
> > -	xfs_trans_cancel(tp);
> > -	return error;
> > -}
> > -
> >   /* Deferred mapping is only for real extents in the data fork. */
> >   static bool
> >   xfs_bmap_is_update_needed(
> > diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> > index 14d25e0b7d9c..f3259ad5c22c 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.h
> > +++ b/fs/xfs/libxfs/xfs_bmap.h
> > @@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
> >   int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
> >   		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
> >   		bool *done, xfs_fileoff_t stop_fsb);
> > -int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
> > +int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
> > +		xfs_fileoff_t split_offset);
> >   int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
> >   		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
> >   		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
> > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > index 2efd78a9719e..829ab1a804c9 100644
> > --- a/fs/xfs/xfs_bmap_util.c
> > +++ b/fs/xfs/xfs_bmap_util.c
> > @@ -1139,7 +1139,19 @@ xfs_insert_file_space(
> >   	 * is not the starting block of extent, we need to split the extent at
> >   	 * stop_fsb.
> >   	 */
> > -	error = xfs_bmap_split_extent(ip, stop_fsb);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
> > +			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> > +
> > +	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
> > +	if (error)
> > +		goto out_trans_cancel;
> > +
> > +	error = xfs_trans_commit(tp);
> >   	if (error)
> >   		return error;
> > 
