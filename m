Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51077 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbeGLJRo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jul 2018 05:17:44 -0400
Received: by mail-wm0-f66.google.com with SMTP id v25-v6so4930266wmc.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jul 2018 02:09:02 -0700 (PDT)
Date: Thu, 12 Jul 2018 11:08:58 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH RFC 7/8] xfs: return non-zero blocks for inline data
Message-ID: <20180712090858.u4aodoaf7nmhe3dt@odin.usersys.redhat.com>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-8-git-send-email-shan.hai@oracle.com>
 <20180711130825.dkreolul3mlvtf3b@odin.usersys.redhat.com>
 <2e421e56-7463-3ac1-2eac-fa72ee8cd3eb@oracle.com>
 <fd877bb3-641f-b70c-a40e-e4287339ed53@oracle.com>
 <20180712013147.GK32415@magnolia>
 <e70ed6e4-a889-87ac-d25c-db2abc0e61a1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e70ed6e4-a889-87ac-d25c-db2abc0e61a1@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jul 12, 2018 at 09:46:20AM +0800, Shan Hai wrote:
> 
> 
> On 2018年07月12日 09:31, Darrick J. Wong wrote:
> > On Thu, Jul 12, 2018 at 09:13:46AM +0800, Shan Hai wrote:
> > > 
> > > On 2018年07月12日 09:03, Shan Hai wrote:
> > > > 
> > > > On 2018年07月11日 21:08, Carlos Maiolino wrote:
> > > > > On Fri, Jul 06, 2018 at 11:12:28AM +0800, Shan Hai wrote:
> > > > > > Return non-zero blocks for inline data even though the inode has
> > > > > > no external blocks, otherwise the "ls -ls" would show zero blocks
> > > > > > occupied by the file.
> > > > > > 
> > > > > Is there any issue you ran into while leaving inodes with zero
> > > > > blocks allocated?
> > > > > Inodes should actually report the real amount of allocated blocks,
> > > > > not fake it.
> > > > > Inodes with inlined data should actually report 0 blocks, otherwise,
> > > > > many
> > > > > applications which actually relies on the amount of allocated blocks
> > > > > for each
> > > > > file will misbehave.
> > > > > 
> > > > Man ls(1) reads:
> > > > 
> > > > -s, --size
> > > >      print the allocated size of each file, in blocks
> > > > 
> > > > So the 'ls -ls' would report 0 blocks when the data is inlined, a file
> > > > holds data
> > > > but it consumes 0 blocks, how is it possible :),

It is possible because the file doesn't consume data blocks at all.

> > > This patch is inspired by the
> > > upstream commit 9206c561554c9 (ext4: return non-zero st_blocks for inline
> > > data),
> > > please refer it for details.
> > The fact that we're following precedent set by ext4 is worth mentioning
> > in the commit message.

The fact another filesystem use this trick, doesn't necessarily means it's
correct. Ext4 added it to workaround a issue with tar, which actually skip zero
blocks files. I honestly think it is wrong, we are working around a user space
problem, which is wrongly assuming a 0-block file is empty.

A quick search led me to this thread from tar project:

http://www.mail-archive.com/bug-tar@gnu.org/msg04209.html

which well, from that time, they were already aware that always assuming a
zero-block file is empty, was not safe.



Reporting a used block in a file that is storing data inlined in the inode is
prone for space usage accounting error IMO.

Suppose you have a 4K block-size filesystem, you create 100k files into it with
inlined data.

So now you have 100k files reporting to be using a single FSB, wich converts
into a bit less than 400MB.

How will you make sure the accounting is correct? You can't really mark any
blocks used in the filesystem, so, tools like `df` (or any other tool based on
statfs() ), will report these 400MB as free.

At the same time, tools like `ls`, `du`, etc which relies on per-file stat, will
report these 400MB used.


I do see advantages on reporting a single block use, but IMO, it will cause more
confusion than good.

Anyway, as I said, my opinion only, I do really think reporting a single block
used by inlined files is wrong, and if we are going to do that, we should at
least properly document this is being done to workaround user space issues,
while, in the meantime, it might create others.

Cheers.

-- 
Carlos
