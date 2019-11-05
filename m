Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4842CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95185214E0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 02:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mnn2sr5U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfKECBo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:01:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfKECBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 21:01:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xL1l169547;
        Tue, 5 Nov 2019 02:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=dMRBvNyfUW2yIEKi0evLODb5mw+XjJRfsyrOxwI2qxc=;
 b=Mnn2sr5UGcr95LK+0eXs6vM2i6eEmpkG5WYyCtV846y9zs5T9DGGrrlX9Jxz9UBM45Ep
 131eD9qC/Y3tN6GtcN4KAs32d60d9VBXRfHfsi37yA4UlJWekYjgk+DtF7Fk8g8qH0fy
 qFNjB6B/f3WZk0qN/cA2FixAqH5y927sbG1b0wrAu6OWjOk4zAayTytDK+mLdRjpQi6w
 aDmnSPVFEAa/KHCdKesRMaKu114ZftTnmPc1CDbWzwAJp4eFrgmRjFF9vPkoLCNw2Rda
 TUYrSdYMvsblQ12wQf8bSqPmMEiD9NiVevtPvPfRWwJIhAM09JO4VxPXAYwPH01pym1T Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w11rpu3pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 02:01:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA51xI7n061358;
        Tue, 5 Nov 2019 01:59:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w1kxeb60e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 01:59:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA51xc1V011348;
        Tue, 5 Nov 2019 01:59:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 17:59:38 -0800
Date:   Mon, 4 Nov 2019 17:59:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] xfs: make the xfs_dir3_icfree_hdr available to
 xfs_dir2_node_addname_int
Message-ID: <20191105015937.GZ4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-15-hch@lst.de>
 <20191104202523.GS4153244@magnolia>
 <20191105015254.GE32531@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105015254.GE32531@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 05, 2019 at 02:52:54AM +0100, Christoph Hellwig wrote:
> On Mon, Nov 04, 2019 at 12:25:23PM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 01, 2019 at 03:06:59PM -0700, Christoph Hellwig wrote:
> > > Return the xfs_dir3_icfree_hdr used by the helpers called from
> > > xfs_dir2_node_addname_int to the main function to prepare for the
> > > next round of changes.
> > 
> > How does this help?  Is this purely to reduce stack usage?  Or will we
> > use this later to skip some xfs_dir2_free_hdr_from_disk calls?
> 
> The latter.

Might be a good idea at least to hint at that in the commit message.

--D
