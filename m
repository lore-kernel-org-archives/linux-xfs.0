Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC80ABE68
	for <linux-xfs@vger.kernel.org>; Sun, 22 Sep 2024 15:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727017821; cv=none; b=NYPojbj2gVGBLBulLW22unBPfduPfz/JMcNpGcvoF8w/zLJ2oKIV6oXE3XsuzVbeWl/fPEYeOEWgXbWtpbogm6+st4IPC65CimdrAWRUv9X6QH1x8Y/DGm12A4XItCTc3kWFJ1x8BMJINVBgM3pbeQzkv2gylHE2D9WbJb3Vx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727017821; c=relaxed/simple;
	bh=wlCXFmBECJWtPd0j5M340tFGD+W6ZV85CGJxOEhyfkg=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=IU2q4icmYqOjhYnpIcNzlx3NOZHR+pM7AUgS3sZR5qv4CjqyqxUFUJxT82x8KIsqAqIVFk/tYcekPXPF3Imw2+IWA69b+BTWFab6fFXpX6qQlUjSez0obpvouNYXUNrN14NqZVkeUV+ft/sJcBAV7V5qI7VoGCv2VjRW+5XNBLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyKhhDWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyKhhDWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BD9C4CEC3;
	Sun, 22 Sep 2024 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727017820;
	bh=wlCXFmBECJWtPd0j5M340tFGD+W6ZV85CGJxOEhyfkg=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=UyKhhDWPCDhVsbXWiEcBU9GWjznXc7zi70qvXlM5olda2yr133pY0VK1cX55Z8M71
	 eGiNGFKYY2/+W/55IA0T8JiOMIohZLPOcFG+nTmVvkZvlhCb3OEcBak0h383N9Qx4R
	 LUXKXxsPV5YsMxfoByGssoyzEbjB6f990A+8fdGifMGtlEKVyDKtYb3Xajfwa8yoi+
	 JYlWXo3DwBLmrGX/93NtTZh9/mh/owOM7lPOdQfd+sFs63Wox8wxr2SOIIcfRygp2w
	 iaDjnZlnxaiP3TMbqA7YTyJx2DeLVwpK4wVeb0nhsRe+heJkMwKlc8uOOPPcHqzT2i
	 0tfHmH4d/Vx0w==
References: <20240902075045.1037365-1-chandanbabu@kernel.org>
 <ZtW8cIgjK88RrB77@dread.disaster.area>
 <87v7z0xevx.fsf@debian-BULLSEYE-live-builder-AMD64>
 <87zfo8dly5.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZuoqzHHHwNbCv+dQ@dread.disaster.area>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: Prevent umount from indefinitely waiting on
 XFS_IFLUSHING flag on stale inodes
Date: Sun, 22 Sep 2024 18:53:33 +0530
In-reply-to: <ZuoqzHHHwNbCv+dQ@dread.disaster.area>
Message-ID: <87y13jg1wo.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Sep 18, 2024 at 11:20:12 AM +1000, Dave Chinner wrote:
> On Mon, Sep 16, 2024 at 11:14:32AM +0530, Chandan Babu R wrote:
>> On Thu, Sep 05, 2024 at 06:12:29 PM +0530, Chandan Babu R wrote:
>> >>> To overcome this bug, this commit removes the check for log shutdown during
>> >>> high level transaction commit operation. The log items in the high level
>> >>> transaction will now be committed to the CIL despite the log being
>> >>> shutdown. This will allow the CIL processing logic (i.e. xlog_cil_push_work())
>> >>> to invoke xlog_cil_committed() as part of error handling. This will cause
>> >>> xfs_buf log item to to be unpinned and the corresponding inodes to be aborted
>> >>> and have their XFS_IFLUSHING flag cleared.
>> >>
>> >> I don't know exactly how the problem arose, but I can say for
>> >> certain that the proposed fix is not valid.  Removing that specific
>> >> log shutdown check re-opens a race condition which can causes on
>> >> disk corruption. The shutdown was specifically placed to close that
>> >> race - See commit 3c4cb76bce43 ("xfs: xfs_trans_commit() path must
>> >> check for log shutdown") for details.
>> >>
>> >> I have no idea what the right way to fix this is yet, but removing
>> >> the shutdown check isn't it...
>> >>
>> 
>> Commit 3c4cb76bce43 describes the following scenario,
>> 
>> 1. Filesystem is shutdown but the log remains operational.
>> 2. High-level transaction commit (i.e. xfs_trans_commit()) notices the fs
>>    shutdown. Hence it aborts the dirty log items. One of the log items being
>>    aborted is an inode log item.
>> 3. An inode cluster writeback is executed. Here, we come across the previously
>>    aborted inode log item. The inode log item is currently unpinned and
>>    dirty. Hence, the inode is included in the cluster buffer writeback.
>> 4. Cluster buffer IO completion tries to remove the inode log item from the
>>    AIL and hence trips over an assert statement since the log item was never
>>    on the AIL. This indicates that the inode was never written to the journal.
>> 
>> Hence the commit 3c4cb76bce43 will abort the transaction commit only when the
>> log has been shutdown.
>> 
>> With the log shutdown check removed, we can end up with the following cases
>> during high-level transaction commit operation,
>> 1. The filesystem is shutdown while the log remains operational.
>>    In this case, the log items are committed to the CIL where they are pinned
>>    before unlocking them.
>>    This should prevent the inode cluster writeback code
>>    from including such an inode for writeback since the corresponding log item
>>    is pinned. From here onwards, the normal flow of log items from the CIL to
>>    the AIL occurs after the contents of the log items are written to the
>>    journal and then later unpinned.
>>    The above logic holds true even without applying the "RFC patch" presented
>>    in the mail.
>>  
>> 2. The log is shutdown.
>>    As in the previous case, the log items are moved to the CIL where they are
>>    pinned before unlocking them. The pinning of the log items prevents
>>    the inode cluster writeback code from including the pinned inode in its
>>    writeback operation. These log items are then processed by
>>    xlog_cil_committed() which gets invoked as part of error handling by
>>    xlog_cil_push_work().
>
> It's more complex than that.
>
> 3. We get an error returned from xfs_defer_finish_noroll() or
> xfs_trans_run_precommits().
>

Commit b5f17bec1213a3ed2f4d79ad4c566e00cabe2a9b has the following,

   2. xfs_force_shutdown() is used in places to cause the current
   modification to be aborted via xfs_trans_commit() because it may be
   impractical or impossible to cancel the transaction directly, and
   hence xfs_trans_commit() must cancel transactions when
   xfs_is_shutdown() is true in this situation. But we can't do that
   because of #1.

I see that xfs_trans_run_precommits() and xfs_defer_finish_noroll() both call
xfs_force_shutdown() when they encounter an error. But these functions could
have percolated the error code to __xfs_trans_commit() and let
__xfs_trans_commit() deal with the scenario more gracefully rather than
checking for log shutdown. Can you please explain why this is
impractical or impossible?

-- 
Chandan
