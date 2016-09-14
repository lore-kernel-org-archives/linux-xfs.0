Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33313 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755879AbcINMnZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 08:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgbtGV-qJz=+wZL5w533Cb+kPDGJOUd9GVni_oxS0_Cvg@mail.gmail.com>
References: <1473348594-31425-1-git-send-email-amir73il@gmail.com>
 <1473692803-11964-1-git-send-email-amir73il@gmail.com> <1473692803-11964-5-git-send-email-amir73il@gmail.com>
 <20160913001147.GO22388@dastard> <CAOQ4uxgbtGV-qJz=+wZL5w533Cb+kPDGJOUd9GVni_oxS0_Cvg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Sep 2016 15:43:22 +0300
Message-ID: <CAOQ4uxjStCO=dGMtypc6rT2PTgsmBstH5RfeCLiZ+Z88rnrRsg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ovl: use vfs_copy_file_range() to copy up file data
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Sep 13, 2016 at 10:26 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Sep 13, 2016 at 3:11 AM, Dave Chinner <david@fromorbit.com> wrote:
>> On Mon, Sep 12, 2016 at 06:06:43PM +0300, Amir Goldstein wrote:
>>> Use vfs_copy_file_range() helper instead of calling do_splice_direct()
>>> when copying up file data.
>>> When copying up within the same fs, which supports copy_file_range(),
>>> fs implementation can be more efficient then do_splice_direct().
>>> vfs_copy_file_range() helper falls back to do_splice_direct() if
>>> it cannot use the file system's copy_file_range() implementation.
>>>
>>> Tested correct behavior when lower and upper are on:
>>> 1. same ext4 (copy)
>>> 2. same xfs + reflink patches + mkfs.xfs (copy)
>>> 3. same xfs + reflink patches + mkfs.xfs -m reflink=1 (clone)
>>> 4. different xfs + reflink patches + mkfs.xfs -m reflink=1 (copy)
>>>
>>> For comparison, on my laptop, xfstest overlay/001 (copy up of large
>>> sparse files) takes less than 1 second in the xfs reflink setup vs.
>>> 25 seconds on the rest of the setups.
>>
>> This is now stale, right? the reflink is done from the
>> vfs_clone_file_range() call added in an earlier patch, not this
>> change....
>
> Well.. that depends on the definition of "now"
> as patch 4/4 you are correct, but as I wrote in the cover letter
> I tested patches 3,4 independently of patches 1,2
> otherwise, patches 3,4 would be adding moot code
> or rather a simple re-factoring.
>
> So now it boils down to a process question:
> should patches 3,4 be merged, even though no one can properly test the
> 'fallback to chunk copy range' case
> with any of the in-tree filesystems (without modifying them first)?
>
> I could be presenting patch 4 as a simple re-factoring
> (use vfs copy range helper instead of using do_splice_direct)
> which makes for a cleaner code.
> But the fact that it changes behavior in a subtle way
> (hopefully for the best) without anyone noticing this change far into
> the future is somewhat troubling.
>
> Your thoughts?
>

Anyway, I added a comment in commit message about how I tested this change
(by removing the vfs_clone_file_range() call). resending...

>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
>>>  fs/overlayfs/copy_up.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>>> index e432d7e..32ea54f 100644
>>> --- a/fs/overlayfs/copy_up.c
>>> +++ b/fs/overlayfs/copy_up.c
>>> @@ -159,15 +159,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>>>                       break;
>>>               }
>>>
>>> -             bytes = do_splice_direct(old_file, &old_pos,
>>> -                                      new_file, &new_pos,
>>> -                                      this_len, SPLICE_F_MOVE);
>>> +             bytes = vfs_copy_file_range(old_file, old_pos,
>>> +                                         new_file, new_pos,
>>> +                                         this_len, 0);
>>>               if (bytes <= 0) {
>>>                       error = bytes;
>>>                       break;
>>>               }
>>> -             WARN_ON(old_pos != new_pos);
>>>
>>> +             old_pos += bytes;
>>> +             new_pos += bytes;
>>>               len -= bytes;
>>>       }
>>
>> Patch does not remove the
>>
>>         /* FIXME: copy up sparse files efficiently */
>>
>> comment. Efficient copying of sparse files is something
>> vfs_copy_file_range() should do internally....
>
> Moved the comment into vfs_copy_file_range()
>
> Cheers,
> Amir.
