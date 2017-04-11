Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53228 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdDKNjA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 09:39:00 -0400
Subject: Re: [PATCH v3] repair: handle reading superblock from image on larger
 sector size filesystem
References: <1491480320-6511-1-git-send-email-zlang@redhat.com>
 <47d79267-118f-1b27-94e2-bbfcba98cd41@sandeen.net>
 <20170411032541.GO21915@dhcp12-143.nay.redhat.com>
 <f8caee4a-d8aa-1aa5-bb17-b8c7142bf17d@sandeen.net>
 <20170411043152.GQ21915@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <69f506df-0817-4d0a-8506-f0e37d7d972c@sandeen.net>
Date: Tue, 11 Apr 2017 08:38:59 -0500
MIME-Version: 1.0
In-Reply-To: <20170411043152.GQ21915@dhcp12-143.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/10/17 11:31 PM, Zorro Lang wrote:
> On Mon, Apr 10, 2017 at 10:57:11PM -0500, Eric Sandeen wrote:
>> On 4/10/17 10:25 PM, Zorro Lang wrote:
>>> On Mon, Apr 10, 2017 at 12:16:41PM -0500, Eric Sandeen wrote:
>>>> On 4/6/17 7:05 AM, Zorro Lang wrote:
>>>>> Due to xfs_repair uses direct IO, sometimes it can't read superblock
>>>>> from an image file has smaller sector size than host filesystem.
>>>>> Especially that superblock doesn't align with host filesystem's
>>>>> sector size.
>>>>>
>>>>> Fortunately, xfsprogs already has code to do isa_file and geometry
>>>>> check in xfs_repair.c, it turns off O_DIRECT after phase1() if the
>>>>> sector size is less than the host filesystem's geometry. So move
>>>>> the isa_file auto detection over up the phase1(), and try to do
>>>>> once geometry check before phase1() if get_sb() return OK.
>>>>
>>>> Zorro, can you do a quick test for me - does a filesystem which fails
>>>> repair without this patch also fail xfs_copy if the source and/or
>>>> destination of the copy is on this same filesystem/device as the image
>>>> file in your xfs_repair test?
>>>
>>> Sure, the xfs_copy has similar problem. I'm writting a xfstests case to
>>> do xfs_repair and xfs_copy a file image likes this. Do you have any other
>>> related suggestions which I can write them together?
>>
>> Any userspace which needs to read a filesystem image probably has the same
>> issue.
> 
> I've already tested xfs_repair, xfs_copy, xfs_metadump, xfs_mdrestore and
> xfs_db -c "sb $i". Only xfs_repair and xfs_copy failed.

Turns out I was wrong in my guess.  Most of those applications do not
use O_DIRECT, so the problem does not exist.

> And I noticed that xfs_copy open source file with O_DIRECT on purpose:
>         if (source_is_file && platform_test_xfs_fd(source_fd))  {
>                 if (fcntl(source_fd, F_SETFL, open_flags | O_DIRECT) < 0)  {
>                         do_log(_("%s: Cannot set direct I/O flag on \"%s\".\n"),
>                                 progname, source_name);
>                         die_perror();
>                 }
> 
> I don't learn about the reason so much, maybe we shouldn't turn off
> its O_DIRECT ?

I think most of these applications use O_DIRECT to avoid polluting the
page cache for a one-off read of the filesystem, and/or to manage caching
on its own (in the xfs_repair case).  I'm not actually sure why xfs_metadump
doesn't use O_DIRECT, other than that it is part of xfs_db, which also doesn't
use O_DIRECT.

In any case, xfs_copy seems to have similar issues, and probably needs fixing
as well.  It might make sense to try to factor out some of this handling
into a common helper, in the long run.

-Eric

> Thanks,
> Zorro
> 
>>
>> I'm wondering if all of this handling should somehow be factored out and
>> re-used across the utilities...
>>
>> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
