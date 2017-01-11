Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33566 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754374AbdAKFI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 00:08:58 -0500
Received: by mail-oi0-f67.google.com with SMTP id j15so20220906oih.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 21:08:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170110231550.GO14038@birch.djwong.org>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
 <1484062757-12433-6-git-send-email-amir73il@gmail.com> <20170110231550.GO14038@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Jan 2017 07:08:57 +0200
Message-ID: <CAOQ4uxjcasRkSK0f5OpY5Qtc0iB6uxP5e=XWytSyQM5ni6m2Ow@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] xfs: sanity check inode mode when creating new dentry
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 1:15 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Tue, Jan 10, 2017 at 05:39:16PM +0200, Amir Goldstein wrote:
>> The helper xfs_dentry_to_name() is used by 2 different
>> classes of callers: Callers that pass zero mode and don't care
>> about the returned name.type field and Callers that pass
>> non zero mode and do care about the name.type field.
>>
>> Change xfs_dentry_to_name() to not take the mode argument and
>> change the call sites of the first class to not pass the mode
>> argument.
>>
>> Create a new helper xfs_dentry_mode_to_name() which does pass
>> the mode argument and returns -EFSCORRUPTED if mode is invalid.
>> Callers that translate non zero mode to on-disk file type now
>> check the return value and will export the error to user instead
>> of staging an invalid file type to be written to directory entry.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
...
>>
>>       mode = S_IFLNK |
>>               (irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
>> -     xfs_dentry_to_name(&name, dentry, mode);
>> +     error = xfs_dentry_mode_to_name(&name, dentry, mode);
>> +     ASSERT(error == 0);
>
> Why not the usual 'if (error) goto out;' here?
>

Because mode here is not coming from disk, nor from user input,
so an error from converting S_IFLNK would be a programming bug.
We could also ignore the return value in this case, let me know if you
prefer that.

BTW, process question. Do you need me to re-send patched with
your Reviewed-by, or will you add those when applying?

Thanks,
Amir.
