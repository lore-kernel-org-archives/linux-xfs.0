Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE10C5519F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 18:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937C320760
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 18:38:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PNDcoBU+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgKVSid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 13:38:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgKVSic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 13:38:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMIYcv2041882
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 18:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=Mjehx8fqLqJPxlPIEhv2ZVIBhvmnkqIrrKmOcrVxQgI=;
 b=PNDcoBU+ifB401ztcomKwXC0ut/n5Nzf1CWyiOwiBfZAi5kbZBLO2RVlgqgT5Ms/CV0k
 u3z6WuJB7P98X7K++tsqmvx54xgCOUlzskZlNoWY7rT4lQjLOpyK86aELgQDc2io+v4a
 yufXmSVJpmaVysCXdO0gpLG+jyRN6ZM5EL0hwtuVU/gi6cVQJlTB9LhrZubqkAUtE8QL
 cyhoyHrJeD3wYtARaC6m6fUb/G3cbd+14OSIuqHLKn7iLUBd8UDYRRrDkfRuMKV/2lQw
 0FrGXl9z5bqBlAVBsbJX+RtDesrrZiwFrvWWb/ucYWHcNAV85dRnUM2exLoRPnGOKdZT lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34xtuktnpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 18:38:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AMIZY2q066158
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 18:38:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34ycsvqabw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 18:38:31 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AMIcV94016355
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 18:38:31 GMT
Received: from loom (/81.187.191.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Nov 2020 10:38:30 -0800
From:   Nick Alcock <nick.alcock@oracle.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: XFS: corruption detected in 5.9.10, upgrading from 5.9.6: (partial) panic log
Emacs:  it's like swatting a fly with a supernova.
Date:   Sun, 22 Nov 2020 18:38:28 +0000
Message-ID: <87lfetme3f.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=777 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011220135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9813 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=786 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1011 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011220135
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

So I just tried to reboot my x86 server box from 5.9.6 to 5.9.10 and my
system oopsed with an xfs fs corruption message when I kicked up
Chromium on another machine which mounted $HOME from the server box (it
panicked without logging anything, because the corruption was detected
on the rootfs, and it is also the loghost). A subsequent reboot died
instantly as soon as it tried to mount root, but the next one got all
the way to starting Chromium before dying again the same way.

Rebooting back into 5.9.6 causes everything to work fine again, no
reports of corruption and starting Chromium works.

This fs has rmapbt and reflinks enabled, on a filesystem originally
created by xfsprogs 4.10.0, but I have never knowingly used them under
the Chromium config dirs (or, actually, under that user's $HOME at all).
I've used them extensively elsewhere on the fs though. The FS is sitting
above a libata -> md-raid6 -> bcache stack. (It is barely possible that
bcache is at fault, but bcache has seen no changes since 5.9.6 so I
doubt it.)

The relevant bits of the log I could capture -- no console scrollback
these days, of course :( and it was a panic anyway so the top is just
lost -- is in a photo here:

  <http://www.esperi.org.uk/~nix/temporary/xfs-crash.jpg>

The mkfs line used to create this fs was:

mkfs.xfs -m rmapbt=1,reflink=1 -d agcount=17,sunit=$((128*8)),swidth=$((384*8)) -l logdev=/dev/sde3,size=521728b -i sparse=1,maxpct=25 /dev/main/root

(/dev/sde3 is an SSD which also hosts the bcache and RAID journal,
though this RAID device is not journalled, and is operating fine.)

I am not using a realtime device.

I have *not* yet run xfs_repair, but just rebooted back into the old
kernel, since everything worked there: I'll run xfs_repair over the fs
if you think it wise to do so, but right now I have a state which
crashes on one kernel and works on another one, which seems useful to
not try to fix in case you have some use for it.

Since everything is working fine in 5.9.6 and there were XFS changes
after that, I'm hypothesising that this is probably a bug in the
post-5.9.6 changes rather than anything xfs_repair should be trying to
fix. But I really don't know :)

(I can't help but notice that all these post-5.9.6 XFS changes were
sucked in by Sasha's magic regression-hunting stable-tree AI, which I
thought wasn't meant to happen -- but I've not been watching closely,
and if you changed your minds after the LWN article went in I won't have
seen it.)
