Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 18:36:34 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K1aUst020859
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 18:36:31 -0700
Message-ID: <48FBEED9.30609@sgi.com>
Date: Mon, 20 Oct 2008 12:37:13 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Re: another problem with latest code drops
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed> <20081017020718.GE31761@disturbed>
In-Reply-To: <20081017020718.GE31761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Oct 17, 2008 at 01:04:34PM +1100, Dave Chinner wrote:
>> On Fri, Oct 17, 2008 at 12:21:41PM +1100, Dave Chinner wrote:
>>> On Fri, Oct 17, 2008 at 11:17:46AM +1000, Lachlan McIlroy wrote:
>>>> Dave Chinner wrote:
>>>>>> I am seeing a lot of memory used here though:
>>>>>>
>>>>>> 116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security
>>>>> Ah - I don't run selinux. Sounds like a bug that needs reporting
>>>>> to lkml...
>>>> I'm sure this is caused by your changes that introduced inode_init_always().
>>>> It re-initialises an existing inode without destroying it first so it calls
>>>> security_inode_alloc() without calling security_inode_free().
>>> I can't think of how. The layers above XFS are symmetric:
>> .....
>>> And we should have this symmetry everywhere.
>>>
>>> <thinks for a bit>
>>>
>>> Hmmmm - maybe the xfs_iget_cache_miss failure paths where we call
>>> xfs_idestroy() could leak contexts. We should really call xfs_iput()
>>> because we have an initialised linux inode at this point and so
>>> we need to go through destroy_inode(). I'll have a bit more of
>>> a look, but this doesn't seem to account for the huge number of
>>> leaked contexts you reported....
>> Patch below that replaces xfs_idestroy() with IRELE() to destroy
>> the inode via the normal iput() path. It also fixes a second issue
>> that I found by inspection related to security contexts as a result
>> of hooking up ->destroy_inode.
>>
>> It's running QA now.
>>
>> FWIW, I'm not sure if this patch will apply cleanly - I'm still
>> running of my stack of patches and not what has been checked into
>> ptools. Any idea of when all the patches in ptools will be pushed
>> out to the git tree?
> 
> And now with the patch.

Nope, that didn't help.  The system still leaks - and at the same
apparent rate too.

I also hit this panic where we have taken a reference on an inode
that has I_CLEAR set.  I suspect we've made it into xfs_iget_cache_hit()
and found an inode with XFS_IRECLAIMABLE set and since we don't call
igrab() we don't do the I_CLEAR check.  I'm not really convinced that
activating dead inodes is such a good idea.

<5>[  253.457411] XFS mounting filesystem dm-0
<7>[  253.460353] Ending clean XFS mount for filesystem: dm-0
<4>[ 1727.071933] sar used greatest stack depth: 3368 bytes left
<4>[ 6212.214445] pdflush used greatest stack depth: 2888 bytes left
<4>[ 6601.643218] df used greatest stack depth: 2632 bytes left
<0>[ 6601.800534] ------------[ cut here ]------------
<2>[ 6601.801127] kernel BUG at fs/inode.c:1194!
[1]kdb> 
[1]kdb> bt
Stack traceback for pid 6700
0xffff8810048d5dc0     6700     6594  1    1   R  0xffff8810048d6228 *fsstress
sp                ip                Function (args)
0xffff881004945a58 0xffffffff810bc8a4 iput+0x1b (0xffff880857fb02a0)
0xffff881004945aa0 0xffffffff8119734d xfs_iget+0x432 (0xffff88100e780000, 0x0, 0x20000080, invalid, 0x200000008, 0xffff881004945b38, 0xcd18e40)
0xffff881004945b20 0xffffffff811a135e xfs_bulkstat_one_iget+0x3a (0xffff88100e780000, 0x20000080, 0xcd18e40, 0xffff8803d9ed2c60, 0xffff881004945ce4)
0xffff881004945b70 0xffffffff811a15b6 xfs_bulkstat_one+0x9a (0xffff88100e780000, 0x20000080, 0x7fff91556de0, invalid, invalid, 0xcd18e40, 0xffff881004945cd0, 0x0, 0xffff881004945ce4)
0xffff881004945bc0 0xffffffff811a0f7f xfs_bulkstat+0x7fd (0xffff88100e780000, 0xffff881004945dd8, 0xffff881004945d5c, 0xffffffff811a151c, 0x0, 0x88, 0x7fff91556de0, 0x1, 0xffff881004945de0)
0xffff881004945d20 0xffffffff811a16a7 xfs_bulkstat_single+0x93 (0xffff88100e780000, 0xffff881004945dd8, 0x7fff91556de0, 0xffff881004945de0)
0xffff881004945d90 0xffffffff811c1f4a xfs_ioc_bulkstat+0xd5 (0xffff88100e780000, invalid, invalid)
0xffff881004945e10 0xffffffff811c2f99 xfs_ioctl+0x2ea (0xffff88100b3cc140, 0xffff880a8e984900, invalid, invalid, 0x7fff91556e70)
0xffff881004945e80 0xffffffff811c123f xfs_file_ioctl+0x36 (invalid, invalid, invalid)
0xffff881004945eb0 0xffffffff810b5c42 vfs_ioctl+0x2a (0xffff880a8e984900, invalid, 0x7fff91556e70)
0xffff881004945ee0 0xffffffff810b5eee do_vfs_ioctl+0x25f (invalid, invalid, invalid, 0x7fff91556e70)
0xffff881004945f30 0xffffffff810b5f62 sys_ioctl+0x57 (invalid, invalid, 0x7fff91556e70)
  not matched: from 0xffffffff8100bfb2 to 0xffffffff8100c02a drop_through 0 bb_jmp[7]
