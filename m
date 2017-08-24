Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4553 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdHXBnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 21:43:01 -0400
Subject: Re: [PATCH RFC 0/3] xfs: add customizable default values for error
 configuration
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
 <20170821225003.GR10621@dastard>
 <6b4f210c-4ea3-4a9d-b7ea-e60480be76e2@huawei.com>
 <20170824001637.GB21024@dastard> <20170824004609.GD4796@magnolia>
 <20170824010052.GD21024@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <e0cee76e-f356-2788-0e04-13edfe0300a2@huawei.com>
Date: Thu, 24 Aug 2017 09:42:27 +0800
MIME-Version: 1.0
In-Reply-To: <20170824010052.GD21024@dastard>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com

Hi Dave and Darrick,

On 2017/8/24 9:00, Dave Chinner wrote:
> On Wed, Aug 23, 2017 at 05:46:09PM -0700, Darrick J. Wong wrote:
>> On Thu, Aug 24, 2017 at 10:16:37AM +1000, Dave Chinner wrote:
>>> On Wed, Aug 23, 2017 at 05:26:36PM +0800, Hou Tao wrote:
>>>> Hi Dave,
>>>>
>>>> On 2017/8/22 6:50, Dave Chinner wrote:
>>>>> On Mon, Aug 21, 2017 at 07:54:19PM +0800, Hou Tao wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> XFS has the configurable error handlers for each mounted device, but
>>>>>> the default values of these configuration are static. It will be useful
>>>>>> to make the default values customizable when there are many XFS filesystems
>>>>>> and we need to shutdown the filesystem after getting any error.
>>>>>
>>>>> Nice! I can see the usefulness of this functionality - it's a piece
>>>>> of the puzzle we are missing. I've had a quick look over the code,
>>>>> and have a few high level questions that I can't answer from looking
>>>>> at the code.
>>>>> Was there any reason you decided to put the default policy
>>>>> management into the kernel rather than try to provide a mechanism to
>>>>> allow userspace to manage it (e.g. via a udev event at mount time)?
>>>> No special reason for the kernel-side default policy, just because I didn't
>>>> find an uevent for the mount event. If the uevent is available or added (?),
>>>> writing an udev rule to set the default error configuration seems simpler and
>>>> works for our scenario.
>>>
>>> I think we'd need to add one, but given we already have a kobj for
>>> the filesystem being mounted, it seems to me like we should be able
>>> to add a mount notification without too much trouble via
>>> kobject_uevent(KOBJ_ONLINE)
>>
>> <ENGAGE BIKESHED MODE>
>>
>> It might be useful to think more broadly about modifying XFS to send
>> uevents.  In addition to sending KOBJ_ONLINE to broadcast the mount to
>> error configuration tools, we could (in the future say) schedule online
>> fscks with a service manager.  Or we could send KOBJ_CHANGE notices when
>> we hit IO errors, or someone remounts the fs with different options?
>>
>> <END BIKESHED MODE>
> 
> Agreed, that's what I'd like to be able to do in the future. Let's
> make the small step first of being able to emit an online event,
> because that has no other information passed with it that can trap
> us into a corner in future. Other events and custom events are
> outside the scope of error config injection at mount time....
So do we plan to add a mount and umount uevent only, or to add both
the uevent and a "default" value for the error configuration ? The former will be
enough for our scenario, thought it introduces a dependency on the udevd program.


