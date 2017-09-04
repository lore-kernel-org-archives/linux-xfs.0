Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25461 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbdIDAEC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 20:04:02 -0400
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
 <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <4741099f-1dcc-acff-46e1-61cd29ecf198@zoho.com>
Date: Sun, 3 Sep 2017 17:03:56 -0700
MIME-Version: 1.0
In-Reply-To: <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Carlos E. R." <robin.listas@telefonica.net>, Linux-XFS mailing list <linux-xfs@vger.kernel.org>

On 09/03/2017 05:34 AM, Carlos E. R. wrote:
> On 2017-09-02 02:34, ToddAndMargo wrote:
> 
>>
>> I don't know if you guys care about such things, but I just
>> request that gparted do a disk blank
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1487807
> 
> It is a known issue with gparted that when you reformat a partition or
> disk with something else, it doesn't properly erase at least the
> critical areas of the previous filesystem, causing problems.
> 
> One that has been noticed more than once at openSUSE is this:
> 
> - 'dd' a CD image on an USB stick for operating system installation. For
> instance, openSUSE-Leap-42.2-NET-x86_64.iso install disk.
> 
> - Afterwards, use gparted to remove partitions on the stick, create a
> new partition, format it as FAT32 (with a label).
> 
> Tumbleweed (at some version) thought the USB to still be a CD (printing
> its old label) and failed to mount it (because it is FAT).
> 
> The code detecting filesystem type had to be changed on Tumbleweed, but
> the cause of the issue is that gparted did not erase the areas at the
> start of the disk with that information, and the FAT format did not
> write on them.
> 
> 
> 
> So this is not a problem with XFS, but a problem caused by gparted
> (feature needed). You have to manually destroy key areas manually,
> probably just a few sectors at partition start.
> 
> 

Thank you!  And something for 1478707 to reproduce!

-- 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Computers are like air conditioners.
They malfunction when you open windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

