Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751925AbdJaOAq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 10:00:46 -0400
Date: Tue, 31 Oct 2017 22:00:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/2] xfs: test for umount hang caused by the pending
 dquota log item in AIL
Message-ID: <20171031140041.GO17339@eguan.usersys.redhat.com>
References: <1509003472-24191-1-git-send-email-houtao1@huawei.com>
 <1509003472-24191-2-git-send-email-houtao1@huawei.com>
 <20171031064617.GH17339@eguan.usersys.redhat.com>
 <07ce7e5b-2528-f9ff-69a1-5db7a620e846@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07ce7e5b-2528-f9ff-69a1-5db7a620e846@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

On Tue, Oct 31, 2017 at 08:34:50PM +0800, Hou Tao wrote:
> Hi Eryu,
> 
> Thanks for your detailed review.
> 
> On 2017/10/31 14:46, Eryu Guan wrote:
> > On Thu, Oct 26, 2017 at 03:37:52PM +0800, Hou Tao wrote:
> >> When the first writeback and the retried writeback of dquota buffer get
> >> the same IO error, XFS will let xfsaild to restart the writeback and
> >> xfs_qm_dqflush_done() will not be invoked. xfsaild will try to re-push
> >> the quota log item in AIL, the push will return early everytime after
> >> checking xfs_dqflock_nowait(), and xfsaild will try to push it again.
> >>
> >> IOWs, AIL will never be empty, and the umount process will wait for the
> >> drain of AIL, so the umount process hangs.
> >>
> >> Signed-off-by: Hou Tao <houtao1@huawei.com>
> > 
> > Sorry for the late review. Is there a specific patch or patchset fixed
> > this bug? I tested on v4.14-rc2 kernel and for-next branch on Darrick's
> > tree, test survivied multiple runs on both kernels.
> The problem has not been fixed yet, and Carlos Maiolino is working on the it [1].
> The pass of the test case is out of my expectation. I had tried it on v4.14-rc6,
> and the test case hangs on umount.
> 
> Have you applied the first patch "[PATCH 1/2] dmflakey: support multiple dm targets
> for a dm-flakey device" during the test ? If you have applied it, could you show me
> the full result file of the test case, namely results/xfs/999.full ?

Yes, I applied both of your patches before testing. Test host is a kvm
guest with 4 vcpus and 8G mem running v4.14-rc2 kernel. Below is the
xfs/999.full

me:              flakey-test
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      252, 0
Number of targets: 1

flakey-test: 0 31457280 linear 253:6 0
MOUNT_OPTIONS =  -o usrquota
User quota on /mnt/testarea/scratch (/dev/mapper/flakey-test)
                        Inodes              
User ID      Used   Soft   Hard Warn/Grace  
---------- --------------------------------- 
root            3      0      0  00 [------]
fsgqa           0    500      0  00 [------]

User quota on /mnt/testarea/scratch (/dev/mapper/flakey-test)
                        Inodes              
User ID      Used   Soft   Hard Warn/Grace  
---------- --------------------------------- 
root            3      0      0  00 [------]
fsgqa           0    400      0  00 [------]

Name:              flakey-test
State:             ACTIVE
Read Ahead:        256
Tables present:    LIVE
Open count:        1
Event number:      0
Major, minor:      252, 0
Number of targets: 3

flakey-test: 0 16777256 flakey 253:6 0 0 1 1 error_writes 
flakey-test: 16777256 20480 linear 253:6 16777256
flakey-test: 16797736 14659544 flakey 253:6 16797736 0 1 1 error_writes

[snip]

> >> +
> >> +# inject write IO error
> >> +FLAKEY_TABLE=$(_make_xfs_scratch_flakey_table)
> >> +_load_flakey_table $FLAKEY_ALLOW_WRITES
> > 
> > Set FLAKEY_TABLE_DROP here and call _load_flakey_table with
> > $FLAKEY_DROP_WRITES
> 
> No. We need to use the customized table instead of FLAKEY_TABLE_DROP,
> because we need to let the write return IO error instead of being droppped
> silently and we need to ensure the write of the log will succeed.

I mean something like:

FLAKEY_TABLE_DROP=$(_make_xfs_scratch_flakey_table)
_load_flakey_table $FLAKEY_DROP_WRITES

This basically does the same work as your code, but loading a different
table var. _load_flakey_table selects FLAKEY_TABLE when first argument
is $FLAKEY_ALLOW_WRITES, and selects FLAKEY_TABLE_DROP when the argument
is $FLAKEY_DROP_WRITES. And because you're going to error/drop writes,
it's weired to load table with $FLAKEY_ALLOW_WRITES.

Thanks,
Eryu
