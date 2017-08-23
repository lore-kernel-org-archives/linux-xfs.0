Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4549 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753691AbdHWKaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 06:30:06 -0400
Subject: Re: [PATCH RFC 0/3] xfs: add customizable default values for error
 configuration
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
 <20170821225003.GR10621@dastard> <20170822165918.GW4796@magnolia>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <6c090c0b-664d-e567-7409-dafce3a5a25d@huawei.com>
Date: Wed, 23 Aug 2017 18:29:26 +0800
MIME-Version: 1.0
In-Reply-To: <20170822165918.GW4796@magnolia>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com

Hi Darrick,

On 2017/8/23 0:59, Darrick J. Wong wrote:
> On Tue, Aug 22, 2017 at 08:50:03AM +1000, Dave Chinner wrote:
>> On Mon, Aug 21, 2017 at 07:54:19PM +0800, Hou Tao wrote:
>>> Hi all,
>>>
>>> XFS has the configurable error handlers for each mounted device, but
>>> the default values of these configuration are static. It will be useful
>>> to make the default values customizable when there are many XFS filesystems
>>> and we need to shutdown the filesystem after getting any error.
>>
>> Nice! I can see the usefulness of this functionality - it's a piece
>> of the puzzle we are missing. I've had a quick look over the code,
>> and have a few high level questions that I can't answer from looking
>> at the code.
>>
>> Was there any reason you decided to put the default policy
>> management into the kernel rather than try to provide a mechanism to
>> allow userspace to manage it (e.g. via a udev event at mount time)?
>> We've still got to manage per filesystem specific settings from
>> userspace (e.g.  root volume might be different to data volumes), so
>> I'm interested to know if you have any ideas on how we can handle
>> that side of the problem, too?
>>
>>> The patches are simple. A sysfs tree is created under .../xfs/default_error
>>> and its hierarchies are the same with the tree under .../fs/xfs/<dev>/error.
>>>
>>> When the default value of any error configuration is being modified, the
>>> corresponding value of all mount points will be checked again the old
>>> default value. If they are the same, the value of the mount point will
>>> be updated to the new default value as well, else the value of the mount
>>> point will NOT be changed.
>>
>> Assuming we are going to put default policy into the kernel, this
>> notifier structure seems overly complex when compared to a single
>> structure that holds the default values and looking it up when a
>> specific mount error config holds a flag that says "use the
>> default".
>>
>> The "check the default flag and grab values" code could all be
>> hidden inside xfs_error_get_cfg() so propagation happens on demand.
>> This means all the mounts pick up changes to the default config
>> without needing to be chained to a notifier.
> 
> Agreed.
> 
>> The "use defaults" flag could be cleared when a new value is set for
>> that error config, and potentionally we could reset it in the store
>> method if it matches the current default value.
> 
> I prefer letting userspace explicitly declare that it wants the default
> value via:
> 
> echo default > /sys/fs/xfs/sda/error/metadata/EFUBAR/something
> Say the the default of some attribute is currently 7 and the admin
> deploys a script to set sda's value to 6 because they tested it and 6
> was the value for them for sda.  Later they upgrade to a kernel where
> the default is 6 -- they still want specifically 6, not "whatever the
> default is".
> (FWIW the sysfs errortag interface lets you set an explicit numeric
> value for injection frequency or 'default' to take whatever we baked
> into the code.)
The explicit request of default value is a good idea, so even when the default
value and the specific value is the same and the default value is updated, there
is no need to update the specific value because it is NOT default.


> --D
> 
>>
>> I might be missing something here (I frequently do, so please tell
>> me if I have!), but my initial thoughts are that we can do this in a
>> much simpler manner. What do you think, Tao?
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

