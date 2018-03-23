Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:55170 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751409AbeCWOOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 10:14:44 -0400
Received: by mail-wm0-f43.google.com with SMTP id h76so3842737wme.4
        for <linux-xfs@vger.kernel.org>; Fri, 23 Mar 2018 07:14:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <709ab06b-4efc-2925-6621-f17ed4c048c6@sandeen.net>
References: <20180315182850.36783-1-jtulak@redhat.com> <20180316170720.44227-1-jtulak@redhat.com>
 <709ab06b-4efc-2925-6621-f17ed4c048c6@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 23 Mar 2018 15:14:22 +0100
Message-ID: <CACj3i72900vOY52-6sH+abpKcT5Sp0VSygdG1yVNW4fKUof8FQ@mail.gmail.com>
Subject: Re: [PATCH 2/2 v5] fsck.xfs: allow forced repairs using xfs_repair
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Mar 23, 2018 at 3:37 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> +function ensure_not_mounted() {
>> +     local dev=$1
>> +     mounted=`grep -c "^$dev " /proc/mounts`
>> +     if [ $mounted -ne 0 ]; then
>> +             echo "$NAME error: The filesystem to be checked must not be mounted." 1>&2
>> +             exit 4
>> +     fi
>> +}
>
> Is this necessary?  Doesn't xfs_repair already check this?
>
> # xfs_repair /dev/loop0
> xfs_repair: /dev/loop0 contains a mounted filesystem
> xfs_repair: /dev/loop0 contains a mounted and writable filesystem
>
> fatal error -- couldn't initialize XFS library
>
> # echo $?
> 1
>
> (script would then say "error: xfs_repair could not fix the filesystem."
> and exit with 4.)
>
> It might be nice to have the cleaner message above, but I wonder about
> the wisdom and safety of hand-rolling another simplistic mount check in a bash
> script.... thoughts?
>

Mmm, we are not hiding the message, so I guess it doesn't really
matter, the xfs_repair errors are going to be visible. This testing
remained there from when I wanted to use another exit code for mounted
fs and xfs_repair failures. But I'm removing the check now, with the
merged exit code it is not useful.

Other stuff: ok, changed.

Thanks,
Jan
