Return-Path: <SRS0=eQYP=24=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6715DC33C9E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 18:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DE75222D9
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jan 2020 18:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cTeiS/Zz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgAGSwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 13:52:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGSwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 13:52:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007In640006856;
        Tue, 7 Jan 2020 18:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RH55Q8AOGScmovubcyILiqEgNgHLLVIJC2us/cB7ITI=;
 b=cTeiS/ZzsDGy7wkkKTXFCgItGf0RCzFFBj1dANiUH9NU5GPVUg8+SSVR04MWocOWp5r3
 JBfsF1aI2amW9z/Q9wsTZ/LEcxbaUkdklUF11sgX2+pv4M/sEVBCAnE6yJ54LwA44ZNz
 e9QXlXNcjyt5IarF7wc+b7+tuaOnc6lA+ZyQdzl8f+ZU9N3uABWbwbhcmSZyk+/hzEz0
 pok2gtvOV4eEdSXRLmrv3CKoAqCcSE4DuBLU7OBnEXzrexHJoGcTPYeT+rBRbYQlKwon
 859GJK/F+gc0ZCDTxfSV6/K1PbrSt3NBaVB/nCC7oDizg/SKxgYxWFIXL+RJifdpe6oq tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xajnpyepq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 18:51:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007InI5U079062;
        Tue, 7 Jan 2020 18:51:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xcpcqv54s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 18:51:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007Ipq79017148;
        Tue, 7 Jan 2020 18:51:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 10:51:52 -0800
Date:   Tue, 7 Jan 2020 10:51:51 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] debian: turn debhelper compat level up to 11
Message-ID: <20200107185151.GC917713@magnolia>
References: <157784176039.1372453.10128269126585047352.stgit@magnolia>
 <157784177377.1372453.1008055450028015778.stgit@magnolia>
 <20200107142123.GB17614@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107142123.GB17614@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 07, 2020 at 06:21:23AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 31, 2019 at 05:22:53PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Upgrade to debhelper level 11 to take advantage of dh_installsystemd,
> > which greatly simplifies the installation and activation of the scrub
> > systemd services.
> 
> The subject and description seem upside down.  You want to use
> dh_installsystemd, and to do so you'll have to bump the level..

Heh, ok.

"debian: install scrub services with dh_installsystemd

"Use dh_installsystemd to handle the installation and activation of the
scrub systemd services.  This requires bumping the compat version to
11."

(Admittedly the subject was a riff on the old 'turn it up to 11' joke)

Related question: Are Debian oldoldstable and Ubuntu 16.04LTS old enough
to drop the "debian: permit compat level 9 dh builds" patch?  On systems
with software that old the kernel isn't going to support scrub, and who's
going to build xfsprogs 5.xx for those old systems?

--D
