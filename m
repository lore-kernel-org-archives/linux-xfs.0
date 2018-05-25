Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33737 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967879AbeEYUQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 16:16:14 -0400
MIME-Version: 1.0
In-Reply-To: <d6a4b528-4336-48d4-1e0a-7b135c92f97e@redhat.com>
References: <20180525151421.2317292-1-arnd@arndb.de> <d6a4b528-4336-48d4-1e0a-7b135c92f97e@redhat.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 25 May 2018 22:16:12 +0200
Message-ID: <CAK8P3a1n3ME0f_mVTcph8aQ3x7rFriypd0kzxz9Up+sZJdLb=g@mail.gmail.com>
Subject: Re: [PATCH] xfs: mark sb_fname as nonstring
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Martin Sebor <msebor@gmail.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, May 25, 2018 at 6:53 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 5/25/18 10:14 AM, Arnd Bergmann wrote:
>>
>> gcc-8 reports two warnings for the newly added getlabel/setlabel code:
>
>
> Thanks for catching these.
>
> The patch summary confuses me, what does "mark sb_fname as nonstring"
> mean in the context of the actual patch?

My mistake. I tried a few different approaches and ended up using the
subject line from an earlier version with a later patch.

The 'nonstring' annotation is a variable attribute that gets gcc-8
to shut up about -Wstringop-truncation warnings, and is intended
to mark those character arrays that are not expected to be
null-terminated but still used with strncpy().

>>         spin_unlock(&mp->m_sb_lock);
>>         /* xfs on-disk label is 12 chars, be sure we send a null to user
>> */
>>         label[XFSLABEL_MAX] = '\0';
>> -       if (copy_to_user(user_label, label, sizeof(sbp->sb_fname)))
>> +       if (copy_to_user(user_label, label, sizeof(label)))
>
>
>
> ok.  (odd how this is ok for copy_to_user but not for strncpy above) :)

No idea. Maybe the gcc bug only happens with struct members but
not local variables?

>>                 return -EFAULT;
>>         return 0;
>>   }
>> @@ -1860,7 +1860,7 @@ xfs_ioc_setlabel(
>>         spin_lock(&mp->m_sb_lock);
>>         memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
>> -       strncpy(sbp->sb_fname, label, sizeof(sbp->sb_fname));
>> +       memcpy(sbp->sb_fname, label, len);
>
>
> Hm but len = strnlen(label, XFSLABEL_MAX + 1);
> which could be one longer than sbp->sb_fname, no?

We have an explicit check for that, so I think it's ok:

        if (len > sizeof(sbp->sb_fname))
                return -EINVAL;

       Arnd
