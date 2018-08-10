Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbeHJV6A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Aug 2018 17:58:00 -0400
Subject: Re: [PATCH v2 2/2] [PATCH] xfs: Close race between direct IO and
 xfs_break_layouts()
References: <153374942137.42241.10539674028265137668.stgit@djiang5-desk3.ch.intel.com>
 <be8603ab-ccb2-3f0d-4dbf-7935fc3ed357@redhat.com>
 <c4580e0d-e403-88a4-0e3a-7be8d0489f09@intel.com>
 <CAOxpaSWwfd4Wat3v_iH1QymGh51QdcK1=7fsOUeXrdfqui4K=g@mail.gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <7930740d-7097-90b7-a4c2-f81d520f411f@redhat.com>
Date: Fri, 10 Aug 2018 14:26:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAOxpaSWwfd4Wat3v_iH1QymGh51QdcK1=7fsOUeXrdfqui4K=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <zwisler@gmail.com>, dave.jiang@intel.com
Cc: Theodore Ts'o <tytso@mit.edu>, darrick.wong@oracle.com, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 8/10/18 2:24 PM, Ross Zwisler wrote:
> On Fri, Aug 10, 2018 at 9:23 AM Dave Jiang <dave.jiang@intel.com> wrote:
>> On 08/10/2018 11:31 AM, Eric Sandeen wrote:
>>> On 8/8/18 12:31 PM, Dave Jiang wrote:
>>>> This patch is the duplicate of ross's fix for ext4 for xfs.
>>>>
>>>> If the refcount of a page is lowered between the time that it is returned
>>>> by dax_busy_page() and when the refcount is again checked in
>>>> xfs_break_layouts() => ___wait_var_event(), the waiting function
>>>> xfs_wait_dax_page() will never be called.  This means that
>>>> xfs_break_layouts() will still have 'retry' set to false, so we'll stop
>>>> looping and never check the refcount of other pages in this inode.
>>>>
>>>> Instead, always continue looping as long as dax_layout_busy_page() gives us
>>>> a page which it found with an elevated refcount.
>>>
>>> Hi Dave, does this have a testcase?  Have you seen the issue using Ross's
>>> xfstest generic/503 or is there some other test?  Apologies if I missed
>>> prior discussion on a testcase or race frequency...
>>
>> I do not have a testcase. I know Ross replicated it on ext4. And Jan
>> asked to create the same fix with XFS when he reviewed Ross's fix for ext4.
> 
> In my testing I couldn't get this race to hit with XFS.  I couldn't
> even get a failure with generic/503 when testing XFS before Dan's
> initial patches went in which added xfs_break_layouts() et al.  I
> think that Dan had to manually insert timing delays to get the warning
> to hit for XFS when testing his patches.
> 
> The race we're fixing happens consistently with ext4 and through code
> inspection we can see that the race exists in XFS.

Ok, thanks for the info Dave & Ross!

-Eric
