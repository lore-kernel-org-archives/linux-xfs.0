Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34450 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfBQQfc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Feb 2019 11:35:32 -0500
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
From: Boaz Harrosh <openosd@gmail.com>
Message-ID: <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
Date: Sun, 17 Feb 2019 18:35:25 +0200
MIME-Version: 1.0
In-Reply-To: <20190214220626.GV14116@dastard>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Omar Sandoval <osandov@osandov.com>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-team@fb.com, linux-api@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org

On 15/02/19 00:06, Dave Chinner wrote:
> On Thu, Feb 14, 2019 at 02:00:07AM -0800, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>>
>> Hi,
>>
>> Since statx was added in 4.11, userspace has had an interface for
>> reading btime (file creation time), but no way to set it. This RFC patch
>> series adds support for changing btime with utimensat(). Patch 1 adds
>> the VFS infrastructure, patch 2 adds the support to utimensat() with a
>> new flag, and the rest of the patches add filesystem support; I excluded
>> CIFS for now because I don't have a CIFS setup to test it on.
>>
>> Updating btime is useful for at least a couple of use cases:
>>
[1]
>> - Backup/restore programs (my motivation for this feature is btrfs send)
>> - File servers which interoperate with operating systems that allow
>>   updating file creation time, including Mac OS [1] and Windows [2]
> 
> So you're adding an interface that allows users to change the create
> time of files without needing any privileges?
> 
[2]
> Inode create time is forensic metadata in XFS  - information we use
> for sequence of event and inode lifetime analysis during examination
> of broken filesystem images and systems that have been broken into.
> Just because it's exposed to userspace via statx(), it doesn't mean
> that it is information that users should be allowed to change. i.e.
> allowing users to be able to change the create time on files makes
> it completely useless for the purpose it was added to XFS for...
> 
<snap>

I think the difference in opinion here is that there are two totally
different BTIme out in the world. For two somewhat opposite motivations
and it seems they both try to be crammed into the same on disk space.

One - Author creation time
  This is a Windows originated creature and later MAC (and all vendors who
  make a living by serving cifs (hint see my email address))

  This is a tag carried globally on the globe denoting the time of the
  original creator of the file. copy, download, backup-restore and so
  on preserve it from the very first original creation.
  This creature is a user oriented information. That needs to be carefully
  orchestrated by all parties

Two - Local creation time
  This is an immutable local FS information that helps in debugging and
  FS-checking / recovery of data. It is an information that kind of denotes
  the order of creation of files on a local FS.

So it looks like both sides are correct trying to preserve their own guy?

XFS invented [2] I'd let it be. If you need [1] on XFS better push for
a well defined standardized xattr and be in peace.

BTRFS should decide which one of [2] or [1] it has space for in the inode
and commit to it. Documenting well what it is.

That said putting my Netapp hat. I would love to see an easy API
for Author-creation-time BTime type of value. That is accessed
uniformly by user-mode and/or Network file servers (NFS/CIFS).
And would love to see a generic implementation of that interface
that puts it into a standardized xattr if the FS in question does
not have a native support for it [1].

So I love these patches. And would want to see this through. But
let us understand each other?

Thanks
Boaz
