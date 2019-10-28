Return-Path: <SRS0=q11v=YV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22F9CA9EC1
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 23:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71ACC21479
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Oct 2019 23:35:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iDDhcbnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731554AbfJ1Xe7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Oct 2019 19:34:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43986 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729755AbfJ1Xe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Oct 2019 19:34:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SNXdEV190720;
        Mon, 28 Oct 2019 23:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=u/flHAMyb8LaLruQWCmNz7QrrtlbDFpiJepoWYZ6iV8=;
 b=iDDhcbnF9E8Ibc3YSmIxU6Kt1vYOG9AQi8u1rxiP7FxKzyKBpJazuOC7qGDcr8sqYu7l
 5swEXWGa+EoVQdj0OMo26+q/KGbEPcFdRhGrIAFWS4kQu7mQsddPPOFmzM6kKnMA0MIm
 uLSUHtbYgkNriVRF+2Jm6GB/2VuBv/Exj+mJPwV8E6tnajffwR4LGzpXGyfOFr5LrMbs
 CDGv8mmoGxDp9Ja7Mk9FXBdp/9GkXlvSUFNcj8PmFvTC1VEOOsRbBqs339KrKcVsN/Kf
 wXTCIwU5VPnqvDIoCHy451Txnks1TC1eEjSuAnjgESsSbrA0QOrWQBxlkF/a22JPgqZT ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vve3q54x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 23:34:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9SNYd5p157823;
        Mon, 28 Oct 2019 23:34:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vvyn0kdtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 23:34:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9SNYnmG001116;
        Mon, 28 Oct 2019 23:34:49 GMT
Received: from localhost (/10.159.156.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Oct 2019 16:34:49 -0700
Date:   Mon, 28 Oct 2019 16:34:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: About xfstests generic/361
Message-ID: <20191028233448.GB15221@magnolia>
References: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d94634d5c990dc0d21673ff2596bd276b728ab1.camel@themaw.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=856
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910280222
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9424 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910280222
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 05:17:05PM +0800, Ian Kent wrote:
> Hi Darrick,
> 
> Unfortunately I'm having a bit of trouble with my USB keyboard
> and random key repeats, I lost several important messages this
> morning due to it.
> 
> Your report of the xfstests generic/361 problem was one of them
> (as was Christoph's mail about the mount code location, I'll post
> on that a bit later). So I'm going to have to refer to the posts
> and hope that I can supply enough context to avoid confusion.
> 
> Sorry about this.
> 
> Anyway, you posted:
> 
> "Dunno what's up with this particular patch, but I see regressions on
> generic/361 (and similar asserts on a few others).  The patches leading
> up to this patch do not generate this error."
> 
> I've reverted back to a point more or less before moving the mount
> and super block handling code around and tried to reproduce the problem
> on my test VM and I din't see the problem.
> 
> Is there anything I need to do when running the test, other have
> SCRATCH_MNT and SCRATCH_DEV defined in the local config, and the
> mount point, and the device existing?

Um... here's the kernel branch that I used:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=mount-api-crash

Along with:

MKFS_OPTIONS -- -m crc=0
MOUNT_OPTIONS -- -o usrquota,grpquota

and both TEST_DEV and SCRATCH_DEV pointed at boring scsi disks.

> This could have been a problem with the series I posted because
> I did have some difficulty resolving some conflicts along the
> way and may have made mistakes, hence reverting to earlier patches
> (but also keeping the recent small pre-patch changes).

Yeah, I had the same problem too; you might spot check the commits in
there just in case /I/ screwed them up.

(I would say 'or rebase on for-next' but (a) I don't know how
Christoph's mount cleanups intermix with that and (b) let's see if
this afternoon's for-next is less broken on s390 than this morning's was
<frown>)

--D

> Ian
> 
