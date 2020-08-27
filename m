Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FC0C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 17:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92ACF207CD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 17:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="x1ZtfLDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgH0RwL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:52:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37826 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgH0RwK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 13:52:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RHmfJk068408;
        Thu, 27 Aug 2020 17:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Vj3+73ckxb2+Lzzis0J5hePzKzEpZGnTRyDOR5dkKyc=;
 b=x1ZtfLDpQ3Sy9/gwbg5FEQGhlK0GmKb5/53tCnPCoBfjffGgVNC9UZgbXGyvnblYYyf6
 SO0OtIRsPTY/HszcxDLxD+vaArBk3LBTDev2P/KP+Pdt8TbH1I1ijlNxgOoywnoskJqr
 J/PjngMCUNRLnaalf/X+C3acI7dZ5QOrg+t1GwLqDQ0XXx3pztzLGKOUbDXB9ydr8iZv
 cywWt6s8CEuf0Q9qjJHavjr24hrIU1iqEKK/P5QPpw5EDM86TWNeLabAVBVSNDYoXwan
 PoJozJJ7hEBSbpg/ai1kUmaxfAEcnbWvPa3XWenzDoBKLD32SgKcNJNNpzlD/0TW0PS9 tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 335gw89puy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 17:52:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RHkk56013825;
        Thu, 27 Aug 2020 17:50:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333ru1s4xa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 17:50:01 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RHnxJ7008681;
        Thu, 27 Aug 2020 17:49:59 GMT
Received: from localhost (/10.159.133.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 10:49:59 -0700
Date:   Thu, 27 Aug 2020 10:49:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, amir73il@gmail.com,
        sandeen@sandeen.net
Subject: Re: [PATCH 09/11] xfs: widen ondisk quota expiration timestamps to
 handle y2038+
Message-ID: <20200827174958.GX6096@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847955663.2601708.15732334977032233773.stgit@magnolia>
 <20200827070050.GC17534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827070050.GC17534@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 08:00:50AM +0100, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 972c740aaf7b..9cf84b57e2ce 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1257,13 +1257,15 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
> >  #define XFS_DQTYPE_USER		0x01		/* user dquot record */
> >  #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
> >  #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
> > +#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */
> 
> Maybe make this the high bit in the field to keep space for adding more
> actual quota types if we need them?

Ok.  0x80 it is.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
