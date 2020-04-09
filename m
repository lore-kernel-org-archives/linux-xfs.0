Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3599EC2BB86
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 14:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 050CD208FE
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 14:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vKEddehW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgDIOwq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:52:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgDIOwq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 10:52:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039EmFYd067940;
        Thu, 9 Apr 2020 14:52:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3GTBSMSI3uCfyion1WPUOtblA5LVBEmYJDDdIqdRXs0=;
 b=vKEddehWrYDfQaSaBHO8m2S8hLKsQJjSzPrCHZlQqIip+282XW4jW1xgRQ2gztoji5zp
 n04/PYAtRYGUZopcpcEnKTpnShjr2QGNLmrcALw0iLqh3xaWib8MijdLiYiIuQCGLIut
 1ZZy3mOJDW9XjesTKh4dGg2WDjv5CBPyf5RBjavkcvPUSvwdgChTS1OhuxGIy2YrvvOY
 XMfXEdcB0FZYOYcC/lGdOgXGkthTBrMi0RtH5XAzvzrufxgxlcZ274foqSYfnH+V65Ci
 LjGnKkpr9CZHNBnCUXxTifahW0Mvy1EpVx+NDJiurDyp7/LGOzUDfP4lfIsXHJ+4viKr +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3091m3hyh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 14:52:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039ElQLl046158;
        Thu, 9 Apr 2020 14:52:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3091m49m4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 14:52:14 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 039Eq8Df028795;
        Thu, 9 Apr 2020 14:52:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 07:52:08 -0700
Date:   Thu, 9 Apr 2020 07:52:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Chandan Rajendra <chandan@linux.ibm.com>,
        linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        fstests@vger.kernel.org
Subject: Re: xfs_check vs. xfs_repair vs. the world^W^Wfstests
Message-ID: <20200409145207.GL6742@magnolia>
References: <20200408030031.GB6740@magnolia>
 <2574725.68tNun6CyS@localhost.localdomain>
 <20200409074028.GB21033@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200409074028.GB21033@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 09, 2020 at 12:40:28AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 08, 2020 at 10:23:21AM +0530, Chandan Rajendra wrote:
> > > Not sure what to do about quota in repair -- we could build in the
> > > ability to do quota counts since we scan the whole inode table and
> > > directory tree anyway.  From there it's not so hard to rebuild the quota
> > > inodes too.
> > >
> > 
> > I will take up this work and get it completed.
> > 
> > Since I have other higher priority tasks at work place, I will have this as my
> > secondary focus. Meanwhile, until it gets done, can we disable running these
> > tests on block size > 4k i.e. https://patchwork.kernel.org/patch/11454399/.
> 
> I still think even with the above outstanding issues we should not
> run check by default.  We can still opt into it, but check extends
> the run time of xfstests for not very good reasons.

So do I, and when I proposed it back in 2018[1], Dave indicated that we
ought to get to the point where we don't need to xfs_check as a
cross-check for xfs_repair.  I'm working on fixing up the smaller things
that repair doesn't catch, so once that series lands maybe we can just
drop xfs_check?

(Since the only big discrepancy at that point will be the lack of quota
checking...)

--D

[1] https://lore.kernel.org/fstests/20180214212228.GG7000@dastard/
