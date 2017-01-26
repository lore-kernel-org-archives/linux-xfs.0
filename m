Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:45160 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754082AbdAZRrv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Jan 2017 12:47:51 -0500
Subject: Re: Quota-enabled XFS hangs during mount
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
 <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
 <20161103013153.GH9920@dastard>
 <7993e9b8-6eb8-6a0d-aa72-01346cca1b63@zoner.cz>
 <20161103204049.GA28177@dastard>
 <43ca55d0-6762-d54f-5ba9-a83f9c1988f6@zoner.cz>
 <20170123134452.GA33287@bfoster.bfoster>
 <5b41d19b-1a0d-2b74-a633-30a5f6d2f14a@zoner.cz>
 <20170125221739.GA33995@bfoster.bfoster>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <30d56003-a517-f6f0-d188-d0ada5a9fbb7@zoner.cz>
Date: Thu, 26 Jan 2017 18:46:42 +0100
MIME-Version: 1.0
In-Reply-To: <20170125221739.GA33995@bfoster.bfoster>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Hello,

Dne 25.1.2017 v 23:17 Brian Foster napsal(a):
> On Tue, Jan 24, 2017 at 02:17:36PM +0100, Martin Svec wrote:
>> Hello,
>>
>> Dne 23.1.2017 v 14:44 Brian Foster napsal(a):
>>> On Mon, Jan 23, 2017 at 10:44:20AM +0100, Martin Svec wrote:
>>>> Hello Dave,
>>>>
>>>> Any updates on this? It's a bit annoying to workaround the bug by increasing RAM just because of the
>>>> initial quotacheck.
>>>>
>>> Note that Dave is away on a bit of an extended vacation[1]. It looks
>>> like he was in the process of fishing through the code to spot any
>>> potential problems related to quotacheck+reclaim. I see you've cc'd him
>>> directly so we'll see if we get a response wrt to if he got anywhere
>>> with that...
>>>
>>> Skimming back through this thread, it looks like we have an issue where
>>> quota check is not quite reliable in the event of reclaim, and you
>>> appear to be reproducing this due to a probably unique combination of
>>> large inode count and low memory.
>>>
>>> Is my understanding correct that you've reproduced this on more recent
>>> kernels than the original report? 
>> Yes, I repeated the tests using 4.9.3 kernel on another VM where we hit this issue.
>>
>> Configuration:
>> * vSphere 5.5 virtual machine, 2 vCPUs, virtual disks residing on iSCSI VMFS datastore
>> * Debian Jessie 64 bit webserver, vanilla kernel 4.9.3
>> * 180 GB XFS data disk mounted as /www
>>
>> Quotacheck behavior depends on assigned RAM:
>> * 2 or less GiB: mount /www leads to a storm of OOM kills including shell, ttys etc., so the system
>> becomes unusable.
>> * 3 GiB: mount /www task hangs in the same way as I reported in earlier in this thread.
>> * 4 or more GiB: mount /www succeeds.
>>
> I was able to reproduce the quotacheck OOM situation on latest kernels.
> This problem actually looks like a regression as of commit 17c12bcd3
> ("xfs: when replaying bmap operations, don't let unlinked inodes get
> reaped"), but I don't think that patch is the core problem. That patch
> pulled up setting MS_ACTIVE on the superblock from after XFS runs
> quotacheck to before it (for other reasons), which has a side effect of
> causing inodes to be placed onto the lru once they are released. Before
> this change, all inodes were immediately marked for reclaim once
> released from quotacheck because the superblock had not been set active.
>
> The problem here is first that quotacheck issues a bulkstat and thus
> grabs and releases every inode in the fs. The quotacheck occurs at mount
> time, which means we still hold the s_umount lock and thus the shrinker
> cannot run even though it is registered. Therefore, we basically just
> populate the lru until we've consumed too much memory and blow up.
>
> I think the solution here is to preserve the quotacheck behavior prior
> to commit 17c12bcd3 via something like the following:
>
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1177,7 +1177,7 @@ xfs_qm_dqusage_adjust(
>  	 * the case in all other instances. It's OK that we do this because
>  	 * quotacheck is done only at mount time.
>  	 */
> -	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip);
> +	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, XFS_ILOCK_EXCL, &ip);
>  	if (error) {
>  		*res = BULKSTAT_RV_NOTHING;
>  		return error;
>
> ... which allows quotacheck to run as normal in my quick tests. Could
> you try this on your more recent kernel tests and see whether you still
> reproduce any problems?

The above patch fixes OOM issues and reduces overall memory consumption during quotacheck. However,
it does not fix the original xfs_qm_flush_one() freezing. I'm still able to reproduce it with 1 GB
of RAM or lower. Tested with 4.9.5 kernel.

If it makes sense to you, I can rsync the whole filesystem to a new XFS volume and repeat the tests.
At least, that could tell us if the problem depends on a particular state of on-disk metadata
structures or it's a general property of the given filesystem tree.

Martin

