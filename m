Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF888C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 17:12:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B19272068F
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 17:12:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h+sYfami"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbfKSRMO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 12:12:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:60604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfKSRMN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 12:12:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJGsIQU137767;
        Tue, 19 Nov 2019 17:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bPKryyjbDPSWCZV28fNngnyKbmxErRhrEw8+w/XR1dw=;
 b=h+sYfamiEaLC84/oeiiCNz/8vBjfPkYlP/UPmIC8RrcTSq6tJJETLUDY/sGOf8MVeivc
 EZZWXx2OlD+0cOiVnR9SwxbrPk1CyFqjvKnPQh+aTOqKN8HFd5+sEoc/Ngg4OZeb5Sr2
 pbUMsPOlUcsMAogbql40OU/HwPIIn31+QoX8gqwjI7kiHTGph69qKX1su8wSlaBzh7eq
 NSySuinyhlov/QN3cLaf4UtLgr71OjZUsSNsK0yfUqS2op1ehZoOIQDyQszZjZ1TXw8d
 n/crzbyRV5af3xA+cndM95PYp24d3hGXGnC651H/HAlJcONecfd9xVNHw/HN+dcSM2WU +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wa8htrdj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 17:12:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJGs8bk116975;
        Tue, 19 Nov 2019 17:12:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wbxm4k7tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 17:12:08 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAJHC69M016654;
        Tue, 19 Nov 2019 17:12:06 GMT
Received: from localhost (/10.159.131.108)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 09:12:05 -0800
Date:   Tue, 19 Nov 2019 09:12:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/9] xfs: improve the xfs_dabuf_map calling conventions
Message-ID: <20191119171205.GG6219@magnolia>
References: <20191116182214.23711-1-hch@lst.de>
 <20191116182214.23711-3-hch@lst.de>
 <20191117183521.GT6219@magnolia>
 <20191118062505.GB4335@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118062505.GB4335@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=848
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=919 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 18, 2019 at 07:25:05AM +0100, Christoph Hellwig wrote:
> On Sun, Nov 17, 2019 at 10:35:21AM -0800, Darrick J. Wong wrote:
> > On Sat, Nov 16, 2019 at 07:22:07PM +0100, Christoph Hellwig wrote:
> > > Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
> > > a hole is okay and not corruption, and return -ENOENT instead of the
> > > nameless -1 to signal that case in the return value.
> > 
> > Why not set *nirecs = 0 and return 0 like we sometimes do for bmap
> > lookups?
> 
> Sure, I can change it to that for the next version.

Also, I forgot to mention that some of the comments (particularly
xfs_dabuf_map) need to be updated to reflect the new "no mapping" return
style since there's no more @mappedbno, etc.

--D
