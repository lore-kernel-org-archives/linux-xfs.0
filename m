Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45094 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdHaSQR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 14:16:17 -0400
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e74da24b-b604-b9af-e6b7-6943543fa56a@sandeen.net>
Date: Thu, 31 Aug 2017 13:16:16 -0500
MIME-Version: 1.0
In-Reply-To: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ToddAndMargo <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org

xOn 8/31/17 1:04 PM, ToddAndMargo wrote:
> Hi All,
> 
> Fedora 26
> BIOS boot = legacy (EUFI give me hives)
> 
> I have a SATA backup drive formatted gpt, one partition, xfs. I went into gparted, erased the partition, recreated the partition as ext4 and formatted it as ext4.
> 
> Then I mounted it as ext4, copied some files to it, unmounted it. When I went to remount it, mount told me there was something wrong with ext4.

What "something" was that?

> So I mounted it as xfs AND IT WORKED! I repeated with the same result. The drive thinks it is ext4 until the second mount.

This should not be the case.  It's possible to leave old magic numbers & signatures lying around in general, but mkfs.ext4, in my testing, zeros out the XFS superblock at offset 0; xfs should fail to mount after that.  It sounds like there may be more going on, here.

> Out of shear frustration, I did a dd /dev/zero overwrite of the stinker and left it running overnight.  That did the trick, but it takes
> forever and I have four more drives to go.
> 
> What is the official way to remove an xfs partition?

It's not usually needed, but if you don't want the kernel and/or utilities to recognize an xfs block device as xfs anymore, simply zero the first 512 bytes of that block device.

Or more conveniently, there's also the wipefs utility:

NAME
       wipefs - wipe a signature from a device

-Eric
