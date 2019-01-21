Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:31983 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729474AbfAUO7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jan 2019 09:59:44 -0500
Reply-To: d.aberger@profihost.ag
Subject: Re: XFS filesystem hang
References: <645a3d40-47a5-0f7a-7565-821bbce103f2@profihost.ag>
 <20190117123427.GA37591@bfoster>
 <8cf51b2c-6e9b-317a-16fc-9e47f916198e@profihost.ag>
 <20190117220512.GE6173@dastard>
 <030b0a00-0c0f-4ab3-373d-f9734e60472f@profihost.ag>
 <20190119001946.GI6173@dastard>
From: Daniel Aberger - Profihost AG <d.aberger@profihost.ag>
Message-ID: <45ec229d-3554-e273-3704-daee5e1bfe54@profihost.ag>
Date: Mon, 21 Jan 2019 15:59:40 +0100
MIME-Version: 1.0
In-Reply-To: <20190119001946.GI6173@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, s.priebe@profihost.ag, n.fahldieck@profihost.ag

Am 19.01.19 um 01:19 schrieb Dave Chinner:
> On Fri, Jan 18, 2019 at 03:48:46PM +0100, Daniel Aberger - Profihost AG wrote:
>> Am 17.01.19 um 23:05 schrieb Dave Chinner:
>>> On Thu, Jan 17, 2019 at 02:50:23PM +0100, Daniel Aberger - Profihost AG wrote:
>>>> * Kernel Version: Linux 4.12.0+139-ph #1 SMP Tue Jan 1 21:46:16 UTC 2019
>>>> x86_64 GNU/Linux
>>>
>>> Is that an unmodified distro kernel or one you've patched and built
>>> yourself?
>>
>> Unmodified regarding XFS and any subsystems related to XFS, as I was
>> being told.
> 
> That doesn't answer my question - has the kernel been patched (and
> what with) or is it a completely unmodified upstream kernel?
> 

The kernel we were running was OpenSUSE SLE15 based on commit
6c5c7489089608d89b7ce310bca44812e2b0a4a5.

https://github.com/openSUSE/kernel


>>>> * /proc/meminfo, /proc/mounts, /proc/partitions and xfs_info can be
>>>> found here: https://pastebin.com/cZiTrUDL
>>>
>>> Just  notes as I browse it.
>>> - lots of free memory.
>>> - xfs-info: 1.3TB, 32 ags, ~700MB log w/sunit =64fsbs
>>>   sunit=64 fsbs, swidth=192fsbs (RAID?)
>>> - mount options: noatime, sunit=512,sunit=1536, usrquota
>>> - /dev/sda3 mounted on /
>>> - /dev/sda3 also mounted on /home/tmp (bind mount of something?)
>>>
>>>> * full dmesg output of problem mentioned in the first mail:
>>>> https://pastebin.com/pLaz18L1
>>>
>>> No smoking gun.
>>>
>>>> * a couple of more dmesg outputs from the same system with similar
>>>> behaviour:
>>>>  * https://pastebin.com/hWDbwcCr
>>>>  * https://pastebin.com/HAqs4yQc
>>>
>>> Ok, so mysqld seems to be the problem child here.
>>>
>>
>> Our MySQL workload on this server is very small except for this time of
>> the day because our local backup to /backup happens during this time.
>> The highest IO happens during the night when our local backup is being
>> written. The timestamps of these two outputs suggest that the "mysql
>> dump" phase might just have been started. Unfortunately we only keep the
>> log of the last job, so I can't confirm that.
> 
> Ok, so you've just started loading up the btrfs volume that is also
> attached to the same raid controller, which does have raid caches
> enabled....
> 
> I wonder if that has anything to do with it?
> 

Do you suggest to change any caching options?

> Best would be to capture iostat output for both luns (as per the
> FAQ) when the problem workload starts.
> 

What I can give you so far is two I/O activity screenshots of Grafana of
two of the dmesg outputs above.

https://imgur.com/a/3lL776U


>>> Which leads me to ask: what is your RAID cache setup - write-thru,
>>> write-back, etc?
>>>
>>
>> Our RAID6 cache configuration:
>>
>>    Read-cache setting                       : Disabled
>>    Read-cache status                        : Off
>>    Write-cache setting                      : Disabled
>>    Write-cache status                       : Off
> 
> Ok, so read caching is turned off, which means it likely won't even
> be caching stripes between modifications. May not be very efficient,
> but hard to say if it's the problem or not.
> 
>> Full Configuration: https://pastebin.com/PdGatDY4
> 
> Yeah, caching is enabled on the backup btrfs lun, so there may be
> interaction issues. Is the backup device idle (or stalling) at the
> same time that the XFS messages are being issued?

In 2 out of 3 cases it happened while the backup job was running, which
starts at 0:10 am and finishes roughly between 2:30 and 3:30 am on this
particular machine. So it wasn't idle.

The MySQL dumping phase takes about 20 to 25 minutes and happens at the
end of the backup job.
