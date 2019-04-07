Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37548 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbfDGSK5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Apr 2019 14:10:57 -0400
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
References: <20190401070001.GJ1173@magnolia> <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia> <20190406232717.GH18897@mit.edu>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e358c920-d49e-8319-ee19-4b3fa930b0f5@sandeen.net>
Date: Sun, 7 Apr 2019 13:10:55 -0500
MIME-Version: 1.0
In-Reply-To: <20190406232717.GH18897@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>

On 4/6/19 6:27 PM, Theodore Ts'o wrote:
> On Mon, Apr 01, 2019 at 09:55:19PM -0700, Darrick J. Wong wrote:
>>
>> When Ted is done laughing, I really would like to consider something
>> like this to solve the problem of grub-style bootloaders requiring a
>> lease on the blocks underneath a file with a term exceeding that of the
>> running kernel.
>>
>> We can probably skip the harsh synchronous writes in favor of fsync on
>> close, but we would need to keep the critical component of checkpointing
>> the journal on fsync and syncfs.
> 
> At least for ext4, we don't need to add anything new, since FIFREEZE
> force a journal checkpoint.  So we could try to get a patch into grub
> which causes update_grub to open each kernel that it finds, and calls
> fsync(2) on it, and then for all file systems where it finds a kernel,
> it can call FIFREEZE and FITHAW on it, and that would be that.

Certain operating systems have hacked this in.  My concern would be when
/boot is on / ... calling FIFREEZE on the root fs would most likely be
a bad thing.  Certain operating systems avoid calling FIFREEZE for
/boot-on-root.  ;)

Doing it for a standalone /boot seems like a reasonable (if hacky)
workaround as long as we lack a more targeted quiesce interface...

-Eric
 
> That's not guaranteed to work for all file systems, of course.  So the
> right answer may be to define a new IOCTL which causes all file system
> to do whatever log truncation is needed so that grub will do the right
> thing.
> 
> 					- Ted
> 
