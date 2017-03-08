Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36018 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdCHQsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 11:48:39 -0500
Received: by mail-wm0-f54.google.com with SMTP id n11so119693530wma.1
        for <linux-xfs@vger.kernel.org>; Wed, 08 Mar 2017 08:48:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170308155602.GE4353@infradead.org>
References: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
 <20170308155602.GE4353@infradead.org>
From: Bill <billmcdave@gmail.com>
Date: Wed, 8 Mar 2017 16:48:09 +0000
Message-ID: <CAEOfVRkdurzmw4UZeyj6sTO+dGCniFvwp9BOjXyqU+_Tr6z-fw@mail.gmail.com>
Subject: Re: Significantly longer fallocate times with Flag Unwritten Extents disabled
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Woops, I forgot to send this response to the mailing list:

Thanks for the information and the explanation. That all makes sense,
as I cannot reproduce the non-zero data behaviour and suspect I called
fallocate() on an existing file.  When I read back freshly fallocated
files I only ever get zeros back.  Apologies for the confusion.

The reason I am trying to create large uninitialized files quickly is
that I have a hardware (FPGA) based system which is capable of writing
to an SSD at a very fast rate. With software in the loop (managing the
OS, file system and IO etc) I am limited to quite low rates (about 1/5
of the hardware performance) as my processor is not very capable.  As
I typically only write large sequential files, I was pondering whether
I could create a large uninitialized file, figure out where it was
physically located on the disk, unmount the drive and then let my
hardware fill the relevant blocks with data, before handing control
back to the software and remounting the drive. This would give me the
advantages of a filesystem, without having to implement one in
hardware, which would be challenging!

This was probably impossible from the get go, as there is no doubt
some glaring hole in my understanding of how file systems work!

Thanks for the help.

On Wed, Mar 8, 2017 at 3:56 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Mar 06, 2017 at 12:02:01PM +0000, Bill McDuck wrote:
>> Hello.
>>
>> I have been testing the performance of XFS with "Flag Unwritten
>> Extents" enabled and disabled.
>
> Why do you disable it?  It's been part of the defauly on feature
> set for a decade, and manually disabling it will make you run into
> completely untested code.  There is a reason it's mandatory for v5
> file systems.
>
>>
>> For security reasons I know XFS flags all unwritten extents by
>> default, so that uninitialized disk space cannot be read by the user.
>> In my application I actually want to have access to this uninitialized
>> disk space. I have been modifying the superblocks using xfs_repair to
>> enable this functionality.
>
> Don't do that, it's not supported for a reason.
