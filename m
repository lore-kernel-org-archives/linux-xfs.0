Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3460EC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50A3020690
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:37:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fdhqq1jb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbgEMPhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 11:37:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43992 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbgEMPhV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 11:37:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFb9vP076297;
        Wed, 13 May 2020 15:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5C5EcRIC6XldxXoBidQUcdGENIKxGpxI/LMzqkRpfaE=;
 b=Fdhqq1jbNdVcyHtJymfM63dV+NtkBIfyMSkwWANd+QecJ/lRIBwrR4/WcCBKFf4XlEwh
 3cYsW3fBjotrF7OJh5ArgkT9VYlmB3If++DohJR/yIVZHQAAb/Ey0sVajsVPXkblzOsO
 fRnzVmtb2/f+H6tb8lz/AF/cI6hA4TlMEW1VCoOV53dLMolrfPdcmLuGv7KJgokAzo6D
 xdoDQNfEct9Xneph8LAZ69x+EOD3NJJq0eG9AbBUcH6LH8S3bElGu8XgwrqGZowu7cwN
 NBZd8l78lSXT4Hc4kb5mMJ3vnlP2dy4efdin/fXPieeKzZTDC4Etr6jS00aWHSS4iaOf Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3100xwmy8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 15:37:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DFXwSA156290;
        Wed, 13 May 2020 15:35:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3100yardj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 15:35:12 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04DFZBv0002412;
        Wed, 13 May 2020 15:35:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 08:35:11 -0700
Date:   Wed, 13 May 2020 08:35:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 01/16] xfs_repair: fix missing dir buffer corruption
 checks
Message-ID: <20200513153509.GY6714@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904179840.982941.17275782452712518850.stgit@magnolia>
 <20200512172925.GJ6714@magnolia>
 <20200513062216.GA24213@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513062216.GA24213@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 cotscore=-2147483648 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=1 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 11:22:16PM -0700, Christoph Hellwig wrote:
> This looks ok, but it seems like da_read_buf should just return
> the error instead of the b_error mess, at whih point we'd basically
> have xfs_da_read_buf + the salvage flag.  But I guess we can apply
> your patch first to let you make progress first and sort that
> out later:

<nod> I /think/ the value in repair's use of salvage mode here is to be
able to pinpoint exactly which dirent in a directory data block went
bad, and then to log that for the sysadmin as maybe a clue for renaming
files out of lost+found.  We probably don't need salvage mode for
dabtree blocks since that's just indexing data that users never see
directly.

In theory we don't need salvage mode at all, but it's less exciting to
barf out the standard metadata verifier error and have nothing else to
say.

Anyway, thanks for the review.

--D

> Reviewed-by: Christoph Hellwig <hch@lst.de>
