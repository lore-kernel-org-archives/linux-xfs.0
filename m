Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:44944 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751642AbdCOKHn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 06:07:43 -0400
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Wed, 15 Mar 2017 11:07:39 +0100
Message-ID: <74482935.PWezjV9Qp4@libor-nb>
In-Reply-To: <503a4130-e6db-2d14-d377-01336022d6ee@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <1702693.ETbqtf3ybS@libor-nb> <503a4130-e6db-2d14-d377-01336022d6ee@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hello,

all VMs are running smoothly between these problems with XFS, no HW problems, no crashes, no force reboots.

On úterý 14. března 2017 11:54:37 CET Eric Sandeen wrote:
> On 3/14/17 3:15 AM, Libor Klepáč wrote:
> > Hello,
> > i have this during night with error_level = 11, no force shutdown
> 
> Just to double check - are these all getting freshly created?  I.e.
> you repair and fix the filesystem each time you see this, but they
> keep re-appearing?

I have looked to old emails and every xfs_repair fixes problem and next time different block/inode pops out.
I'm trying to lookup files using inode numbers from old emails.

If i remember correctly, files/dirs are usually created in some website cache directory. (ie. generated from template by php and saved to disk for later use).
So my lookup will probably come to nothing. Last reported force shutdown was on cache file.

> 
> > (kernel 4.8.15)
> > Mar 14 02:36:29 vps2 kernel: [54799.061956] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_read_verify+0x5a/0x100 [xfs], xfs_attr3_leaf block 0x24e70268
> 
> Unfortunately the read path is a bit less interesting.  We found something
> on disk, but we're not sure how it got there.
> If we could catch a write verifier failing that /might/ be a little more
> useful.

I'm prepared to run all affected hosts with error_level=11 , if it doesn't mean performance hit.

> 
> I'm at a loss as to why you seem to be uniquely able to hit this problem.  :(

And I was questioning my googling skills ;)

> 
> -Eric
> 

Libor

