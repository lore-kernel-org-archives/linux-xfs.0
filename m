Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58498 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751796AbdCNQyj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Mar 2017 12:54:39 -0400
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <5223151.9ZZzaImiEQ@libor-nb>
 <2c8d1ee3-c795-aefa-4797-8b7970ea8266@sandeen.net>
 <1702693.ETbqtf3ybS@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <503a4130-e6db-2d14-d377-01336022d6ee@sandeen.net>
Date: Tue, 14 Mar 2017 11:54:37 -0500
MIME-Version: 1.0
In-Reply-To: <1702693.ETbqtf3ybS@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 3/14/17 3:15 AM, Libor Klepáč wrote:
> Hello,
> i have this during night with error_level = 11, no force shutdown

Just to double check - are these all getting freshly created?  I.e.
you repair and fix the filesystem each time you see this, but they
keep re-appearing?

> (kernel 4.8.15)
> Mar 14 02:36:29 vps2 kernel: [54799.061956] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x24e70268

Unfortunately the read path is a bit less interesting.  We found something
on disk, but we're not sure how it got there.

If we could catch a write verifier failing that /might/ be a little more
useful.

I'm at a loss as to why you seem to be uniquely able to hit this problem.  :(

-Eric
