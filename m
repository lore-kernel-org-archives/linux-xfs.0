Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:34223 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdDKHss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 03:48:48 -0400
Received: by mail-wr0-f178.google.com with SMTP id z109so23110211wrb.1
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2017 00:48:47 -0700 (PDT)
Subject: Re: filesystem dead, xfs_repair won't help
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
 <7ee4173a-93b4-4000-757f-52733a2edcca@sandeen.net>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <bbdd285a-e0ce-d643-85d4-4269af4b58cf@scylladb.com>
Date: Tue, 11 Apr 2017 10:48:44 +0300
MIME-Version: 1.0
In-Reply-To: <7ee4173a-93b4-4000-757f-52733a2edcca@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

That seems to be it.


On 04/10/2017 06:49 PM, Eric Sandeen wrote:
> There is a known firmware bug on Intel 600P drives which
> causes corruption with XFS, FWIW.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1402533
>
> On 4/10/17 4:23 AM, Avi Kivity wrote:
>> Today my kernel complained that in memory metadata is corrupt and
>> asked that I run xfs_repair.  But xfs_repair doesn't like the
>> superblock and isn't able to find a secondary superblock.
>>
>> Latest Fedora 25 kernel, new Intel NVMe drive (worked for a few weeks
>> without issue).
>>
>> Anything I can do to recover the data?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

