Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:51391 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdJTDWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 23:22:10 -0400
Received: by mail-yw0-f170.google.com with SMTP id k3so5319962ywk.8
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2017 20:22:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com> <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Oct 2017 06:22:09 +0300
Message-ID: <CAOQ4uxjCTs0vFcQ3OLrMmReAGBCcqQDN8byPom__oPEuW3c6Lg@mail.gmail.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 19, 2017 at 7:11 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
>> Hi all,
>>
>> This is the third version of parent pointer attributes for xfs.
>> I've integrated the suggestions made since v2, mostly moving the
>> attr buffers in the xfs_attr_log_item to pointers that point to
>> xfs_attr_item. I've also implementing the recovery routines for
>> the xfs_attr_log_format.  If I missed anything please point it
>> out.  As always, comments and feedback are appreciated.  Thank
>> you!
>>
>
> A minor comment about the cover letter.
> All designated reviewers must know exactly what "parent pointers" are for,
> but it could be useful to add some context in the cover letter about the purpose
> of this work for the sake of other readers on the list. Useful to refer to the
> upcoming scrub support patches.
>
> BTW, not sure if this was mentioned in the previous lifetime of those
> patches, but parent pointers can be used to implement exportfs operation
> xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
> and to implement xfs_fs_get_name(), which would make reconnect_path()
> *much* more efficient.
>
> Also, you may want to use git format-patch -v3 for V3
> makes it easier to browse old versions of patches on the list.
>
> Cheers,
> Amir.
>
>> Allison Henderson (7):
>>   Add helper functions xfs_attr_set_args and xfs_attr_remove_args
>>   Set up infastructure for deferred attribute operations
>>   Add xfs_attr_set_defered and xfs_attr_remove_defered
>>   Remove all strlen calls in all xfs_attr_* functions for attr names.
>>   Add the extra space requirements for parent pointer attributes when
>>     calculating the minimum log size during mkfs
>>   Add parent pointers to rename
>>   Add the parent pointer support to the superblock version 5.
>>
>> Brian Foster (1):
>>   xfs_bmap_add_attrfork(): re-add error handling from set_attrforkoff()
>>     call
>>
>> Dave Chinner (5):
>>   xfs: define parent pointer xattr format
>>   :xfs: extent transaction reservations for parent attributes

You must've already noticed - just pointing out the :xfs: typo in that commit
subject (easier to comment on that here then on patch itself)

Amir.
