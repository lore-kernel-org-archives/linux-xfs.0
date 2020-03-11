Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by sandeen.net (Postfix) with ESMTP id 41D237880
	for <sandeen@sandeen.net>; Wed, 11 Mar 2020 11:01:27 -0500 (CDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729646AbgCKQCK (ORCPT <rfc822;sandeen@sandeen.net>);
        Wed, 11 Mar 2020 12:02:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35132 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729704AbgCKQCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 12:02:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BFesTc075426;
        Wed, 11 Mar 2020 16:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3b3Nr921HTGqHxLAOFsAAetELitsPXnTo8aLpWQtoyc=;
 b=bNNws/4xioqD5MJSQOBHaJQSnkZsUrxVJb7boDFcLpROk2527a78FmFMeTpAVN7nN4D4
 aSseuU9GJvl+5jaaKzDpPctgoqAPHx/i7s3GqmWET8KLktvh4iNDlrXrCxYueyRR5AoC
 QUVD4mFGkwSkS+DJ7yl2dEQUPKmlvORhzyAT7eVrvlulvjKBPD/PpKklXBK33D2BQcMN
 ir9sKfeq88LrYvJ65fVspARWS3KSp0TuMuOLDy95B2EGehgVnGe0FW7IidsKMrb7KVF9
 cTtwogX1VgCNCmcrEUn1cAdm60wRzHCjpUki881dQfn5LBbwu5iA8GnKAHcyeG1iqZX6 SQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ym31umnbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 16:02:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BFnEC8036448;
        Wed, 11 Mar 2020 16:02:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yp8p3ufft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 16:02:05 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02BG25RX017358;
        Wed, 11 Mar 2020 16:02:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 09:02:05 -0700
Date:   Wed, 11 Mar 2020 09:02:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Message-ID: <20200311160205.GE8045@magnolia>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
 <20200311064011.GA25435@infradead.org>
 <20200311154725.GD8045@magnolia>
 <20200311155244.GA5409@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311155244.GA5409@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110098
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 08:52:44AM -0700, Christoph Hellwig wrote:
> On Wed, Mar 11, 2020 at 08:47:25AM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 10, 2020 at 11:40:11PM -0700, Christoph Hellwig wrote:
> > > On Tue, Mar 10, 2020 at 05:47:10PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
> > > > instead, but we forgot to teach xfs_rmap_has_other_keys not to return
> > > > that magic value to callers.  Fix it now.
> > > 
> > > This doesn't document the remap of the has_rmap flag.  As far as I can
> > > tell that isn't needed now the caller checks for ECANCELED, but it
> > > takes a while to figure that out.  It'll need to be documented properly
> > > in the commit log.
> > 
> > "Fix it now by using ECANCELED both to abort the iteration and to signal
> > that we found another reverse mapping.  This enables us to drop the
> > separate boolean flag." ?
> 
> Sounds good.

Ok, I'll respin this one.

--D

