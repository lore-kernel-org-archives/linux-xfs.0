Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sender-pp-092.zoho.com ([135.84.80.237]:25433 "EHLO
        sender-pp-092.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbdIDAAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 20:00:02 -0400
Subject: Re: error: "Your hard drive is failing" ???
References: <7f2b8d9d-3748-0ce1-7e88-76409e8717cb@zoho.com>
 <b699dac3-321a-9029-87cb-2b5ced17ddd1@sandeen.net>
 <4b74027e-34ee-d365-e454-d3a0f524c408@zoho.com>
 <b2a570b1-d062-b880-5371-33c454fac70f@telefonica.net>
From: ToddAndMargo <ToddAndMargo@zoho.com>
Message-ID: <11db60f4-746c-ea37-96e3-90c43ebc1b2c@zoho.com>
Date: Sun, 3 Sep 2017 16:59:55 -0700
MIME-Version: 1.0
In-Reply-To: <b2a570b1-d062-b880-5371-33c454fac70f@telefonica.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Carlos E. R." <robin.listas@telefonica.net>, Linux-XFS mailing list <linux-xfs@vger.kernel.org>

On 09/03/2017 05:32 AM, Carlos E. R. wrote:
> On 2017-09-03 05:18, ToddAndMargo wrote:
>> On 09/02/2017 08:08 PM, Eric Sandeen wrote:
>>> On 9/2/17 9:48 PM, ToddAndMargo wrote:
>>>> Dear Xfs,
>>>>
>>>> Scientific Linux 7.3
>>>>
>>>> $ rpm -qa \*xfsdump\*
>>>> xfsdump-3.1.4-1.el7.x86_64
>>>>
>>>> When I do a backup to /dev/sda1 (/lin-bak), I get told
>>>>
>>>>       WARNING: Your hard drive is failing
>>>>       Device: /dev/sda [SAT], unable to open device
>>>
>>> That's a message from smartctl, it has nothing to do with
>>> xfs or xfsdump.  It's probably related to your creative use
>>> of hotplug.
> 
>> Then I am just going to ignore it then.
> 
> smartctl daemon may not be aware that you swapped a disk and be
> confused. You may have to restart it.
> 

Hi Carlos,

I am not finding a smartctl daemon running.  Is it
known by another name?

# systemctl status smartctld
Unit smartctld.service could not be found.

# systemctl status smartctl
Unit smartctl.service could not be found.

# ps ax | grep -i [s]martctl
<nothing>

And can I just do a "systemctl restart xxx" on it?  Or will
it just confuse the issue.


-T

