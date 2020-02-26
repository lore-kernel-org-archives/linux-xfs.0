Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB31C4BA1E
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 17:32:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB44222C2
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 17:32:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NXeQch2+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgBZRcl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 12:32:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgBZRcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 12:32:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QHNnbP174560;
        Wed, 26 Feb 2020 17:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=noNh8S2OWx78Ela7q+CA5rV2ahZvGhj42vGRPjgOWUE=;
 b=NXeQch2+l6kDIMLbP1z+g6HNDbHqKl4I21lE4OeNhCMGejwZqiDLunu7lRFenz+edaT2
 oc+siQndMiNBlvSKWR1bT1Rwrxn9oX8snCB6nwDAs6uFJt1CdcJ/vJ29r3nhFQVuZsIg
 hqvyhEM6qbWmb5JGvGt45/gWHACDc68+w26LLTRn0GXtJXE7n+vLCdikpX3AdqYPtd8c
 Sf+UyrttWRdpyntaOnQvhFxmzxEyFXDegMGxlxAuZ6NsrZnQMji1NwjgTjstGBpKHoC6
 ZjMsTLh6SZ1Q3/XC0sBf1T797+eesU94Rg4EcmgmaFo4KKpTUSoFzQNGTAmmQdc6tOuD dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ydcsnd87r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 17:32:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01QHW3vK020809;
        Wed, 26 Feb 2020 17:32:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ydj4j1x25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 17:32:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01QHWcl3015462;
        Wed, 26 Feb 2020 17:32:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Feb 2020 09:32:37 -0800
Date:   Wed, 26 Feb 2020 09:32:36 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Subject: Re: [PATCH 3/7] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
Message-ID: <20200226173236.GG8045@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086361666.2079685.8451949513769071894.stgit@magnolia>
 <402fd276-109a-3f46-8b9f-68bcf836c001@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <402fd276-109a-3f46-8b9f-68bcf836c001@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260114
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 26, 2020 at 09:19:53AM -0800, Eric Sandeen wrote:
> On 2/4/20 4:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > xfs_repair has a very old check that evidently excuses the AG 0 inode
> > btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> > AG headers).  mkfs never formats filesystems that way and it looks like
> > an error, so purge the check.  After this, we always complain if inodes
> > overlap with AG headers because that should never happen.
> 
> On a previous version, you and Brian had a fairly long conversation about
> the warning this presents, and how it doesn't tell the user what to do
> about it, and how the warning will persist, and may generate bug reports
> or questions.
> 
> It sounded like you had a plan to address that, which does not seem to be
> present in this patch? So I'm not sure Brian's concerns have been resolved
> yet.

I'm confused about "the warning this presents" -- are you talking about
this patch specifically, where we couldn't figure out the weird masking
behavior that dated back to 2001 and the hysterical raisins?

Or are you referring to Brian's criticism of earlier versions of this
series that would whine about our root inode computation not leading to
the root inode without actually telling the user what to do about it?

If it's the second, then I the answer is that I added another patch
("xfs_repair: try to correct sb_unit value from secondaries") to try to
recover a working sunit value from the backup superblocks, or try some
power of two guesses to see if we find one that matches, and then reset
the value to something that will make the computation work again.

--D

> 
> -Eric
