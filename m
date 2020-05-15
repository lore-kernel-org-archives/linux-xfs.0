Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B51C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 15:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F7CB20709
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 15:56:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NzhtAcew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgEOP4z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 11:56:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgEOP4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 11:56:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFrJHx146557;
        Fri, 15 May 2020 15:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hiXNjYkGyOGuYBq2jq/8xpMRmCQuROiIYloaQ8h/DBc=;
 b=NzhtAcewLyGSgta+1JeXIPlsGxfhXw0m3pZZJs6d2NTWOEBALZPPIYuzdDiLCQfrxlST
 9nipnk1augH6gdUpaWiVkui/gKQnxLgai3d7WY5+De5aFFQpEv4SVZeYIzO9Bvya/WvB
 G+RQ4HyHwYG90cZ6ljmi7M9n9BuAxwWcN+YQ3Fgc0ws48xWBgzQVojNaBc8DcBi5rEVM
 BvzbgPcw5FjGSALUFjsJeK5HPqP1ddfH7WL8fvLSO0YdH+Ck6YV2DmiW/BvLlDflpZWT
 wVd3XHyk80iI4xYvqoFagW/ga5bWnXbgZhYegM7nRV2y3pzivYiwphPt8RFfxgx7wKjB EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 311nu5mb50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 May 2020 15:56:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04FFqntT022968;
        Fri, 15 May 2020 15:56:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3100yru4vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 15:56:50 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04FFun4W027949;
        Fri, 15 May 2020 15:56:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 May 2020 15:56:49 +0000
Date:   Fri, 15 May 2020 08:56:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't fail verifier on empty attr3 leaf block
Message-ID: <20200515155648.GM6714@magnolia>
References: <20200513145343.45855-1-bfoster@redhat.com>
 <20200514205210.GJ6714@magnolia>
 <20200515120028.GC54804@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515120028.GC54804@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 cotscore=-2147483648
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005150135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 15, 2020 at 08:00:28AM -0400, Brian Foster wrote:
> On Thu, May 14, 2020 at 01:52:10PM -0700, Darrick J. Wong wrote:
> > On Wed, May 13, 2020 at 10:53:43AM -0400, Brian Foster wrote:
> > > The attr fork can transition from shortform to leaf format while
> > > empty if the first xattr doesn't fit in shortform. While this empty
> > > leaf block state is intended to be transient, it is technically not
> > > due to the transactional implementation of the xattr set operation.
> > > 
> > > We historically have a couple of bandaids to work around this
> > > problem. The first is to hold the buffer after the format conversion
> > > to prevent premature writeback of the empty leaf buffer and the
> > > second is to bypass the xattr count check in the verifier during
> > > recovery. The latter assumes that the xattr set is also in the log
> > > and will be recovered into the buffer soon after the empty leaf
> > > buffer is reconstructed. This is not guaranteed, however.
> > > 
> > > If the filesystem crashes after the format conversion but before the
> > > xattr set that induced it, only the format conversion may exist in
> > > the log. When recovered, this creates a latent corrupted state on
> > > the inode as any subsequent attempts to read the buffer fail due to
> > > verifier failure. This includes further attempts to set xattrs on
> > > the inode or attempts to destroy the attr fork, which prevents the
> > > inode from ever being removed from the unlinked list.
> > > 
> > > To avoid this condition, accept that an empty attr leaf block is a
> > > valid state and remove the count check from the verifier. This means
> > > that on rare occasions an attr fork might exist in an unexpected
> > > state, but is otherwise consistent and functional. Note that we
> > > retain the logic to avoid racing with metadata writeback to reduce
> > > the window where this can occur.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > v1:
> > > - Remove the verifier check instead of warn.
> > > rfc: https://lore.kernel.org/linux-xfs/20200511185016.33684-1-bfoster@redhat.com/
> > > 
> > >  fs/xfs/libxfs/xfs_attr_leaf.c | 8 --------
> > >  1 file changed, 8 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index 863444e2dda7..6b94bb9de378 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -308,14 +308,6 @@ xfs_attr3_leaf_verify(
> > >  	if (fa)
> > >  		return fa;
> > >  
> > > -	/*
> > > -	 * In recovery there is a transient state where count == 0 is valid
> > > -	 * because we may have transitioned an empty shortform attr to a leaf
> > > -	 * if the attr didn't fit in shortform.
> > 
> > /me wonders if it would be useful for future spelunkers to retain some
> > sort of comment here that we once thought count==0 was bad but screwed
> > it up enough that we now allow it?
> > 
> > Moreso that future me/fuzzrobot won't come along having forgotten
> > everything and think "Oh, we need to validate hdr.count!" :P
> > 
> 
> Fine by me. Something like the following perhaps?
> 
> "This verifier historically failed empty leaf buffers because we expect
> the fork to be in another format. Empty attr fork format conversions are
> possible during xattr set, however, and format conversion is not atomic
> with the xattr set that triggers it. We cannot assume leaf blocks are
> non-empty until that is addressed."

Sounds good to me!

--D

> Brian
> 
> > --D
> > 
> > > -	 */
> > > -	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
> > > -		return __this_address;
> > > -
> > >  	/*
> > >  	 * firstused is the block offset of the first name info structure.
> > >  	 * Make sure it doesn't go off the block or crash into the header.
> > > -- 
> > > 2.21.1
> > > 
> > 
> 
