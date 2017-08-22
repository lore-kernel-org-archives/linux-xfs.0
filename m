Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41414 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751643AbdHVWnp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Aug 2017 18:43:45 -0400
Subject: Re: XFS Bug Report
From: Eric Sandeen <sandeen@sandeen.net>
References: <CAFzqJcahyU7F5CJcYKTPabWBVCnufwSMS4QcJijHVVux-Ndv+Q@mail.gmail.com>
 <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
Message-ID: <1b00bb62-6c46-fbb5-f127-e1157c1a83fc@sandeen.net>
Date: Tue, 22 Aug 2017 17:43:43 -0500
MIME-Version: 1.0
In-Reply-To: <ad807068-5de9-3200-68ef-de9e42401a5a@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ruoxin Jiang <rj2394@columbia.edu>, linux-xfs@vger.kernel.org
Cc: Suman Jana <sumanj@gmail.com>



On 8/22/17 5:33 PM, Eric Sandeen wrote:
> On 8/22/17 4:10 PM, Ruoxin Jiang wrote:
>> Hello,
>>
>> We are researchers from Columbia University, New York. As part of our
>> current research we have run into some issues using xfs filesystem.
>> For example, we encountered a case where the setuid bit of a modified
>> executable was not removed as desired.
> 
> Thanks for the reports.
> 
> For case 1:
> 
>> * In xfs, function `xfs_file_aio_write_checks` calls `file_remove_privs` which
>> removes special file priviledges when the executable is written to or truncated.
>>
>> * If an DIO write is not aligned to device logical sector size, the syscall
>> fails with  EINVAL` before `xfs_file_aio_write_checks` is called. Thus the setuid
>> bit will not be removed from the modified executable.
> 
> If the write did not happen, why should the setuid bit be removed?
> The write failed and the file's contents were not modified.  It seems
> like xfs's behavior makes sense; is there a posix specification that
> indicates the behavior should be different?

In fact, POSIX says:

"/Upon successful completion/ where nbyte is greater than 0, write() shall mark for update the st_ctime and st_mtime fields of the file, and if the file is a regular file, the S_ISUID and S_ISGID bits of the file mode may be cleared."

(emphasis mine ... in your case, the write did not successfully complete, and 0 bytes were written)

-Eric
