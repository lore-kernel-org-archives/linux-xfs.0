Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9575C14A4EA;
	Tue, 20 Aug 2024 05:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724133401; cv=none; b=HerE78h8194BZCF7OXsbK0qODhyaWtEm3YcK2fVTrLEubDLUfYuYF8K2vagD5frE+9dPZ6BBa1yLNQ5jtQoZDY0hKgS1IPYikiS42VqjzP7PcVk89xmFM3mPAPJyjeW1tTs/psOreM4Hlbq5x1BK/deEHgiA1BtBJtxnKSmHqLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724133401; c=relaxed/simple;
	bh=lP3hzyVguaIzqFqbTUvQOeicQQ9iJEqMwGxCD6XIZ/g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=Wtmo9REThzcTuvv0w2yI3OZLOl7HpGzNGUHkQq4pGPPTRoVOreqgVJttNY+ZRgwZ/A5gouIhMmwWtCJk/VInu3BRiqsxLf7zRfVm9YNSSSwYjaJJlJVbu42GBCU1d4PEqV+v6wG8N66RmwoSLEjQnB3a4O/oR/efyRuc2D6oiDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jm4di160; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jm4di160"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3405AC4AF11;
	Tue, 20 Aug 2024 05:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724133401;
	bh=lP3hzyVguaIzqFqbTUvQOeicQQ9iJEqMwGxCD6XIZ/g=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=jm4di1606d32XU/ZoORpfK0hif1AsUnJhziBeLnbQP7WHEtMo+BR53SxMxyTQSDXq
	 EyAez7TpXwi0MlDeudhQ3idpFPZia7ZghH55sbbKpyxAGpi3Pvg2FmDPZ6Igacs0vA
	 tQHQAyDyCdTU4FwGgnhfhSqvixfU3HeSpGp8br+fVCB6E31SEyV9XUfh3vP8C8Nup5
	 YTwW7i2U7+2e2vt6yPLj43EozHqW4Dgu2Xx39mUu+tuza2W4as/noj/bQY/zXjJb3M
	 fMYhjoOtP+1irstN/jyDryUVpt7CRYOrL80N07/uLsHjBTypZEdMjQwowWqLvnQXO/
	 YNjxvfNMoFhHw==
References: <20240819005320.304211-1-wozizhi@huawei.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: djwong@kernel.org, dchinner@redhat.com, osandov@fb.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V4 0/2] Some bugfix for xfs fsmap
Date: Tue, 20 Aug 2024 11:23:20 +0530
In-reply-to: <20240819005320.304211-1-wozizhi@huawei.com>
Message-ID: <875xrvenzf.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 19, 2024 at 08:53:18 AM +0800, Zizhi Wo wrote:
> Changes since V3[1]:
>  - For the first patch, simply place the modification logic in the
>    xfs_fsmap_owner_to_rmap() function.
>  - For the second patch, more detailed comments were added and related
>    changes were made to the initialization of the end_daddr field.
>
> This patch set contains two patches to repair fsmap. Although they are both
> problems of missing query intervals, the root causes of the two are
> inconsistent, so two patches are proposed.
>
> Patch 1: The fix addresses the interval omission issue caused by the
> incorrect setting of "rm_owner" in the high_key during rmap queries. In
> this scenario, fsmap finds the record on the rmapbt, but due to the
> incorrect setting of the "rm_owner", the key of the record is larger than
> the high_key, causing the query result to be incorrect. This issue is
> resolved by fixing the "rm_owner" setup logic.
>
> Patch 2: The fix addresses the interval omission issue caused by bit
> shifting during gap queries in fsmap. In this scenario, fsmap does not
> find the record on the rmapbt, so it needs to locate it by the gap of the
> info->next_daddr and high_key address. However, due to the shift, the two
> are reduced to 0, so the query error is caused. The issue is resolved by
> introducing the "end_daddr" field in the xfs_getfsmap_info structure to
> store the high_key at the sector granularity.
>
> [1] https://lore.kernel.org/all/20240812011505.1414130-1-wozizhi@huawei.com/
>

The two patches in this series cause xfs_scrub to execute indefinitely
immediately after xfs/556 is executed.

The fstest configuration used is provided below,

FSTYP=xfs
TEST_DIR=/media/test
SCRATCH_MNT=/media/scratch
TEST_DEV=/dev/loop16
TEST_LOGDEV=/dev/loop13
TEST_RTDEV=/dev/loop12
TEST_FS_MOUNT_OPTS="-o rtdev=/dev/loop12 -o logdev=/dev/loop13"
SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11"
MKFS_OPTIONS="-f -m reflink=0,rmapbt=0, -d rtinherit=1 -lsize=1g"
SCRATCH_LOGDEV=/dev/loop15
SCRATCH_RTDEV=/dev/loop14
USE_EXTERNAL=yes

-- 
Chandan
