Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25307 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdHaScD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 14:32:03 -0400
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <e74da24b-b604-b9af-e6b7-6943543fa56a@sandeen.net>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <a1e12c3c-5238-e319-e2ea-982606e808b3@zoho.com>
Date: Thu, 31 Aug 2017 11:32:00 -0700
MIME-Version: 1.0
In-Reply-To: <e74da24b-b604-b9af-e6b7-6943543fa56a@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 08/31/2017 11:16 AM, Eric Sandeen wrote:
> xOn 8/31/17 1:04 PM, ToddAndMargo wrote:
>> Hi All,
>>
>> Fedora 26
>> BIOS boot = legacy (EUFI give me hives)
>>
>> I have a SATA backup drive formatted gpt, one partition, xfs. I went into gparted, erased the partition, recreated the partition as ext4 and formatted it as ext4.
>>
>> Then I mounted it as ext4, copied some files to it, unmounted it. When I went to remount it, mount told me there was something wrong with ext4.
> 
> What "something" was that?

mount: /lin-bak: wrong fs type, bad option, bad superblock on /dev/sdd1, 
missing codepage or helper program, or other error.


> 
>> So I mounted it as xfs AND IT WORKED! I repeated with the same result. The drive thinks it is ext4 until the second mount.
> 
> This should not be the case.  It's possible to leave old magic numbers & signatures lying around in general, but mkfs.ext4, in my testing, zeros out the XFS superblock at offset 0; xfs should fail to mount after that.  It sounds like there may be more going on, here.

I have notices issues in the past with gparted.  It use to not
format an ntfs partition that Windows recognized.  Now
it can't label and ntfs partition that Windows also recognized.
But these were usually relegated to Windows problems.
I would love it if gparted would FINALLY support luks.

>> Out of shear frustration, I did a dd /dev/zero overwrite of the stinker and left it running overnight.  That did the trick, but it takes
>> forever and I have four more drives to go.
>>
>> What is the official way to remove an xfs partition?
> 
> It's not usually needed, but if you don't want the kernel and/or utilities to recognize an xfs block device as xfs anymore, simply zero the first 512 bytes of that block device.

I can do that!

I was concerned about the gpt stuff at the end of the drive.
Ignored if I clobber the first 512 bytes?

> Or more conveniently, there's also the wipefs utility:
> 
> NAME
>         wipefs - wipe a signature from a device

Didn't know about that one.  Thank you!

-T

> -Eric
> 


