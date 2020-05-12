Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EA8CA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 19:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35FE20740
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 19:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R5/++opH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgELTQb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 15:16:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELTQb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 15:16:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIuinL112681;
        Tue, 12 May 2020 19:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YbMP/gAcjoY0DzdSixsgwuob4WSG28svNStsa0XhyzI=;
 b=R5/++opHO+BS3L+H7zXBSIqxnEQr6+ZENIZ0c4GJiMQvd5U8Cc28mH1NCniEu4xlqYk4
 Wy4ljBUJg+wOSiqaOWKGThqX9cs8QtMcRc78iP9W83vXyvOJimzDGrr8hEyrmqjRKwLA
 jVFcT//qCA9mfwRcPnJ/DI8A5FSZXrcs3pKOAYFxlBC2l3H7nikFEUirDnaelSwHeSlL
 z5ISumLAqttw9vi/s88aPNyZzoarvsmuXaPcoKST2HD/eA88SAo0r1I/0ryiYIZFFBCu
 LXh6SOSeWo8Qq0gqr/SuFLp3VNkXbWz3N4Ub16WAUoU/aZ1JmN0Y2ZUWMyEaPnoMpJVx VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3100yfr9b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 19:16:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CIvjqT196454;
        Tue, 12 May 2020 19:16:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3100y8u2sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 19:16:23 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CJGHAp000615;
        Tue, 12 May 2020 19:16:17 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 12:16:16 -0700
Date:   Tue, 12 May 2020 12:16:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Message-ID: <20200512191615.GK6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-2-hch@lst.de>
 <2615851.ejxhajbSum@garuda>
 <20200512153132.GE37029@bfoster>
 <20200512153854.GC6714@magnolia>
 <20200512161410.GI37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512161410.GI37029@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=1 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005120144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:14:10PM -0400, Brian Foster wrote:
> On Tue, May 12, 2020 at 08:38:54AM -0700, Darrick J. Wong wrote:
> > On Tue, May 12, 2020 at 11:31:32AM -0400, Brian Foster wrote:
> > > On Mon, May 11, 2020 at 05:10:04PM +0530, Chandan Babu R wrote:
> > > > On Sunday 10 May 2020 12:53:59 PM IST Christoph Hellwig wrote:
> > > > > XFS_IFORK_Q is to be used in boolean context, not for a size.  This
> > > > > doesn't make a difference in practice as size is only checked for
> > > > > 0, but this keeps the logic sane.
> > > > >
> > > > 
> > > > Wouldn't XFS_IFORK_ASIZE() be a better fit since it gives the space used by the
> > > > attr fork inside an inode's literal area?
> > > > 
> > > 
> > > I had the same thought. It's not clear to me what size is really
> > > supposed to be between the file size for a data fork and fork offset for
> > > the attr fork. I was also wondering if this should use
> > > XFS_IFORK_DSIZE(), but that won't be conditional based on population of
> > > the fork. At the same time, I don't think i_size != 0 necessarily
> > > correlates with the existence of blocks. The file could be completely
> > > sparse or could have any number of post-eof preallocated extents.
> > 
> > TBH I should have made that variable "bool empty" or something.
> > 
> > case XFS_DATA_FORK:
> > 	empty = i_size_read() == 0;
> > 
> 
> Even that is somewhat unclear because it's tied to i_size. What about
> size == 0 && <post-eof extents>?

/me stumbles around trying to remember under what circumstances do we
actually scan all the rmaps to make sure there's a corresponding bmap.
I think we're trying to avoid doing it for every file in the filesystem
because it's very slow...

Oh right -- we do that for btree format forks because there are a lot of
extent records and therefore a high(er) chance of something getting
lost; or

We scan all the rmaps for files that have nonzero size but zero extents,
because the (forthcoming) inode fork repair will reset damaged forks
back to extents format with zero extents, and this is how we will
trigger the bmap repair to get the extents mapped back into the file.

--D

> 
> Brian
> 
> > case XFS_ATTR_FORK:
> > 	empty = !XFS_IFORK_Q();
> > 
> > default:
> > 	empty = true;
> > 
> > if ((is not btree) && (empty || nextents > 0))
> > 	return 0;
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > > ---
> > > > >  fs/xfs/scrub/bmap.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > > > index add8598eacd5d..283424d6d2bb6 100644
> > > > > --- a/fs/xfs/scrub/bmap.c
> > > > > +++ b/fs/xfs/scrub/bmap.c
> > > > > @@ -591,7 +591,7 @@ xchk_bmap_check_rmaps(
> > > > >  		size = i_size_read(VFS_I(sc->ip));
> > > > >  		break;
> > > > >  	case XFS_ATTR_FORK:
> > > > > -		size = XFS_IFORK_Q(sc->ip);
> > > > > +		size = XFS_IFORK_BOFF(sc->ip);
> > > > >  		break;
> > > > >  	default:
> > > > >  		size = 0;
> > > > > 
> > > > 
> > > > 
> > > > -- 
> > > > chandan
> > > > 
> > > > 
> > > > 
> > > 
> > 
> 
