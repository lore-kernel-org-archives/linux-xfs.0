Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41224 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbeJHVzD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 17:55:03 -0400
Subject: Re: repair: realloc(): invalid next size
From: Eric Sandeen <sandeen@sandeen.net>
References: <214be03d-9cc7-378b-3635-6fca3cdcb1dd@gmail.com>
 <944a6c4f-4f4a-d80e-eba2-a69a179e5408@sandeen.net>
Message-ID: <8a574052-acc5-b23d-560e-77f461d683ed@sandeen.net>
Date: Mon, 8 Oct 2018 09:42:57 -0500
MIME-Version: 1.0
In-Reply-To: <944a6c4f-4f4a-d80e-eba2-a69a179e5408@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>, linux-xfs@vger.kernel.org



On 10/8/18 9:26 AM, Eric Sandeen wrote:
> 
> 
> On 10/8/18 9:03 AM, Arkadiusz Miśkiewicz wrote:
>>
>> Big fs, ton of small files, repair takes 36h until this happens:
>>
>> rebuilding directory inode 30363993060
>> rebuilding directory inode 30398868604
>> rebuilding directory inode 30414474627
>> rebuilding directory inode 30425006954
>> rebuilding directory inode 30447937553
>> rebuilding directory inode 30529556616
>> rebuilding directory inode 30537494728
>> rebuilding directory inode 30569826838
>> rebuilding directory inode 31060721895
>> Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>> Warning: recursive buffer locking at block 31060721776 detected
>> Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>> Warning: recursive buffer locking at block 31060721776 detected
>> Metadata corruption detected at 0x41f980, inode 0x73b5d00e7 data fork
>> xfs_repair: warning - iflush_int failed (-117)
>> realloc(): invalid next size
>> Aborted
>>
>>
>> Fails somewhere in 0x41f9db <xfs_dir2_sf_verify+603>
>>
>> Complete log at
>> https://ixion.pld-linux.org/~arekm/xfs-1/repair.txt
>>
>> Test was done with xfs_repair 4.17.0 and 4.18.0 with the same result.
>>
>> kernel 4.18.5
>>
>> Running under gdb now.
>>
>> Any ideas?
> 
> With such a big fs it's tough to share a metadump for a reproducer, I assume.
> 
> The earlier write verifiers failing for xfs_repair writes are troubling...
> 
> I'm not certain why it's rebuilding so many dir inodes; there are several cases
> where that happens, but unfortunately repair doesn't always say which one or why.
> 
> Anyway, you eventually get to this inode (it's the same in decimal & hex
> below):
> 
> rebuilding directory inode 360732305
> Metadata corruption detected at 0x41f9db, inode 0x15805691 data fork
> xfs_repair: warning - iflush_int failed (-117)
> 
> with lots of corruption during the writes, and this happens for a couple
> other inodes, until finally:
> 
> rebuilding directory inode 31060721895
> Metadata corruption detected at 0x41f9db, inode 0x73b5d00e7 data fork
> 
> and this one ends up aborting in glibc's realloc():
> 
> realloc(): invalid next size
> 
> I /think/ that this indicates that memory has been corrupted during the repair
> run.  :/  Running under valgrind would probably lead to a 72hr runtime or more :)
> 
> I wonder if it would save time in the long run to make a metadump and remove all
> directory trees other than this inode (360732305) from it, and see if the same
> failure occurs when running on the reduced fs image?

Actually if you try that, also leaving the directory trees in place for the other
inodes that reported issues would make sense.

-Eric
