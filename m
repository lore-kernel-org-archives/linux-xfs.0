Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38319 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdBAURh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 15:17:37 -0500
Received: by mail-it0-f49.google.com with SMTP id c7so26093798itd.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Feb 2017 12:17:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <68f4911f-a55a-c21c-1eb0-91c81187c774@sandeen.net>
References: <CAEtPA0BOdAHjtoRrrX3Ha6iHe4VXOUxNe7KPaEdJM=8yYstQMA@mail.gmail.com>
 <68f4911f-a55a-c21c-1eb0-91c81187c774@sandeen.net>
From: Patrick Dung <mpatdung@gmail.com>
Date: Thu, 2 Feb 2017 04:17:36 +0800
Message-ID: <CAEtPA0AbqHKn1-RZiN1g8xHJ8wmZrjXiL40BWVRzn1xzZ2x0EA@mail.gmail.com>
Subject: Re: I had an occasion that XFS is not able to fully detect or recover
 from severe file system corruption
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

> It's also possible that the filesystem somehow got re-corrupted between
the runs.

For my case, the write back SSD caching device was removed permanently.
Somehow the xfs_repair did not fix all problems after the first pass.

Best regards,
Patrick

On Thu, Feb 2, 2017 at 3:58 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 2/1/17 12:53 PM, Patrick Dung wrote:
>> Hi guys,
>>
>> The problem happened in last year. I do not have the corrupted file
>> system now. But I would like to discuss it. Any comment is welcomed.
>>
>> I was using Fedora 24. I had an XFS file system in an hard drive. I
>> had used some kind of  SSD write back caching on top of the hard
>> drive.
>>
>> Somehow the SSD was removed and when the system is rebooted, the XFS
>> file system could not be mounted.
>>
>> I run xfs_repair, it reported some files are corrupted. It had
>> completed the repair of file system and some files were corrupted.
>> Then I could mount the filesystem. I started using the existing files
>> that did not have corruption. After sometime, the file system stopped
>> again because it detected XFS file system is corrupted.
>>
>> Then I run xfs_repair again and it found additional files were still corrupted.
>>
>> So I have a question if xfs_repair is able to fully detect all files
>> that are corrupted by running xfs_repair only once.
>
> Yes, xfs_repair is intended to fix everything on the first pass.  Rarely,
> there are bugs when it does not.
>
> It's also possible that the filesystem somehow got re-corrupted between
> the runs.
>
> -Eric
>
>> Best regards,
>> Patrick
