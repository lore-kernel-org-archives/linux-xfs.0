Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CFBC83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26EAD20575
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 22:38:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lsb7iHXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgD1WiU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:38:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1WiU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 18:38:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMWxsO026831;
        Tue, 28 Apr 2020 22:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=8JciezcWWeX4CVfxOfVtQc/3g+hRgdjAhcYPOyAaR8c=;
 b=lsb7iHXIIVVcNKKOSUiBhGRHcr87haSnK/jZ4LFXRTG6VEe1egHRK8Qzu8UBnh+qrsA3
 bonoy0WHc56hosozly+RDKGeHdmZFX95DQ/PoVBYkShY/qSA9xn+8KSQUUWoAT6+lpZH
 m1Norp6779JmjqwLuHi53OY8m6FsPLXf18jjiOSOWomYB2d/DE7JlO+Re2OPvMr3wiVq
 xWare/VFzmEMQN/7QDoxNMTbOaszGkcwNtKW64LlsibuiCvFx2ySH9HGiYjnPnSsc3Nn
 R6v7e2+g928ZYaFFk81p2jtXGeshuHuV1Gyk+k0cFBV0G0NP5fGrdiRglxidpsS/j/Np Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucg2qbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:38:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03SMc0Eh158206;
        Tue, 28 Apr 2020 22:38:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30pvcycp3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 22:38:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03SMcFKY003212;
        Tue, 28 Apr 2020 22:38:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 15:38:15 -0700
Date:   Tue, 28 Apr 2020 15:38:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/19] xfs: move xlog_recover_intent_pass2 up in the file
Message-ID: <20200428223814.GM6742@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
 <158752128537.2140829.17923623833043582709.stgit@magnolia>
 <20200425183644.GJ16698@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425183644.GJ16698@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=944
 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 25, 2020 at 11:36:44AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 21, 2020 at 07:08:05PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move xlog_recover_intent_pass2 up in the file so that we don't have to
> > have a forward declaration of a static function.
> 
> FYI, I'd expect IS_INTENT and IS_INTENT_DONE to simply be flags in the
> xlog_recover_item_type structure.

If I simply gave every XFS_LI_* type code its own
xlog_recover_item_type, there wouldn't even be a need for that.

Though I dunno, an entire xlog_recover_item_type for each of the done
item types might be a lot of NULL space.  <shrug> Maybe I'm stressing
out too much over 8 * 6 pointers == 400 bytes.

--D
