Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BA2C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 16:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E5420674
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 16:12:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W1ttpb0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgERQM2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 12:12:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60312 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbgERQM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 12:12:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IGBQ1D008544;
        Mon, 18 May 2020 16:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zdqCWsb1vGZw8kixSzqAZYA2nCblzLjNRelLY84gkxc=;
 b=W1ttpb0X02ejOQbNRwr++3ZC7oNwWoBmjV4EslkqY23+nPGgiqNKIoZ7GBIB17S2d2oD
 ySAgZ9xDa5j8v9iiOpYApmkXk3rYSr7NhzcVrcDzv4oT7Udgd+fXYTPjcg2C1nPD48kk
 O4LQnDgCKtLVa32+rhG1amBETzpe3WUpMCCGZ0x4BJad7GGsAOt10uEPUOb8/Kzbop25
 v1Yt1eEjeb8vXYz7PtUxlGrAnAGlrhgqVYqDwp8qXos+5CXEArvF1JKiAiZ4/YOg8Luh
 LbhV3l+IYDW3fAx/lShA/m9OFM/glsxPtF+2fPsS6+/TIwXOTQ0k193/yOTi5qBLHcK4 Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tn7ndb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 16:11:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IG2uFw172224;
        Mon, 18 May 2020 16:11:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t31d31j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 16:11:44 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04IGBglk006310;
        Mon, 18 May 2020 16:11:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 09:11:42 -0700
Date:   Mon, 18 May 2020 09:11:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to 5d0807ad
Message-ID: <20200518161141.GC17627@magnolia>
References: <ec63ae12-41b0-26e7-0a60-72820f7385c6@sandeen.net>
 <20200518073246.GA7973@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518073246.GA7973@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 12:32:46AM -0700, Christoph Hellwig wrote:
> Btw, some time after xfsprogs 5.6, xfstests generic/590 start to fail
> with new xfs_check errors in the form of:
> 
> rtblock 1048576 beyond end of expected area
> rtblock 1048576 beyond end of expected area
> rtblock 1048580 beyond end of expected area
> rtblock 1048580 beyond end of expected area
> rtblock 1048584 beyond end of expected area
> rtblock 1048584 beyond end of expected area
> rtblock 1048588 beyond end of expected area
> rtblock 1048588 beyond end of expected area
> rtblock 1048592 beyond end of expected area
> rtblock 1048592 beyond end of expected area
> rtblock 1048596 beyond end of expected area
> rtblock 1048596 beyond end of expected area
> rtblock 1048600 beyond end of expected area
> 
> 

That's probably the bounds check I added in commit
7161cd21b3ed3fa82aef1f13b2bcfae045208573

So either I've gotten the units wron.... aha, I see it:

static inline bool
rdbmap_boundscheck(
	xfs_rfsblock_t	bno)
{
	return bno < mp->m_sb.sb_agblocks;
}

That should have been sb_rblocks.

--D
