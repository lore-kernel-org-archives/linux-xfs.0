Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33660 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752892AbcKDAhE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 3 Nov 2016 20:37:04 -0400
Subject: Re: Can I add external log device after filesystem was created?
References: <CACNifpV5z3r0WB3xypSfGxk6E-=b+3TWrsS4Od7+bKwmmD3yeA@mail.gmail.com>
 <1e60fac5-f2b9-3903-c18c-0a73d0206e0a@sandeen.net>
 <CACNifpV7qQ_5YzJJfdaKi3SThBa7x4N=VNeK1f_OkijiXh6zPA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ba7f0c5e-2e89-98b6-f1ff-9ad00334fcba@sandeen.net>
Date: Thu, 3 Nov 2016 19:37:03 -0500
MIME-Version: 1.0
In-Reply-To: <CACNifpV7qQ_5YzJJfdaKi3SThBa7x4N=VNeK1f_OkijiXh6zPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marcin Sura <mailing-lists@sura.pl>
Cc: linux-xfs@vger.kernel.org

If it's just test data, I can give you a recipe for moving it with
xfs_db, I think - if you're willing to lose the filesystem if
something goes wrong.  ;)

-Eric

On 11/3/16 4:14 PM, Marcin Sura wrote:
> Hi,
> 
> We are building huge test system with hundreds TB of data. We want to
> execute some performance tests without and with external log device.
> Filling in the data is a time consuming process, so my first idea was
> to create the filesystem without external log, execute the tests and
> then add external log and repeat the tests without recreating the
> filesystem. Now I know I have to do this. Thanks
> 
> BR
> Marcin
> 
> 2016-11-03 20:57 GMT+01:00 Eric Sandeen <sandeen@sandeen.net>:
>> On 11/3/16 2:28 PM, Marcin Sura wrote:
>>> Hi,
>>>
>>> I've created filesystem with default mkfs.xfs command, started to use
>>> the filesystem. Few days later I've got nice SSD-based lun which can
>>> be used as external log device.
>>>
>>> Can I add that lun as external log device to an existing filesystem? How?
>>>
>>> BR
>>> Marcin
>>
>> There is no supported mechanism for doing this.  It can be done with xfs_db
>> disk-editing surgery, but that's not really recommended.
>>
>> What is your reason for wanting to move the log?
>>
>> -Eric
> 
