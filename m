Return-Path: <SRS0=bIZx=BU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A8FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 20:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F2320866
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 20:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rC7BgyiU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgHJUAh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 16:00:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgHJUAg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 16:00:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07AJv8xW005416;
        Mon, 10 Aug 2020 20:00:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ixEoBTuzghZN8pYYvkV4JMspyod+dJ/xmyb/huYqeps=;
 b=rC7BgyiUQvpgSrU7aBS0V/KHycCH3jRuj/9SSJUQrX3RrXe9FCt1hCaiVRuRr0XbZrtt
 FJ7cv0x/+vdDxh4Xe5+69988kkKXre0QNAd2IJ38LJzGGNlYoRenUcIkoWRxltY43b9M
 0qtx5JTLQyscVNMB0jY0nvzprvVkM+N1JNqondbJsyBnO7Rz4+94POgYICERIc2vHz5d
 BWfvILo06vZeH08FQParFM1ynze9+YzUo/CQ5G1taEDw8Wom3R7r94qFwJgSNLujqoht
 u4aXJM4I2kIikKSZPiRg7AelRiZzYUjSo/QRTyGVFBQveIS2ziiRq6s9aMTCGbb3SNri zA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32smpn8ndj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Aug 2020 20:00:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07AJvPm8063909;
        Mon, 10 Aug 2020 20:00:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32u3h08r87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Aug 2020 20:00:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07AK0Kn1013917;
        Mon, 10 Aug 2020 20:00:21 GMT
Received: from localhost (/10.159.231.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Aug 2020 20:00:20 +0000
Date:   Mon, 10 Aug 2020 13:00:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_db: stop misusing an onstack inode
Message-ID: <20200810200019.GF6096@magnolia>
References: <159476319690.3156851.8364082533532014066.stgit@magnolia>
 <159476320311.3156851.15212854498898688157.stgit@magnolia>
 <20200715183849.GA22039@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715183849.GA22039@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9709 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=2 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008100136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9709 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008100136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 15, 2020 at 07:38:49PM +0100, Christoph Hellwig wrote:
> On Tue, Jul 14, 2020 at 02:46:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The onstack inode in xfs_check's process_inode is a potential landmine
> > since it's not a /real/ incore inode.  The upcoming 5.8 merge will make
> > this messier wrt inode forks, so just remove the onstack inode and
> > reference the ondisk fields directly.  This also reduces the amount of
> > thinking that I have to do w.r.t. future libxfs porting efforts.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Comparing this to my version here:
> 
> http://git.infradead.org/users/hch/xfsprogs.git/commitdiff/791d7d324290dbb83be7bf35fe15f9898f5df1c1
> 
> >  	mode_t			mode;
> > +	uint16_t		diflags;
> > +	uint64_t		diflags2 = 0;

<shrug> I'd rather just leave these over cluttering up the function with
repeated flags/flags2 endian conversions.

> > +	xfs_nlink_t		nlink;

Actually, we do need this one for proper error reporting because we
still (sort of) have to have v1 disk format support.  For that matter,
the nlink checking further in that function looks totally wrong; it
should be using nlink and not accessing the raw field directly.

> > +	xfs_dqid_t		uid;
> > +	xfs_dqid_t		gid;
> > +	xfs_dqid_t		prid;

These actually are needed, because the quota_add function that uses them
requires pointers to xfs_dqid_t to do some hazy magic to skip quota
accounting if the pointer is null, which implies local variables since
the ondisk inode has be32 values...

That whole thing is messy (and gets worse with the project id) but I'd
rather not go rearchitecting more of db/check.c seeing as we can
probably just kill it after xfsprogs 5.8 releases.

> Not sure we really need the local variables, as they are mostly just
> used once except for error messages..
> 
> > +	if (dip->di_version == 1) {
> > +		nlink = be16_to_cpu(dip->di_onlink);
> > +		prid = 0;
> > +	} else {
> > +		nlink = be32_to_cpu(dip->di_nlink);
> > +		prid = (xfs_dqid_t)be16_to_cpu(dip->di_projid_hi) << 16 |
> > +				   be16_to_cpu(dip->di_projid_lo);
> > +	}
> 
> I mad the assumption that we don't support v1 inodes anymore, but
> it appears we actually do.  So we might need to keep these two.

<nod>

> >  	if (isfree) {
> > -		if (xino.i_d.di_nblocks != 0) {
> > +		if (be64_to_cpu(dip->di_nblocks) != 0) {
> 
> No need to byte swap for a comparism with 0.
> 
> > -	if ((unsigned int)xino.i_d.di_aformat > XFS_DINODE_FMT_BTREE)  {
> > +	if ((unsigned int)dip->di_aformat > XFS_DINODE_FMT_BTREE)  {
> 
> No need for the (pre-existing) cast here.
>
> > +			fmtnames[(int)dip->di_aformat],

Fixed all of these.

--D

> 
> Same here.
