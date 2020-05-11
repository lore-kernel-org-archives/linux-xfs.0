Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1BDC47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 269EC2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 16:22:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eNiuuD4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgEKQWs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 12:22:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgEKQWs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 12:22:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04BGD1qW117052;
        Mon, 11 May 2020 16:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FG1xKKC1yhLYHGzC2v5eeBk0+vXLbA4/jKCkc/sqHoc=;
 b=eNiuuD4dzYA2kt3o9lnTgtpw86tGSaCBzjXVxDhkGEeT1RBVnquZV0jNYXVkOKKlEK7B
 hWDxdCv1r6EuXXxAcYZmYyAWS9aIgs1wBetJfzXYuoCOBglDeThkr1gTfQUjBrYPFiWr
 eaofbDOm8P/H34kjEk1treMaSucRYHss7f48G4aSZgOiRde/ru1UKwFSUgt7hTHESeY5
 9/abc1IFIpIr+zqjDJh5bwtPheNCQYDH58zhcPcbYAFycya1mhZf0jGz2eHJmxYB1e7o
 zkRw3dXQcKA65HJm4s1pM0hGap9hZOSRrHrpHHfew50ttFiWY/z6qD95Z+ekLO4ZBXL8 fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30x3mbp3pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 May 2020 16:22:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04BGDZD9011375;
        Mon, 11 May 2020 16:22:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30x63n10jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 May 2020 16:22:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04BGM4lP005803;
        Mon, 11 May 2020 16:22:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 09:22:04 -0700
Date:   Mon, 11 May 2020 09:22:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/16] xfs_repair: convert to libxfs_verify_agbno
Message-ID: <20200511162203.GZ6714@magnolia>
References: <158904179213.982941.9666913277909349291.stgit@magnolia>
 <158904185435.982941.16817943726460132539.stgit@magnolia>
 <20200509171830.GC15381@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509171830.GC15381@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=1
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005110127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 impostorscore=0
 mlxscore=0 suspectscore=1 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005110127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:18:30AM -0700, Christoph Hellwig wrote:
> On Sat, May 09, 2020 at 09:30:54AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert the homegrown verify_agbno callers to use the libxfs function,
> > as needed.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This looks mostly good, but there is one thing I wonder about:
> 
> >  	bno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
> > -	if (bno != 0 && verify_agbno(mp, agno, bno)) {
> > +	if (libxfs_verify_agbno(mp, agno, bno)) {
> 
> Various of these block is non-zero check are going away.  Did you
> audit if they weren't used as intentional escapes in a few places?

Yes.  Each of those "bno != 0" checks occurs in the context of checking
an AG header's pointer to a btree root.  The roots should never be zero
if the corresponding feature is enabled, and we're careful to check the
feature bits first.

AFAICT that bno != 0 check is actually there to cover a deficiency in
the verify_agbno function, which is that it only checked that the
supplied argument didn't go past the end of the AG and did not check
that the pointer didn't point into the AG header block(s).

Checking for a nonzero value is also insufficient, since on a
blocksize < sectorsize * 4 filesystem, the AGFL can end up in a nonzero
agbno.  libxfs_verify_agbno covers all of these cases.

> Either way this should probably be documented in the changelog.

Ok, how about this for a commit message:

"Convert the homegrown verify_agbno callers to use the libxfs function,
as needed.  In some places we drop the "bno != 0" checks because those
conditionals are checking btree roots; btree roots should never be
zero if the corresponding feature bit is set; and repair skips the if
clause entirely if the feature bit is disabled.

"In effect, this strengthens repair to validate that AG btree pointers
neither point to the AG headers nor point past the end of the AG."

--D
