Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34161 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752498AbdDKD5M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Apr 2017 23:57:12 -0400
Subject: Re: [PATCH v3] repair: handle reading superblock from image on larger
 sector size filesystem
References: <1491480320-6511-1-git-send-email-zlang@redhat.com>
 <47d79267-118f-1b27-94e2-bbfcba98cd41@sandeen.net>
 <20170411032541.GO21915@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f8caee4a-d8aa-1aa5-bb17-b8c7142bf17d@sandeen.net>
Date: Mon, 10 Apr 2017 22:57:11 -0500
MIME-Version: 1.0
In-Reply-To: <20170411032541.GO21915@dhcp12-143.nay.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/10/17 10:25 PM, Zorro Lang wrote:
> On Mon, Apr 10, 2017 at 12:16:41PM -0500, Eric Sandeen wrote:
>> On 4/6/17 7:05 AM, Zorro Lang wrote:
>>> Due to xfs_repair uses direct IO, sometimes it can't read superblock
>>> from an image file has smaller sector size than host filesystem.
>>> Especially that superblock doesn't align with host filesystem's
>>> sector size.
>>>
>>> Fortunately, xfsprogs already has code to do isa_file and geometry
>>> check in xfs_repair.c, it turns off O_DIRECT after phase1() if the
>>> sector size is less than the host filesystem's geometry. So move
>>> the isa_file auto detection over up the phase1(), and try to do
>>> once geometry check before phase1() if get_sb() return OK.
>>
>> Zorro, can you do a quick test for me - does a filesystem which fails
>> repair without this patch also fail xfs_copy if the source and/or
>> destination of the copy is on this same filesystem/device as the image
>> file in your xfs_repair test?
> 
> Sure, the xfs_copy has similar problem. I'm writting a xfstests case to
> do xfs_repair and xfs_copy a file image likes this. Do you have any other
> related suggestions which I can write them together?

Any userspace which needs to read a filesystem image probably has the same
issue.

I'm wondering if all of this handling should somehow be factored out and
re-used across the utilities...

-Eric
