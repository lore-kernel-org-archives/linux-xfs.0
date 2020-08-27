Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEA4C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 15:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86A8E2177B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 15:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tnaQchjV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgH0Pij (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 11:38:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgH0Pij (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 11:38:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RFSqMi026011;
        Thu, 27 Aug 2020 15:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mGRTXn9ydTlXsFyU2Os7+T2TtCM2RXsFjan18MuDchc=;
 b=tnaQchjVyw8E3arKIez5nMg5CmcihkOlqez7zDf+/MB5QafMjN9UdIAzd+fNxk0KFJ60
 QIiUJ4hL9a6kzaHyyLYbWkFUidZ0ZLRPfoUT7AajjWbduIE0l/ZVLOMpT1JArx4dy6lW
 cBQg9kUH1fZ/kcJDnbQzP8ZsdS7mF1tMfNpI12LUQRf2NeI7/F1uTTu36ADaP/Y74LbV
 r5ocZYJGbgZ6vJXIe8JrX5yPT+2xohbXxi82oweBPwo5d/R4O2cXhbqw+pzgkMniFZYh
 4Ds8oY7tBdVBPM7gVWj6R00zgLNLnFfehiqNAa7HQAbGBpNfMbw4asuFltTxTmX26dhF Rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 335gw88y3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 15:38:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RFVBDJ161805;
        Thu, 27 Aug 2020 15:38:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 333r9nja6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 15:38:30 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RFcTcO009536;
        Thu, 27 Aug 2020 15:38:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 08:38:29 -0700
Date:   Thu, 27 Aug 2020 08:38:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, amir73il@gmail.com,
        sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with
 y2038+
Message-ID: <20200827153828.GU6096@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954997.2601708.12578930799217289682.stgit@magnolia>
 <20200827065816.GB17534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827065816.GB17534@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:58:16AM +0100, Christoph Hellwig wrote:
> > -	tv.tv_sec = (int64_t)t >> 32;
> > -	tv.tv_nsec = (int32_t)(t & 0xffffffff);
> > +	if (xfs_dinode_has_bigtime(dip)) {
> > +		s = xfs_bigtime_to_unix(div_u64_rem(t, NSEC_PER_SEC, &n));
> > +	} else {
> > +		s = (int64_t)t >> 32;
> > +		n = (int32_t)(t & 0xffffffff);
> 
> Move this branche into a xfs_legacytime_to_unix helper just to be
> symmetric?
> 
> This also made me think of the encoding:  another sensible option
> would be to always read the time stamps as two 32-bit values using the
> struct type, and just add them up for the bigtime case.
> 
> > +	if (xfs_inode_has_bigtime(ip))
> > +		t = xfs_inode_encode_bigtime(tv);
> > +	else
> > +		t = ((int64_t)tv.tv_sec << 32) | (tv.tv_nsec & 0xffffffff);
> > +
> 
> Same here.

<shrug> I think I'd rather just keep the legacy struct xfs_{ic,}timestamp,
change the xfs_dinode/xfs_log_dinode structs to have a be64/u64
timestamp, and cast pointers as needed to support the legacy formats.

> > @@ -305,9 +320,9 @@ xfs_inode_to_disk(
> >  	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
> >  
> >  	memset(to->di_pad, 0, sizeof(to->di_pad));
> > -	to->di_atime = xfs_inode_to_disk_ts(inode->i_atime);
> > -	to->di_mtime = xfs_inode_to_disk_ts(inode->i_mtime);
> > -	to->di_ctime = xfs_inode_to_disk_ts(inode->i_ctime);
> > +	to->di_atime = xfs_inode_to_disk_ts(ip, inode->i_atime);
> > +	to->di_mtime = xfs_inode_to_disk_ts(ip, inode->i_mtime);
> > +	to->di_ctime = xfs_inode_to_disk_ts(ip, inode->i_ctime);
> >  	to->di_nlink = cpu_to_be32(inode->i_nlink);
> >  	to->di_gen = cpu_to_be32(inode->i_generation);
> >  	to->di_mode = cpu_to_be16(inode->i_mode);
> > @@ -326,7 +341,7 @@ xfs_inode_to_disk(
> >  	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
> >  		to->di_version = 3;
> >  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
> > -		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
> > +		to->di_crtime = xfs_inode_to_disk_ts(ip, from->di_crtime);
> >  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> >  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
> >  		to->di_ino = cpu_to_be64(ip->i_ino);
> > @@ -546,6 +561,11 @@ xfs_dinode_verify(
> >  	if (fa)
> >  		return fa;
> >  
> > +	/* bigtime iflag can only happen on bigtime filesystems */
> > +	if (xfs_dinode_has_bigtime(dip) &&
> > +	    !xfs_sb_version_hasbigtime(&mp->m_sb))
> > +		return __this_address;
> > +
> >  	return NULL;
> >  }
> >  
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> > index 3060ecd24a2e..e05bfe52fd8f 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.h
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> > @@ -32,6 +32,11 @@ struct xfs_icdinode {
> >  	struct timespec64 di_crtime;	/* time created */
> >  };
> >  
> > +static inline bool xfs_icdinode_has_bigtime(const struct xfs_icdinode *icd)
> > +{
> > +	return icd->di_flags2 & XFS_DIFLAG2_BIGTIME;
> > +}
> > +
> >  /*
> >   * Inode location information.  Stored in the inode and passed to
> >   * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
> > @@ -58,6 +63,14 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
> >  		uint32_t cowextsize, uint16_t mode, uint16_t flags,
> >  		uint64_t flags2);
> >  
> > -struct timespec64 xfs_inode_from_disk_ts(const xfs_timestamp_t ts);
> > +static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
> > +{
> > +	uint64_t	t = xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC;
> > +
> > +	return t + tv.tv_nsec;
> 
> Why not:
> 
> 	return xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC + tv.tv_nsec;
> 
> ?

Heh, ok, will do.

> > +static inline bool xfs_inode_want_bigtime_upgrade(struct xfs_inode *ip)
> > +{
> > +	return xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
> > +	       !xfs_inode_has_bigtime(ip);
> > +}
> > +
> >  /*
> >   * This is called to mark the fields indicated in fieldmask as needing to be
> >   * logged when the transaction is committed.  The inode must already be
> > @@ -131,6 +137,16 @@ xfs_trans_log_inode(
> >  			iversion_flags = XFS_ILOG_CORE;
> >  	}
> >  
> > +	/*
> > +	 * If we're updating the inode core or the timestamps and it's possible
> > +	 * to upgrade this inode to bigtime format, do so now.
> > +	 */
> > +	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> > +	    xfs_inode_want_bigtime_upgrade(ip)) {
> > +		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> > +		flags |= XFS_ILOG_CORE;
> > +	}
> 
> I find the way to directly set XFS_DIFLAG2_BIGTIME but using a helper
> to check it here rather confusing.
> 
> Why not:
> 
> 	if (xfs_sb_version_hasbigtime(&ip->i_mount->m_sb) &&
> 	    (flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> 	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_BIGTIME)) {
> 		ip->i_d.di_flags2 |= XFS_DIFLAG2_BIGTIME;
> 		flags |= XFS_ILOG_CORE;
> 	}
> 
> ?

The previous version had it that way; Dave asked me to make it a helper.

--D
