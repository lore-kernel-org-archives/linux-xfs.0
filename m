Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A064CC83F37
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 20:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbjHaUje (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 16:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbjHaUjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 16:39:33 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D40D1B0
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 13:39:30 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C4DE25196E5;
        Thu, 31 Aug 2023 15:39:29 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net C4DE25196E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1693514369;
        bh=Bh16zVVqTXWeccGVUPsXfleCyo77cSnNJherpwXY8GU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=At2LbJH2+3I9vcQw/XfxiLzXTbaC7ztV4QyYSXBFjJI72aoH7wrEaVXB24M9lXlA0
         BQYyq1qOtwrhXw/H8lLN5TuLQApYjGkKpEkRLnUm+iLNCCBvYzydFtiRCJ8bpo/+SO
         k0iTBnIOXio9yJsdQB3TEInNHiHjXjHsCis94RRZH0PnHTAO/WMICxohFJFnHYl0FF
         iMwtb7psQvzOAMsrtpV0wAxJ9OBPSe0ufXCF0+xXjZXBlATQeiJyjADrhVyhMF9IiF
         aLmJ6rfBsO/hVH4At90YUf3iMAKiX5IiQJbcMMm2WBRJ2rhwDtoARtSYZ222+DjmjC
         PsRPAD+7vqFNA==
Message-ID: <e983dd25-3c38-9453-1eef-f6a6da79857d@sandeen.net>
Date:   Thu, 31 Aug 2023 15:39:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2] xfs: load uncached unlinked inodes into memory on
 demand
Content-Language: en-US
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>
References: <87pm338jyz.fsf@doe.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <87pm338jyz.fsf@doe.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/31/23 7:39 AM, Ritesh Harjani (IBM) wrote:
> "Darrick J. Wong" <djwong@kernel.org> writes:
> 
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> shrikanth hegde reports that filesystems fail shortly after mount with
>> the following failure:
>>
>> 	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
>>
>> This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:
>>
>> 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
>> 	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }
>>
>> From diagnostic data collected by the bug reporters, it would appear
>> that we cleanly mounted a filesystem that contained unlinked inodes.
>> Unlinked inodes are only processed as a final step of log recovery,
>> which means that clean mounts do not process the unlinked list at all.
>>
>> Prior to the introduction of the incore unlinked lists, this wasn't a
>> problem because the unlink code would (very expensively) traverse the
>> entire ondisk metadata iunlink chain to keep things up to date.
>> However, the incore unlinked list code complains when it realizes that
>> it is out of sync with the ondisk metadata and shuts down the fs, which
>> is bad.
>>
>> Ritesh proposed to solve this problem by unconditionally parsing the
>> unlinked lists at mount time, but this imposes a mount time cost for
>> every filesystem to catch something that should be very infrequent.
>> Instead, let's target the places where we can encounter a next_unlinked
>> pointer that refers to an inode that is not in cache, and load it into
>> cache.
>>
>> Note: This patch does not address the problem of iget loading an inode
>> from the middle of the iunlink list and needing to set i_prev_unlinked
>> correctly.
>>
>> Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
>> Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>> v2: log that we're doing runtime recovery, dont mess with DONTCACHE,
>>     and actually return ENOLINK
>> ---
>>  fs/xfs/xfs_inode.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++---
>>  fs/xfs/xfs_trace.h |   25 +++++++++++++++++
>>  2 files changed, 96 insertions(+), 4 deletions(-)
> 
> Hi Darrick,
> 
> Thanks for taking a look at this. I tested this patch on the setup where
> Shrikanth earlier saw the crash. I still can see a problem. I saw it is
> taking the branch from 
> 
> +	/* If this is not an unlinked inode, something is very wrong. */
> +	if (VFS_I(next_ip)->i_nlink != 0) {
> +		error = -EFSCORRUPTED;
> +		goto rele;
> +	}
> 
> Here are the logs of reference - 
> 
> [   21.399573] XFS (dm-0): Found unrecovered unlinked inode 0x2ec44d in AG 0x0.  Initiating recovery.
> [   21.400150] XFS (dm-0): Internal error xfs_trans_cancel at line 1104 of file fs/xfs/xfs_trans.c.  Caller xfs_remove+0x1a0/0x310 [xfs]

Do you have a metadump for that filesystem, to examine that inode?

-Eric

> [   21.400222] CPU: 0 PID: 1629 Comm: systemd-tmpfile Not tainted 6.5.0+ #2
> [   21.400226] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
> [   21.400230] Call Trace:
> [   21.400231] [c000000014cdbb70] [c000000000f377b8] dump_stack_lvl+0x6c/0x9c (unreliable)
> [   21.400239] [c000000014cdbba0] [c008000000f7c204] xfs_error_report+0x5c/0x80 [xfs]
> [   21.400303] [c000000014cdbc00] [c008000000fab320] xfs_trans_cancel+0x178/0x1b0 [xfs]
> [   21.400371] [c000000014cdbc50] [c008000000f999d8] xfs_remove+0x1a0/0x310 [xfs]
> [   21.400432] [c000000014cdbcc0] [c008000000f93eb0] xfs_vn_unlink+0x68/0xf0 [xfs]
> [   21.400493] [c000000014cdbd20] [c0000000005b8038] vfs_rmdir+0x178/0x300
> [   21.400498] [c000000014cdbd60] [c0000000005be444] do_rmdir+0x124/0x240
> [   21.400502] [c000000014cdbdf0] [c0000000005be594] sys_rmdir+0x34/0x50
> [   21.400506] [c000000014cdbe10] [c000000000033c38] system_call_exception+0x148/0x3a0
> [   21.400511] [c000000014cdbe50] [c00000000000c6d4] system_call_common+0xf4/0x258



