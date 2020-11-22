Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A684AC5519F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 19:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638D420776
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 19:37:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="POy90TNp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgKVThS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 14:37:18 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42672 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgKVThR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 14:37:17 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMJYiaZ146793
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 19:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GqoUo9jeou+UviwzTtiuNCrxgsm6R5NHnnjWA4y4jEU=;
 b=POy90TNp/0lq1vSDogcjyUU55HXxRMfRdfzH3yE03AgtmPC9if99L8uxrVsvodHYDHQ9
 VG2ahUuvAoU+/NSzjoadkN/+Ar4OqIB3n4MfuoQcYnY4mYyQ+U7aFXgyXux7YUFY1Ul2
 NTqwbvIZ3Z4VMZLnv1SGa4dDCs9dLDecANE0wFqsT+AlzBULfdly4f54Bp0SNY5KFs9C
 FiMQu9O1SY4KJwpyFKnahqZL34C1iARMAwKAX1o6UVN2YIT4AKal86iHy5YFsxLDjrOd
 enrtnl41tTtcIBLpGN1U7YB5rG9qyQidmmMrDP8mb6Wqkoyz/Px/2wWJT50bQTmIB/Eo bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34xrdajw34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 19:37:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMJZj8b114251
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 19:37:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ycnpu7bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 19:37:15 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AMJbEKK022870
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 19:37:14 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Nov 2020 11:37:14 -0800
Date:   Sun, 22 Nov 2020 11:37:11 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: XFS: corruption detected in 5.9.10, upgrading from 5.9.6:
 (partial) panic log
Message-ID: <20201122193711.GA7880@magnolia>
References: <87lfetme3f.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfetme3f.fsf@esperi.org.uk>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=881 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011220143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=894 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011220143
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 22, 2020 at 06:38:28PM +0000, Nick Alcock wrote:
> So I just tried to reboot my x86 server box from 5.9.6 to 5.9.10 and my

Sorry about that, there was a bad patch in -rc4 that got sucked into
5.9.9 because it had a fixes tag.  The revert is already upstream:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?id=eb8409071a1d47e3593cfe077107ac46853182ab

--D

> system oopsed with an xfs fs corruption message when I kicked up
> Chromium on another machine which mounted $HOME from the server box (it
> panicked without logging anything, because the corruption was detected
> on the rootfs, and it is also the loghost). A subsequent reboot died
> instantly as soon as it tried to mount root, but the next one got all
> the way to starting Chromium before dying again the same way.
> 
> Rebooting back into 5.9.6 causes everything to work fine again, no
> reports of corruption and starting Chromium works.
> 
> This fs has rmapbt and reflinks enabled, on a filesystem originally
> created by xfsprogs 4.10.0, but I have never knowingly used them under
> the Chromium config dirs (or, actually, under that user's $HOME at all).
> I've used them extensively elsewhere on the fs though. The FS is sitting
> above a libata -> md-raid6 -> bcache stack. (It is barely possible that
> bcache is at fault, but bcache has seen no changes since 5.9.6 so I
> doubt it.)
> 
> The relevant bits of the log I could capture -- no console scrollback
> these days, of course :( and it was a panic anyway so the top is just
> lost -- is in a photo here:
> 
>   <http://www.esperi.org.uk/~nix/temporary/xfs-crash.jpg>
> 
> The mkfs line used to create this fs was:
> 
> mkfs.xfs -m rmapbt=1,reflink=1 -d agcount=17,sunit=$((128*8)),swidth=$((384*8)) -l logdev=/dev/sde3,size=521728b -i sparse=1,maxpct=25 /dev/main/root
> 
> (/dev/sde3 is an SSD which also hosts the bcache and RAID journal,
> though this RAID device is not journalled, and is operating fine.)
> 
> I am not using a realtime device.
> 
> I have *not* yet run xfs_repair, but just rebooted back into the old
> kernel, since everything worked there: I'll run xfs_repair over the fs
> if you think it wise to do so, but right now I have a state which
> crashes on one kernel and works on another one, which seems useful to
> not try to fix in case you have some use for it.
> 
> Since everything is working fine in 5.9.6 and there were XFS changes
> after that, I'm hypothesising that this is probably a bug in the
> post-5.9.6 changes rather than anything xfs_repair should be trying to
> fix. But I really don't know :)
> 
> (I can't help but notice that all these post-5.9.6 XFS changes were
> sucked in by Sasha's magic regression-hunting stable-tree AI, which I
> thought wasn't meant to happen -- but I've not been watching closely,
> and if you changed your minds after the LWN article went in I won't have
> seen it.)
