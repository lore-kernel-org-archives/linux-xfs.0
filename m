Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34D48C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 14:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1D1820782
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 14:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LAAbNo/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHYOm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 10:42:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54380 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHYOm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 10:42:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PEdElG140464;
        Tue, 25 Aug 2020 14:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2Lwd4N5+KqnRtAamCUxViPlr/jmTvnn5TUDM1izoE8c=;
 b=LAAbNo/xe7rX+ZVySowmx3bogeWLu7997/yQ9zuftr3L96tlRfbc1wgbPt3MbgyOCaSD
 0eRVxBMT4JWcBbauFa6a5xYpsjUNMWVt5LFk+Lnhjeo0LscDolLBHkF9sKulgLT+Ml7K
 26YFqAVXNcJwsd1YEdfDqJ9d1b5MQGVNzqswnPNFrMUK8beR5eCKlOlILXeOtJsDoMfX
 Sx4o6mmd2UrCRDXbt5nu2rpCPFyQz6gEYOqGarsiFwzdxswA0JNUbk2Yk84eH49CqHhp
 xVwIAEawturWTkzYQ6GvecoU7sIZeGLShZS6WbuMXK5V7H3IQEWNLhbcu2xfF7yPJrMy HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6tsedg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 14:42:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PEUnZ7161189;
        Tue, 25 Aug 2020 14:40:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9jy9ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 14:40:18 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07PEeHmQ029087;
        Tue, 25 Aug 2020 14:40:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 07:40:16 -0700
Date:   Tue, 25 Aug 2020 07:40:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>,
        Anthony Iliopoulos <ailiop@suse.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
Message-ID: <20200825144015.GB6096@magnolia>
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824225533.GA12131@dread.disaster.area>
 <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9723 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 08:59:39AM -0500, Eric Sandeen wrote:
> On 8/24/20 5:55 PM, Dave Chinner wrote:
> > I agree that mkfs needs to be aware of DAX capability of the block
> > device, but that capability existing should not cause mkfs to fail.
> > If we want users to be able to direct mkfs to to create a DAX
> > capable filesystem then adding a -d dax option would be a better
> > idea. This would direct mkfs to align/size all the data options to
> > use a DAX compatible topology if blkid supports reporting the DAX
> > topology. It would also do things like turn off reflink (until that
> > is supported w/ DAX), etc.
> > 
> > i.e. if the user knows they are going to use DAX (and they will)
> > then they can tell mkfs to make a DAX compatible filesystem.
> 
> FWIW, Darrick /just/ added a -d daxinherit option, though all it does
> now is set the inheritable dax flag on the root dir, it doesn't enforce
> things like page vs block size, etc.
> 
> That change is currently staged in my local tree.
> 
> I suppose we could condition that on other requirements, although we've
> always had the ability to mkfs a filesystem that can't necessarily be
> used on the current machine - i.e. you can make a 64k block size filesystem
> on a 4k page machine, etc.  So I'm not sure we want to tie mkfs abilities
> to the current mkfs environment....
> 
> Still, I wonder if I should hold off on "-d daxinherit" patch until we
> have thought through things like reflink conflicts, for now.
> 
> (though again, mkfs is "perfectly capapable" of making a consistent
> reflink+dax filesystem, it's just that no kernel can mount it today...)

No, please don't layer additional meanings onto daxinherit=1.

I actually /do/ want to have a -d dax=1 option for "set up this
filesystem for DAX" that will configure the geometry for that device to
play nicely with the things that (some) DAX users want.

IOWs, you say "-d dax=1" and that means that mkfs sniffs out the
DAXiness of the underlying device and the PMD size.  Then it turns off
reflink by default, sets the daxinherit=1 hint, and configures the
extent size and su/sw hints to match the PMD size.

Or, you say "-r dax=1" for the realtime device, and now it sets the
allocation unit to the PMD size for people running huge databases and
want only huge pages to back their table data<cough>.

Zooming out a bit, maybe we should instead introduce a new "tuning"
parameter for -d and -r so that administrators could tune the filesystem
for specific purposes:

	-d tune=dax: Reject if device not dax, set daxinherit=1, set
	extsize/su/sw to match PMD

	-d tune=ssd: Set agcount to match the number of CPUs if
	possible, make the log larger to support a large number of
	threads and iops.

	-d tune=rotational: Probably does nothing. ;)

	-d tune=auto: Query blkid to guess which of the above three
	profiles we should use.

	-d tune=none: No tuning.

And then you'd do the same for the realtime device.

This would help us get rid of the seeeekret mkfs wrapper that we use to
make it easier for our internal customers to use DAX since mkfs.xfs
doesn't support config files.

--D

> -Eric
