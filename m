Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by sandeen.net (Postfix) with ESMTP id 4EB087880
	for <sandeen@sandeen.net>; Wed, 11 Mar 2020 10:46:53 -0500 (CDT)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgCKPrf (ORCPT <rfc822;sandeen@sandeen.net>);
        Wed, 11 Mar 2020 11:47:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46404 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730030AbgCKPre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 11:47:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BFf1VG075913;
        Wed, 11 Mar 2020 15:47:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=OB4fe357SDa3Nfjnb0CmiRTkS8JHgKyjJxCK9Ie8uKU=;
 b=tcDhLnMRweN0Mdp+JziK+qDRBDUkkW+yj/7SD5qGHVtbrhTem8qb3Wib4dl/9jbOfA91
 P5PGG6x1PhGHX046G4D7fWjp6xidNCpecLTV+EFYs75lAM30A8OWZf99OwM8EAAo/pSp
 is1UjAw6OM6mTC8bONCWVNe/WTZYXqAajx5xkDxTPpDA1XeaPpZRnV3qTQQFKWYKhABS
 CCeiBPAgSKKN33h+5cWclbXVaa0RwiGQpb013DIqG7bWxBR4NUF2E/leFYqX8xahRmNv
 ADX4bNjg19d4PIh6jinj0yNNcShTWU0Rl3T43bgVoTJmCkP1rMvECTTyqJKx/PQSvIb0 XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31umj5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 15:47:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02BFWb1x061465;
        Wed, 11 Mar 2020 15:47:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ypv9vdh4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Mar 2020 15:47:26 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02BFlPm2025545;
        Wed, 11 Mar 2020 15:47:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 08:47:25 -0700
Date:   Wed, 11 Mar 2020 08:47:25 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
Message-ID: <20200311154725.GD8045@magnolia>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
 <158388763048.939081.7269460615856522299.stgit@magnolia>
 <20200311064011.GA25435@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311064011.GA25435@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003110098
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

On Tue, Mar 10, 2020 at 11:40:11PM -0700, Christoph Hellwig wrote:
> On Tue, Mar 10, 2020 at 05:47:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
> > instead, but we forgot to teach xfs_rmap_has_other_keys not to return
> > that magic value to callers.  Fix it now.
> 
> This doesn't document the remap of the has_rmap flag.  As far as I can
> tell that isn't needed now the caller checks for ECANCELED, but it
> takes a while to figure that out.  It'll need to be documented properly
> in the commit log.

"Fix it now by using ECANCELED both to abort the iteration and to signal
that we found another reverse mapping.  This enables us to drop the
separate boolean flag." ?

--D

