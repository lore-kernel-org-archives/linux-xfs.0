Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BDEC33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 16:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A67E206D7
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 16:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GpJW8BcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAOQeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 11:34:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgAOQeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 11:34:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGNJXQ175180;
        Wed, 15 Jan 2020 16:34:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=9dDz5WOpfGQ018tLz+CK9JPV+063r2gbHsz1w3tyak8=;
 b=GpJW8BcMF8ZQ2HfqLJUzMVwbwVFtItUI3mFi/9BoJEdqDvTT4nyCxWX6usobfPJVSTJ9
 lDek6r5vMnVgedBF0oPXTn1tk/k9ahSIuo1xp6odz9ySikfTQ0MSVdly9z9Q61IzUR9p
 8T4RVUw6qo8jknpC/MxL84IBjPJ3QdLwf+96xs4HV2qpt2mtrIBRod6JXaPGiDWv4yRe
 q+irs+7/CfMRb4pfHe24mzWnQciRW44O/RBXZQXG75ekXgoGETnT25AD8/yyiTMmw21m
 tZKAo1/fdrDho9Nxv080OS/by05NvrxCjIuaRrezd4w7q3H6CGoBolUFG2ZpeOZWPx4S gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73tw54u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 16:34:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FGOVIa119547;
        Wed, 15 Jan 2020 16:34:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xj1apqy7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 16:34:38 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00FGYc4T016440;
        Wed, 15 Jan 2020 16:34:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 08:34:37 -0800
Date:   Wed, 15 Jan 2020 08:34:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: 2019 NYE Patchbomb Guide!
Message-ID: <20200115163435.GE8257@magnolia>
References: <6b5080eb-cb85-4504-a13b-bf9d90e4ad0d@default>
 <20200115151219.GA9817@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115151219.GA9817@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 07:12:19AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 31, 2019 at 05:25:08PM -0800, Darrick Wong wrote:
> > Hi folks,
> > 
> > It's still the last day of 2019 in the US/Pacific timezone, which means
> > it's time for me to patchbomb every new feature that's been sitting
> > around in my development trees!  As you know, all of my development
> > branches are kept freshly rebased on the latest Linus kernel so that I
> > can send them all at a moment's notice.  Once a year I like to dump
> > everything into the public archives to increase XFS' bus factor.
> 
> It seems like you missed the stale data exposure fix series using
> unwritten extents in buffered writeback.  Can we get that one off the
> back burner?

Aha, at least two people read the guide! :)

Yeah, I'll repost them shortly, though iirc the last time I posted them
Dave complained about the performance impacts.

Personally I think it's more important to guarantee that we can never
return disk garbage after a crash, but nobody RVBd the series so it
stalled.

--D