bb_special_case: Invalid bb_reg_state.memory, missing trailing entries
bb_special_case: on transfer to int_with_check
  Assuming system_call_fastpath is 'pass through' with 6 register parameters
kdb_bb: 0xffffffff8100bf3b [kernel]system_call_fastpath failed at 0xffffffff8100bfcd

Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
[1]more> 
0xffff881004945a08 0xffffffff811a135e xfs_bulkstat_one_iget+0x3a
0xffff881004945a18 0xffffffff811a135e xfs_bulkstat_one_iget+0x3a
0xffff881004945a58 0xffffffff810bc8a4 iput+0x1b
0xffff881004945aa0 0xffffffff8119734d xfs_iget+0x432
0xffff881004945b00 0xffffffff811a06e2 xfs_bulkstat_one_fmt
0xffff881004945b20 0xffffffff811a135e xfs_bulkstat_one_iget+0x3a
0xffff881004945b30 0xffffffff811bbd4d kmem_alloc+0x67
0xffff881004945b38 0xffffffff811a0cdd xfs_bulkstat+0x55b
0xffff881004945b50 0xffffffff811a06e2 xfs_bulkstat_one_fmt
0xffff881004945b70 0xffffffff811a15b6 xfs_bulkstat_one+0x9a
0xffff881004945bc0 0xffffffff811a0f7f xfs_bulkstat+0x7fd
0xffff881004945bf8 0xffffffff811a151c xfs_bulkstat_one
0xffff881004945ca0 0xffffffff811a06e2 xfs_bulkstat_one_fmt
0xffff881004945d20 0xffffffff811a16a7 xfs_bulkstat_single+0x93
0xffff881004945d90 0xffffffff811c1f4a xfs_ioc_bulkstat+0xd5
0xffff881004945da0 0xffffffff811c900f _xfs_itrace_entry+0x9e
0xffff881004945e10 0xffffffff811c2f99 xfs_ioctl+0x2ea
0xffff881004945e80 0xffffffff811c123f xfs_file_ioctl+0x36
0xffff881004945eb0 0xffffffff810b5c42 vfs_ioctl+0x2a
0xffff881004945ee0 0xffffffff810b5eee do_vfs_ioctl+0x25f
0xffff881004945f30 0xffffffff810b5f62 sys_ioctl+0x57
[1]kdb> 
[1]kdb> xinode 0xffff880857fb02a0
Unknown kdb command: 'xinode 0xffff880857fb02a0
'
[1]kdb> inode 0xffff880857fb02a0
struct inode at  0xffff880857fb02a0
 i_ino = 1745051539 i_count = 1 i_size 0
 i_mode = 040777  i_nlink = 1  i_rdev = 0x0
 i_hash.nxt = 0x0000000000000000 i_hash.pprev = 0x0000000000000000
 i_list.nxt = 0x00000000001000f0 i_list.prv = 0x00000000002001f0
 i_dentry.nxt = 0xffff880857fb0238 i_dentry.prv = 0xffff880857fb0238
 i_sb = 0xffff88100e7818d8 i_op = 0xffffffff81eecb80 i_data = 0xffff880857fb0488 nrpages = 0
 i_fop= 0xffffffff81eecaa0 i_flock = 0x0000000000000000 i_mapping = 0xffff880857fb0488
 i_flags 0x0 i_state 0x40 [I_CLEAR]  fs specific info @ 0xffff880857fb0688
[1]kdb> md8c1 0xffff880857fb0688
0xffff880857fb0688 0000000000000000                    ........
[1]kdb> 
