Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4545 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753445AbdHWJ1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2017 05:27:23 -0400
Subject: Re: [PATCH RFC 0/3] xfs: add customizable default values for error
 configuration
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
 <20170821225003.GR10621@dastard>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <6b4f210c-4ea3-4a9d-b7ea-e60480be76e2@huawei.com>
Date: Wed, 23 Aug 2017 17:26:36 +0800
MIME-Version: 1.0
In-Reply-To: <20170821225003.GR10621@dastard>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

Hi Dave,

On 2017/8/22 6:50, Dave Chinner wrote:
> On Mon, Aug 21, 2017 at 07:54:19PM +0800, Hou Tao wrote:
>> Hi all,
>>
>> XFS has the configurable error handlers for each mounted device, but
>> the default values of these configuration are static. It will be useful
>> to make the default values customizable when there are many XFS filesystems
>> and we need to shutdown the filesystem after getting any error.
> 
> Nice! I can see the usefulness of this functionality - it's a piece
> of the puzzle we are missing. I've had a quick look over the code,
> and have a few high level questions that I can't answer from looking
> at the code.
> Was there any reason you decided to put the default policy
> management into the kernel rather than try to provide a mechanism to
> allow userspace to manage it (e.g. via a udev event at mount time)?
No special reason for the kernel-side default policy, just because I didn't
find an uevent for the mount event. If the uevent is available or added (?),
writing an udev rule to set the default error configuration seems simpler and
works for our scenario.

> We've still got to manage per filesystem specific settings from
> userspace (e.g.  root volume might be different to data volumes), so
> I'm interested to know if you have any ideas on how we can handle
> that side of the problem, too?
Do you mean providing extra tools or files to let userspace to manage
fs specific error settings or something else ? For us, the current sysfs
files of error configuration are enough and there is no need for anything more.

>> The patches are simple. A sysfs tree is created under .../xfs/default_error
>> and its hierarchies are the same with the tree under .../fs/xfs/<dev>/error.
>>
>> When the default value of any error configuration is being modified, the
>> corresponding value of all mount points will be checked again the old
>> default value. If they are the same, the value of the mount point will
>> be updated to the new default value as well, else the value of the mount
>> point will NOT be changed.
> 
> Assuming we are going to put default policy into the kernel, this
> notifier structure seems overly complex when compared to a single
> structure that holds the default values and looking it up when a
> specific mount error config holds a flag that says "use the
> default".
> The "check the default flag and grab values" code could all be
> hidden inside xfs_error_get_cfg() so propagation happens on demand.
> This means all the mounts pick up changes to the default config
> without needing to be chained to a notifier.
> 
> The "use defaults" flag could be cleared when a new value is set for
> that error config, and potentionally we could reset it in the store
> method if it matches the current default value.
> 
> I might be missing something here (I frequently do, so please tell
> me if I have!), but my initial thoughts are that we can do this in a
> much simpler manner. What do you think, Tao?
Yes, I agree that the notifier method is over-weighted, and the proposed method
is much better. However it has no way to reset the "use default flag" of a specific
configuration when the modified default value is modified again to a new value when
the old default value is equal with the current specific value. Maybe the reset is
unnecessary ?

Regards,

Tao

