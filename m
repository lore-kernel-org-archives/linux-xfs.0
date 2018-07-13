Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54749 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbeGMMy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jul 2018 08:54:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id i139-v6so8658323wmf.4
        for <linux-xfs@vger.kernel.org>; Fri, 13 Jul 2018 05:39:58 -0700 (PDT)
Date: Fri, 13 Jul 2018 14:39:55 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH RFC 7/8] xfs: return non-zero blocks for inline data
Message-ID: <20180713123955.xbdleb3crazkjnt3@odin.usersys.redhat.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
 <20180711130825.dkreolul3mlvtf3b@odin.usersys.redhat.com>
 <2e421e56-7463-3ac1-2eac-fa72ee8cd3eb@oracle.com>
 <fd877bb3-641f-b70c-a40e-e4287339ed53@oracle.com>
 <20180712013147.GK32415@magnolia>
 <e70ed6e4-a889-87ac-d25c-db2abc0e61a1@oracle.com>
 <20180712090858.u4aodoaf7nmhe3dt@odin.usersys.redhat.com>
 <3ed378e1-8ef3-ddff-7d5f-adf3be6abda8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ed378e1-8ef3-ddff-7d5f-adf3be6abda8@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

> > > > > > > Inodes with inlined data should actually report 0 blocks, otherwise,
> > > > > > > many
> > > > > > > applications which actually relies on the amount of allocated blocks
> > > > > > > for each
> > > > > > > file will misbehave.
> > > > > > > 
> > > > > > Man ls(1) reads:
> > > > > > 
> > > > > > -s, --size
> > > > > >       print the allocated size of each file, in blocks
> > > > > > 
> > > > > > So the 'ls -ls' would report 0 blocks when the data is inlined, a file
> > > > > > holds data
> > > > > > but it consumes 0 blocks, how is it possible :),
> > It is possible because the file doesn't consume data blocks at all.
> > 
> > > > > This patch is inspired by the
> > > > > upstream commit 9206c561554c9 (ext4: return non-zero st_blocks for inline
> > > > > data),
> > > > > please refer it for details.
> > > > The fact that we're following precedent set by ext4 is worth mentioning
> > > > in the commit message.
> > The fact another filesystem use this trick, doesn't necessarily means it's
> > correct. Ext4 added it to workaround a issue with tar, which actually skip zero
> > blocks files. I honestly think it is wrong, we are working around a user space
> > problem, which is wrongly assuming a 0-block file is empty.
> 
> The assumption which deemed 0 block files as empty holds true until the
> kernel broke the
> rules and introduced inline data feature, so the user space should not be
> blamed in my opinion.

Did we? I couldn't find any interface, design, or whatever saying that userspace
can safely assume a zero block file don't have data there and can be ignored,
in fact, the link I posted previously already shows how tar people were not sure
if they should assume a zero block file could be ignored. So, in fact, we didn't
break anything, because as far as I know, nobody and no standard said an
existing zero block file could be safely ignored, assuming it contains no data
at all. Such thing might exist, but I'm not aware of.

> 
> > A quick search led me to this thread from tar project:
> > 
> > http://www.mail-archive.com/bug-tar@gnu.org/msg04209.html
> > 
> > 
> > Anyway, as I said, my opinion only, I do really think reporting a single block
> > used by inlined files is wrong, and if we are going to do that, we should at
> > least properly document this is being done to workaround user space issues,
> > while, in the meantime, it might create others.
> 
> Faking block usage count is not quite correct one but the sad fact is that
> there are applications
> out there which are designed and implemented on the assumption that non-zero
> length files
> consume at least a block, so I don't think breaking the user space suddenly
> by reporting 0 blocks
> for inline data is not a correct solution either.
> 

I understand, and yeah, we fell into some kind of chicken-egg problem, I still
do think though there are not that much applications out there assuming
zero block files are empty, and working around bad coded application which make
assumptions they are not supposed to make, is as bad as breaking applications
for not following standards, which will end up punishing applications which do
not make assumptions they should.

The biggest drawback I can see by reporting 0 blocks allocated for inline files,
might be while estimating space needed for a copy, or a backup for example,
where, if the target filesystem does not support inlined data, 0 blocks files
will occupy at least a block on the target filesystem, but the same holds true
when source and target filesystems have different block sizes.

Anyway, that's all the arguments I have against faking block usage for inlined
files, but the final decision is not mine :)

Cheers

-- 
Carlos
