Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA51C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 00:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346401AbiCPAwo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 20:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235429AbiCPAwo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 20:52:44 -0400
X-Greylist: delayed 353 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Mar 2022 17:51:31 PDT
Received: from yehat.aphroland.org (yehat.aphroland.org [64.62.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43F0610FC4
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:51:31 -0700 (PDT)
Received: by yehat.aphroland.org (Postfix, from userid 1010)
        id DB75944C0; Tue, 15 Mar 2022 17:45:38 -0700 (PDT)
Received: from roundcube.linuxpowered.net (localhost [127.0.0.1])
        by yehat.aphroland.org (Postfix) with ESMTP id 89051103
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:45:37 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 15 Mar 2022 17:45:37 -0700
From:   nate <linux-xfs@linuxpowered.net>
To:     linux-xfs@vger.kernel.org
Subject: XFS reflink copy to different filesystem performance question
Message-ID: <2cbd42b3bb49720d53ccca3d19d2ae72@linuxpowered.net>
X-Sender: linux-xfs@linuxpowered.net
User-Agent: Roundcube Webmail/1.3.9
X-Sanitizer: This message has been sanitized!
X-Sanitizer-URL: http://mailtools.anomy.net/
X-Sanitizer-Rev: $Id: Sanitizer.pm,v 1.94 2006/01/02 16:43:10 bre Exp $
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello -

Blast from the past this is the first Majordomo mailing list I can 
recall joining in probably
15-18+ years..

Anyway, I ran into a situation today and was wondering if someone could 
clarify or point me to
some docs so I just have a better understanding as to what is going on 
with this XFS setup.

Hardware: HP DL380 Gen10 6x8TB disks in hardware RAID 10
Software: Ubuntu 20.04 kernel 5.4.0 using XFS with reflinks enabled
Purpose: this system is used to store Veeam Backups (VMware VM backup)

I've used XFS off and on for many years but it wasn't until I set this 
up last year
I had even heard of reflinks. Veeam docs specifically suggested enabling 
it if possible
so I did. Things have been working fine since.

Recently we had a situation come up where we want to copy some of this 
data to a
local USB drive to ship to another location to restore the data. A 
simple enough
process I thought just a basic file copy.

Total of 8.6TB, most of that is in a single 8.3TB file. We got a 18TB 
USB drive , I formatted
it ext4 (feel more comfortable with ext4 on a USB drive).

I started an rsync to copy this data over as I assumed that would be the 
simplest method.
I was pretty surprised to see rsync averaging between 25-30MB/sec. I 
expected more of course.
I checked iostat and was even more surprised to see the 6 disk RAID 10 
array showing
100% i/o utilization - the reads were maxed out, the USB drive was 
barely being touched.
Consider me super confused at this point.. there was no other activity 
on the system.
So I tried a basic cp -a command instead maybe data access for rsync is 
different, I
didn't think so but couldn't help to try.. results were similar. iostat 
showed periodic
bursts to 50-60MB/s but most often below 30MB/s. I like rsync with the 
--progress option
so I went back to rsync again.

So then I looked for other data on the same filesystem that I knew was 
not Veeam data,
so it would not be using reflinks. I found a stash of ~5GB of data and 
copied that,
easily over 100MB/sec(files were smaller and going so fast it was hard 
to tell for
sure).

So the conclusion here is something special with the reflink data causes 
regular
linux copy operations to suffer. I did a bunch of web searches but only 
results seemed
to be people talking about how great reflinks were to make clones of 
data, not
references to people copying reflinked data to another filesystem.

So I was wondering, maybe Veeam does something funky with how it 
accesses data.
Obviously this is going from XFS to EXT4 so there can't be any special 
sauce since
the file systems are totally different.

So I kicked off a copy using Veeam, I don't know what it does on the 
backend. But
iostat showed sustained reads at over 200MB/sec, so call it 8X faster 
than
rsync or cp. At this point the USB drive seemed more of the bottleneck 
(which
is fine).

I can only guess that Veeam is more intelligent in that it is using some 
API
call to XFS to pull the sequential data for the most recent backup, vs 
using
a linux CLI tool is pulling the entire file which probably has a ton of 
different
pointers in it causing a lot more random I/O.

So again, not having a problem really just looking to get a better 
simple
understanding as to why a rsync or cp from reflinked data to another
filesystem is so much slower than veeam doing it itself. I could try to
ask Veeam support but I'm quite confident they'd have no idea what I was
talking about.

and with that said are there tools that can copy reflinked data more
intelligently from the command line (specifically to another 
filesystem)?
I checked the XFS faq and there is no mention of reflink. I couldn't
find info on how to find how many "links" there were or how big each
one was or how to reference them directly.

thanks

nate

