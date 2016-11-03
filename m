Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36079 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758128AbcKCVOP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2016 17:14:15 -0400
Received: by mail-yw0-f170.google.com with SMTP id l124so66601651ywb.3
        for <linux-xfs@vger.kernel.org>; Thu, 03 Nov 2016 14:14:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1e60fac5-f2b9-3903-c18c-0a73d0206e0a@sandeen.net>
References: <CACNifpV5z3r0WB3xypSfGxk6E-=b+3TWrsS4Od7+bKwmmD3yeA@mail.gmail.com>
 <1e60fac5-f2b9-3903-c18c-0a73d0206e0a@sandeen.net>
From: Marcin Sura <mailing-lists@sura.pl>
Date: Thu, 3 Nov 2016 22:14:14 +0100
Message-ID: <CACNifpV7qQ_5YzJJfdaKi3SThBa7x4N=VNeK1f_OkijiXh6zPA@mail.gmail.com>
Subject: Re: Can I add external log device after filesystem was created?
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Hi,

We are building huge test system with hundreds TB of data. We want to
execute some performance tests without and with external log device.
Filling in the data is a time consuming process, so my first idea was
to create the filesystem without external log, execute the tests and
then add external log and repeat the tests without recreating the
filesystem. Now I know I have to do this. Thanks

BR
Marcin

2016-11-03 20:57 GMT+01:00 Eric Sandeen <sandeen@sandeen.net>:
> On 11/3/16 2:28 PM, Marcin Sura wrote:
>> Hi,
>>
>> I've created filesystem with default mkfs.xfs command, started to use
>> the filesystem. Few days later I've got nice SSD-based lun which can
>> be used as external log device.
>>
>> Can I add that lun as external log device to an existing filesystem? How?
>>
>> BR
>> Marcin
>
> There is no supported mechanism for doing this.  It can be done with xfs_db
> disk-editing surgery, but that's not really recommended.
>
> What is your reason for wanting to move the log?
>
> -Eric
