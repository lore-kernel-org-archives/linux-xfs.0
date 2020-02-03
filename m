Return-Path: <SRS0=dEjd=3X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBFEBC35247
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 21:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6E2920720
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Feb 2020 21:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgBCV4L convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 16:56:11 -0500
Received: from p3plmtsmtp02.prod.phx3.secureserver.net ([184.168.131.14]:57226
        "EHLO p3plmtsmtp02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726278AbgBCV4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Feb 2020 16:56:11 -0500
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2020 16:56:11 EST
Received: from n64.mail01.mtsvc.net ([216.70.64.196])
        by :MT-SMTP: with ESMTP
        id yjZuioYe2NR54yjZuinVo9; Mon, 03 Feb 2020 14:48:22 -0700
X-SID:  yjZuioYe2NR54
Received: from [162.248.116.186] (port=59566 helo=[192.168.101.29])
        by n64.mail01.mtsvc.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <alan@instinctualsoftware.com>)
        id 1iyjZt-0002B1-OH
        for linux-xfs@vger.kernel.org; Mon, 03 Feb 2020 16:48:21 -0500
From:   Alan Latteri <alan@instinctualsoftware.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: su & sw for HW-RAID60
Message-Id: <2CE21042-5F18-4642-BF48-AF8416FB9199@instinctualsoftware.com>
Date:   Mon, 3 Feb 2020 13:48:20 -0800
To:     linux-xfs@vger.kernel.org
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Authenticated-User: 1434467 alan@instinctualsoftware.com
X-MT-ID: 9DCC79A4E204102198399334CA945B5BD229B688
X-CMAE-Envelope: MS4wfJVciOEYXD2EtyqbEwahgCLvKdm7f3EJ/6timiIy0nwLunme9gdKUjbK4//lwWnp0kEUrRQCIneZnx8tR+sgKNhtsAC304J+LuXNZ1ll2pS6xyFIcEw5
 NMCrkIKJ0rnhWBCFs1RxM+/zzcjSbDXPYhWP0buDkAyN1nr22yAVTfPNcoP56LuktoqGWA7zesABSI+g+WCZp9qj/VtWO6kpctw=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

In an environment with an LSI 3108 based HW-RAID60, 256k stripe size on controller, 5 spans of (10data+2parity) disks.  What is the proper su & sw to use?  Do I do sw to the underlying 10 data disks per span? The top level 5 spans or all 50 data disks with the array?   Use case is as a file server for 20-60 MB per frame image sequences.

i.e

1) sw=256k,sw=10
2) sw=256k,sw=5
3) sw=256k,sw=50

RHEL 8.1


Thank you,
Alan

