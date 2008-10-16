Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 18:41:44 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G1feEa019412
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 18:41:40 -0700
Message-ID: <48F6AA3E.8030902@sgi.com>
Date: Thu, 16 Oct 2008 12:43:10 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: crash with latest code drop.
References: <48F54C20.8060704@sgi.com> <20081015011857.GS10716@disturbed> <20081015022948.GA20966@infradead.org> <20081015031645.GA25906@disturbed> <20081015032431.GA7426@infradead.org> <20081015035116.GB25906@disturbed> <48F584B8.8060907@sgi.com> <20081015061917.GC25906@disturbed> <48F5A104.5060506@sgi.com>
In-Reply-To: <48F5A104.5060506@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com


>>  - it's the same as
>> the first report - deferencing the linux inode without first having
>> a refernce on it.
>>   
>
> Yes it resolves the issue.

I spoke to soon, Ooops as follows:

<1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000208
<1>IP: [<ffffffff802a37de>] igrab+0x10/0x30
<4>PGD 6ac33067 PUD 7dda2067 PMD 0
<0>Oops: 0000 [1] SMP
[0]kdb> bt
Stack traceback for pid 5195
0xffff8800378e4c50     5195     5094  1    0   R  0xffff8800378e4fb8 
*bulkstat_unlink
sp                ip                Function (args)
0xffff88007d5abde8 0xffffffff802a37de igrab+0x10 (0x0)
0xffff88007d5abe20 0xffffffffa01f3623 [xfs]xfs_sync_inodes_ag+0xf4 
(0xffff88003756e288, invalid, invalid)
0xffff88007d5abe80 0xffffffffa01f3853 [xfs]xfs_sync_inodes+0x63 
(0xffff88003756e288, invalid)
0xffff88007d5abec0 0xffffffffa01f3919 [xfs]xfs_quiesce_data+0x13 
(0xffff88003756e288)
0xffff88007d5abee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b 
(0xffff88007f1c09c8)
0xffff88007d5abf40 0xffffffff80292fd2 sync_filesystems+0xae (invalid)
0xffff88007d5abf60 0xffffffff802af48b do_sync+0x2f (0x1)
0xffff88007d5abf70 0xffffffff802af4c4 sys_sync+0xe
bb_special_case: Invalid bb_reg_state.memory, missing trailing entries
bb_special_case: on transfer to int_with_check
  Assuming system_call_fastpath is 'pass through' with 6 register parameters
kdb_bb: 0xffffffff8020be0b [kernel]system_call_fastpath failed at 
0xffffffff8020be98

Using old style backtrace, unreliable with no arguments
sp                ip                Function (args)
0xffff88007d5abde8 0xffffffff802a37de igrab+0x10
0xffff88007d5abe10 0xffffffff802a37de igrab+0x10
0xffff88007d5abe20 0xffffffffa01f3623 [xfs]xfs_sync_inodes_ag+0xf4
0xffff88007d5abe80 0xffffffffa01f3853 [xfs]xfs_sync_inodes+0x63
0xffff88007d5abec0 0xffffffffa01f3919 [xfs]xfs_quiesce_data+0x13
0xffff88007d5abec8 0xffffffff802452b9 autoremove_wake_function
0xffff88007d5abee0 0xffffffffa01f1800 [xfs]xfs_fs_sync_super+0x2b
0xffff88007d5abf00 0xffffffff8043b871 __down_read+0x12
0xffff88007d5abf10 0xffffffffa024d395 [ext3]ext3_sync_fs+0x46
0xffff88007d5abf40 0xffffffff80292fd2 sync_filesystems+0xae
0xffff88007d5abf60 0xffffffff802af48b do_sync+0x2f
0xffff88007d5abf70 0xffffffff802af4c4 sys_sync+0xe


Adding the following resolved the issue however you may wish to solve it 
in another manner.

 @@ -102,7 +102,7 @@ xfs_sync_inodes_ag(
                 * in reclaim. Leave it for the reclaim code to flush.
                 */
                inode = VFS_I(ip);
-               if (!igrab(inode)) {
+               if (!inode || !igrab(inode)) {
                        read_unlock(&pag->pag_ici_lock);
                        continue;
                }


Thanks,

Pete
