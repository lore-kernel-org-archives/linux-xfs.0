Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32869 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933209AbcIVRVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2016 13:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh-6q_t5umF=pN8YjJ+9Az9et2GL240KZMqCeYGvSmycg@mail.gmail.com>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-5-git-send-email-amir73il@gmail.com> <CAOQ4uxjhO0M4K4oNA0dGsN6-DHtJ7zFQVLe=T2qpuWb+eubaig@mail.gmail.com>
 <CAJfpeguhoMkkBWD7s6V-2jHaAvKrEn+sz8h0emcr7isR8yzKHg@mail.gmail.com> <CAOQ4uxh-6q_t5umF=pN8YjJ+9Az9et2GL240KZMqCeYGvSmycg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Sep 2016 20:21:32 +0300
Message-ID: <CAOQ4uxgFpmTjNtW7L=DBTdsUYJ2FV2z3X1LiSJGf4JH2mjT7bA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] ovl: use vfs_copy_file_range() to copy up file data
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Chinner <david@fromorbit.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Sep 22, 2016 at 6:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Thu, Sep 22, 2016 at 5:49 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Thu, Sep 22, 2016 at 10:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Guys, I just hit a lockdep warning on nesting an mnt_want_write() with
>>> this patch
>>> because overlay already holds the write lock when getting to ovl_copy_up_data()
>>> I don't know how I missed it before.
>>>
>>> Is it really a problem to nest this lock?
>>> Should I factor our another set of _locked helpers from the
>>> vfs_{copy,clone}_file_range helpers?
>>>
>>
>> vfs_{copy,clone}_file_range should call sb_start_write() instead of
>> mnt_want_write_file(), the checks against FMODE_WRITE + S_ISREG ensure
>> that the __mnt_want_write() part is already held on the file.
>
> Wait a minute, I think you got the solution but mixed it up a bit.
> IIUC, vfs_{clone,copy} should call __mnt_want_write_file()
> instead of mnt_want_write_file(), which will skip sb_start_write()
> because file is already open for write and no lockdep warning
> and no problem.
>
> Am I missing something?
>

Ah.. I got it. Anyway a short survey of fs/namei.c
shows that the custom is to have mnt_want_write() in either the syscall
or the do_XXX helper and not in the vfs_XXX helper,
so I will conform to this standard.

>>
>> That still leaves the lockdep warning.  We could do
>> __vfs_{copy,clone}_file_range() variants without the
>> sb_start_write()/sb_end_write() and add the non-underscore variants as
>> static inline to fs.h that do call the sb_start/end_write.
>>
>> Thanks,
>> Miklos
