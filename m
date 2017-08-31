Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59306 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbdHaVJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 17:09:06 -0400
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <e74da24b-b604-b9af-e6b7-6943543fa56a@sandeen.net>
 <a1e12c3c-5238-e319-e2ea-982606e808b3@zoho.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <61ba3b74-7525-39a1-f8ba-0c3ce6519b00@sandeen.net>
Date: Thu, 31 Aug 2017 16:09:05 -0500
MIME-Version: 1.0
In-Reply-To: <a1e12c3c-5238-e319-e2ea-982606e808b3@zoho.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: ToddAndMargo <ToddAndMargo@zoho.com>, linux-xfs@vger.kernel.org

On 8/31/17 1:32 PM, ToddAndMargo wrote:
> On 08/31/2017 11:16 AM, Eric Sandeen wrote:
>> xOn 8/31/17 1:04 PM, ToddAndMargo wrote:
>>> Hi All,
>>>
>>> Fedora 26
>>> BIOS boot = legacy (EUFI give me hives)
>>>
>>> I have a SATA backup drive formatted gpt, one partition, xfs. I went into gparted, erased the partition, recreated the partition as ext4 and formatted it as ext4.
>>>
>>> Then I mounted it as ext4, copied some files to it, unmounted it. When I went to remount it, mount told me there was something wrong with ext4.
>>
>> What "something" was that?
> 
> mount: /lin-bak: wrong fs type, bad option, bad superblock on /dev/sdd1, missing codepage or helper program, or other error.

       In some cases useful info is found in syslog - try
       dmesg | tail  or so
       ^^^^^^^^^^^^
 
<snip>

>>> What is the official way to remove an xfs partition?
>>
>> It's not usually needed, but if you don't want the kernel and/or utilities to recognize an xfs block device as xfs anymore, simply zero the first 512 bytes of that block device.
> 
> I can do that!
> 
> I was concerned about the gpt stuff at the end of the drive.
> Ignored if I clobber the first 512 bytes?

The filesystem signature on a partition is a separate issue from
the partition table signatures on the disk...

-Eric
