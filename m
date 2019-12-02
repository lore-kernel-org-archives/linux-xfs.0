Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681E8C432C3
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 353FB20640
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:44:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VkNnsoqI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfLBRoJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:44:09 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfLBRoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:44:09 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZFYN044377;
        Mon, 2 Dec 2019 17:44:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=DZE2Dz33MK4Uw9dTUoE85gCpOtY2J8/8SN7KDgx8wWY=;
 b=VkNnsoqI0eJp/QJ4WdnJ/6OxdUWI5x4lIWjmxLpgES4+9L6XrmP9Kc95U9LddkeUV4h2
 LYBlaGnMKRjUSMI8xSA3QdLzPI6Zx27WH0+rufEiBoJTlSV1EPr803mjiyijdF7uknyk
 htyOQeiiaJ5B5BIJnnBKdnyMAiwP++Iy1UdwezXq2XGN5X2AXwz6jd8soGcj0CjcAf9v
 sV/E0ICsSsOXLOqjwzdj3+nCNbg8z9if+BcJfbLXJVR48J1jOsWyu6Xo7dJXKsI6mRKJ
 M2NCPxngAAXcaS3sE0e//1Nh/FScYIaxd7IvWVHhWT6YsXNoS33MpMgAIPviYslQYWV2 NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2wkfuu1s20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:44:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2Hhopu192407;
        Mon, 2 Dec 2019 17:44:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wm1xp84uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:43:59 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2HhrVp014760;
        Mon, 2 Dec 2019 17:43:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:43:53 -0800
Date:   Mon, 2 Dec 2019 09:43:52 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_admin: support external log devices
Message-ID: <20191202174352.GE7335@magnolia>
References: <157530823239.128859.15834274920423410063.stgit@magnolia>
 <157530823862.128859.3517412709152067366.stgit@magnolia>
 <3c0b341f-cd36-10b4-b0eb-29a45867de01@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c0b341f-cd36-10b4-b0eb-29a45867de01@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 11:41:13AM -0600, Eric Sandeen wrote:
> 
> 
> On 12/2/19 11:37 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add to xfs_admin the ability to pass external log devices to xfs_db.
> > This is necessary to make changes on such filesystems.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  db/xfs_admin.sh      |   12 ++++++++++--
> >  man/man8/xfs_admin.8 |    3 +++
> >  2 files changed, 13 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > index 305ef2b7..bd325da2 100755
> > --- a/db/xfs_admin.sh
> > +++ b/db/xfs_admin.sh
> > @@ -7,7 +7,7 @@
> >  status=0
> >  DB_OPTS=""
> >  REPAIR_OPTS=""
> > -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device"
> > +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
> >  
> >  while getopts "efjlpuc:L:U:V" c
> >  do
> > @@ -33,7 +33,15 @@ done
> >  set -- extra $@
> >  shift $OPTIND
> >  case $# in
> > -	1)	if [ -n "$DB_OPTS" ]
> > +	1|2)
> > +		# Pick up the log device, if present
> > +		if [ -n "$2" ]; then
> > +			DB_OPTS=$DB_OPTS" -l '$2'"
> > +			test -n "$REPAIR_OPTS" && \
> > +				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
> > +		fi
> > +
> > +		if [ -n "$DB_OPTS" ]
> >  		then
> >  			eval xfs_db -x -p xfs_admin $DB_OPTS $1
> >  			status=$?
> > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > index 20a114f5..d7942418 100644
> > --- a/man/man8/xfs_admin.8
> > +++ b/man/man8/xfs_admin.8
> > @@ -15,6 +15,9 @@ xfs_admin \- change parameters of an XFS filesystem
> >  .I uuid
> >  ]
> >  .I device
> > +[
> > +.I logdev
> > +]
> 
> logdev should be marked as optional, right?  [logdev] ?

It is.

> And documented as to when this arg should (or should not be) used?

Yes.  Will fix that.

--D

> -Eric
