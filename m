Return-Path: <SRS0=8CmW=W6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB82C3A59E
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 03:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90B5E216C8
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Sep 2019 03:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EyNtt8lo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfICDWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Sep 2019 23:22:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40198 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfICDWS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Sep 2019 23:22:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x833JrPJ122483;
        Tue, 3 Sep 2019 03:22:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=erS/NKUJ7Yr9GBjKp2Aafi1uP5dr9tVHe2u/yDWAdfk=;
 b=EyNtt8lo/rmaMxxmzbEvVnLvb6H48kzAq7tvTRS3oy2fYOZ3cNSjTLY21u6jdcoRgn6x
 FBo6VNjTn70Mo/0nCYOR2yxSq7+IpFp0BtnWZDjpFjl6CiMax+vIoHZP99fRoNtovBCP
 QInsPIYpn0D44s/kuxfpqgHPCNTqAkep7Bpgg5NXfe7eKjE26MOvAonvoia1fsWzB/b6
 YXE2u7aLKyYZdaDaNfn3LCYvknQHd7v3zc0iH9jAE205dbS39lR3EYkwFfJpVXD0PWIl
 NdUVwfR51Ah3oH9bIybVY9uxZWv74io3X/GN1u8LGiDBM0O6ImvpXYk00vKD6YPD4c9S Dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2usg5vg0cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 03:22:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8337vSR109783;
        Tue, 3 Sep 2019 03:22:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2us4wd4rtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 03:22:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x833MCEv000514;
        Tue, 3 Sep 2019 03:22:12 GMT
Received: from localhost (/10.159.255.57)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Sep 2019 20:22:12 -0700
Date:   Mon, 2 Sep 2019 20:22:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] man: document the new allocation group geometry
 ioctl
Message-ID: <20190903032213.GF568270@magnolia>
References: <156633307176.1215978.17394956977918540525.stgit@magnolia>
 <156633310832.1215978.10494838202211430225.stgit@magnolia>
 <20190830055347.GH1119@dread.disaster.area>
 <20190830204849.GH5354@magnolia>
 <20190902223657.GT1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902223657.GT1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=896
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9368 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=955 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 04, 2019 at 08:36:57AM +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2019 at 01:48:49PM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 30, 2019 at 03:53:47PM +1000, Dave Chinner wrote:
> > > On Tue, Aug 20, 2019 at 01:31:48PM -0700, Darrick J. Wong wrote:
> > > > +	uint64_t  ag_reserved[12];
> > > 
> > > Where's the flags field for feature versioning? Please don't tell me
> > > we merged an ioctl structure without a flags or version field in
> > > it...
> > 
> > Yes, we did, though the "reserved fields are always zeroed" enables us
> > to retroactively define this to v0 of the structure.
> 
> OK, but this is an input/output structure, not an output-only
> structure, so the flags field needs to cover what features the
> caller might be expecting the kernel to return, too.,,

What do you think of the v2 "xfs: define a flags field for the AG
geometry ioctl structure" patch, then?

--D

> > > > +};
> > > > +.fi
> > > > +.in
> > > > +.TP
> > > > +.I ag_number
> > > > +The number of allocation group that the caller wishes to learn about.
> > > 
> > > "the index of"....
> > > 
> > > "The number of" is easily confused with a quantity....
> > > 
> > > Is this an input or an output?
> > 
> > Purely an input.
> > 
> > "The caller must set this field to the index of the allocation group
> > that the caller wishes to learn about." ?
> 
> *nod*.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
