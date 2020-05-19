Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D001BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 06:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A412520708
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 06:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zUAnqBaJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgESGXr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 02:23:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgESGXq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 02:23:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J6LrvU028464;
        Tue, 19 May 2020 06:23:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mwa7X0nTiFeCnzh3zxYX3+Mnt0kBSxzW+iVncXmYvKM=;
 b=zUAnqBaJ8FsZ7gjO4aaj3BjLk11O6zFeIGjM6wsYPn2wO7yciuezy7QoXNKn2FOyDY6z
 70OZKnwQGdajYRj+/tcZCOMhUSQPcyRAJCDV+50vfpnowhe2nsUwK5JvluoNf+qfhJLr
 3prIZmcHzAUHaSE9FsqCXO0Mc462znpnC8Iiy9HveWi89e0Ruh7sAeqm+O7sprPIGGN0
 N8eaAJ8ZY6iW1JRNKiLUMYjsh1+zzJmkuTZPEbPl/ETNUQJayNBhC/zQcEfoZtBSIA21
 xZx/OUOjTOPVW89HKVivcn1GKhgEIDek8hC0gtkNZIr6366RzFUs+oXLoRJWpwA9yXRP 8A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284ku498-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 06:23:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04J6INPp037572;
        Tue, 19 May 2020 06:23:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 312t3x9sj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 06:23:42 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04J6Nds5019729;
        Tue, 19 May 2020 06:23:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 23:23:39 -0700
Date:   Mon, 18 May 2020 23:23:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
Message-ID: <20200519062338.GH17627@magnolia>
References: <20200513023618.GA2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513023618.GA2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=1 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190055
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190056
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 12:36:18PM +1000, Dave Chinner wrote:
> 
> Topic: Deprecating V4 On-disk Format
> 
> Scope:
> 	Long term life cycle planning
> 	Supporting old filesystems with new kernels.
> 	Unfixable integrity issues in v4 format.
> 	Reducing feature matrix for testing
> 
> Proposal:
> 
> The CRC-enabled V5 format has been the upstream default format now
> since commit 566ebd5ae5fa ("mkfs: default to CRC enabled
> filesystems") dated May 11 2015 (5 years ago!) and released in
> xfsprogs v3.2.3. It is the default in all major distros, and has
> been for some time.
> 
> We know that the v4 format has unfixable integrity issues apart from
> the obvious lack of CRCs and self-describing metadata structures; it
> has race conditions in log recovery realted to inode creation and
> other such issues that could only be solved with an on-disk format
> change of some kind. We are not adding new features to v4 formats,
> so anyone wanting to use new XFS features must use v5 format
> filesystems.
> 
> We also know that the number of v4 filesysetms in production is
> slowly decreasing as systems are replaced as part of the natural
> life cycle of production systems.
> 
> All this adds up to the realisation that existing v4 filesystems are
> effectively in the "Maintenance Mode" era of the software life
> cycle. The next stage in the life cycle is "Phasing Out" before we
> drop support for it altogether, also know around here as
> "deprecated" which is a sign that support will "soon" cease.
> 
> I'd like to move the v4 format to the "deprecated" state as a signal
> to users that it should really not be considered viable for new
> systems. New systems running modern kernels and userspace should
> all be using the v5 format, so this mostly only affects existing
> filesystems.
> 
> Note: I am not proposing that we drop support for the v4 format any
> time soon. What I am proposing is an "end of lifecycle" tag similar
> to the way we use EXPERIMENTAL to indicate that the functionality is
> available but we don't recommend it for production systems yet.
> 
> Hence what I am proposing is that we introduce a DEPRECATED alert at
> mount time to inform users that the functionality exists, but it
> will not be maintained indefinitely into the future. For distros
> with a ten year support life, this means that a near-future release
> will pick up the DEPRECATED tag but still support the filesystem for
> the support life of that release. A "future +1" release may not
> support the v4 format at all.

/me regrets that he is frequently failing to clear enough space out of
his schedule to respond to all of these adequately.  But here goes,
random thoughts at 23:23. :/

> Discussion points:
> 
> - How practical is this?

Well, we've killed off old features before... v1 inodes, v2 directories,
etc.  So clearly this can be done, given enough preparation time.

And we probably ought to do it, before we start to resemble the ext4
quota nightmare.

> - What should we have mkfs do when directed to create a v4 format
>   filesystem?

It probably ought to print a warning...

That said, way back when we were arguing with the syzbot people, one of
us suggested that we hide V4 behind a CONFIG_XFS_DEPRECATED=y option, so
that people who want to harden their kernel against the unfixable
structural problems in the V4 format could effectively lose V4 support
early.  Maybe we should add that for a few years?

> - How long before we decide to remove v4 support from the upstream
>   kernel and tools? 5 years after deprecation? 10 years?

That probably depends a lot on how much our respective employers want to
keep those old XFSes going.  Some of our customers are about ready to
certify that they can support their distro defaults changing from ext3
to XFS v4, but those folks have support contracts that won't terminate
until whenever the so^Hun goes out.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
