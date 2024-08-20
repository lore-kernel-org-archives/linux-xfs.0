Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D0E2D627;
	Tue, 20 Aug 2024 08:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142737; cv=none; b=Ewn+n36h5R8r4ljCEjGxZAMxviqfsPf3rrnOlV09f4CUQsticsPKWFOcwRwsMqkA8/f/xeezPgWtsOLgfA1rulhURLP/LvESadM5tNT/TRVnNDNWxxY/pBmddP/P26L+2q4BQ1twSYCuT4UCyBYtxFKX0ad94ZjpwwLKMOAXRfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142737; c=relaxed/simple;
	bh=2deCrDuw0r01uQuwAdmcC6xhSLUlOEOsXXxICuJbXdY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=Lsg3vix0UJNNfHfeTHvL2pSVnT7PpGuGrwhNVfYHvCJWVNe6wWeNo4AwYvJutqkNDZektQwsykXdEDID0Mf5bi8MPt6abV1aFFpsimDMWEnP0gEl9eb/qHWV1eKBokO1PORZ0HOQU2n/5WV/UE1s47WtK9nNv9UFMSpWhmD9Gzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rdc1sli/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rdc1sli/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4570C4AF0B;
	Tue, 20 Aug 2024 08:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724142737;
	bh=2deCrDuw0r01uQuwAdmcC6xhSLUlOEOsXXxICuJbXdY=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=Rdc1sli/lqq59tFlvLT8M28+d80WOQmJtUrMWnP9p9gg8f7zBLUJ1AY6ini5vLmQN
	 5lwv5pI4MWSyt2eFbSFZR0d2XoPOQ1IYD72c/RPcBbJDxXjUgs8zEHIaA3wYh8sStc
	 oSDe5iZdbZ3OMUrSqET+P+V1VwmUZMQUN6Z8GZDwng7O+LNaSlgiT+03IjLqc8ZfLI
	 p4pqkzMInpeQ3S/94OL53ffXIUL8UWdRHT+4RRWFKxGROYAmjw1NNdkm2Xe+OeiWvK
	 irw864Ybnv9vQJzl39AzPLiGiIhE5zopqLgcUmXZjfFBdRSD+whXuz9VS9tXokUOPo
	 dQrT27UEiNHVQ==
References: <20240819005320.304211-1-wozizhi@huawei.com>
 <875xrvenzf.fsf@debian-BULLSEYE-live-builder-AMD64>
 <04118984-4c10-4d25-9547-0e3cd5d9fb03@huawei.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: djwong@kernel.org, dchinner@redhat.com, osandov@fb.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com
Subject: Re: [PATCH V4 0/2] Some bugfix for xfs fsmap
Date: Tue, 20 Aug 2024 13:57:46 +0530
In-reply-to: <04118984-4c10-4d25-9547-0e3cd5d9fb03@huawei.com>
Message-ID: <871q2jegs1.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 03:51:23 PM +0800, Zizhi Wo wrote:
> =E5=9C=A8 2024/8/20 13:53, Chandan Babu R =E5=86=99=E9=81=93:
>> On Mon, Aug 19, 2024 at 08:53:18 AM +0800, Zizhi Wo wrote:
>>> Changes since V3[1]:
>>>   - For the first patch, simply place the modification logic in the
>>>     xfs_fsmap_owner_to_rmap() function.
>>>   - For the second patch, more detailed comments were added and related
>>>     changes were made to the initialization of the end_daddr field.
>>>
>>> This patch set contains two patches to repair fsmap. Although they are =
both
>>> problems of missing query intervals, the root causes of the two are
>>> inconsistent, so two patches are proposed.
>>>
>>> Patch 1: The fix addresses the interval omission issue caused by the
>>> incorrect setting of "rm_owner" in the high_key during rmap queries. In
>>> this scenario, fsmap finds the record on the rmapbt, but due to the
>>> incorrect setting of the "rm_owner", the key of the record is larger th=
an
>>> the high_key, causing the query result to be incorrect. This issue is
>>> resolved by fixing the "rm_owner" setup logic.
>>>
>>> Patch 2: The fix addresses the interval omission issue caused by bit
>>> shifting during gap queries in fsmap. In this scenario, fsmap does not
>>> find the record on the rmapbt, so it needs to locate it by the gap of t=
he
>>> info->next_daddr and high_key address. However, due to the shift, the t=
wo
>>> are reduced to 0, so the query error is caused. The issue is resolved by
>>> introducing the "end_daddr" field in the xfs_getfsmap_info structure to
>>> store the high_key at the sector granularity.
>>>
>>> [1] https://lore.kernel.org/all/20240812011505.1414130-1-wozizhi@huawei=
.com/
>>>
>> The two patches in this series cause xfs_scrub to execute
>> indefinitely
>> immediately after xfs/556 is executed.
>> The fstest configuration used is provided below,
>> FSTYP=3Dxfs
>> TEST_DIR=3D/media/test
>> SCRATCH_MNT=3D/media/scratch
>> TEST_DEV=3D/dev/loop16
>> TEST_LOGDEV=3D/dev/loop13
>> TEST_RTDEV=3D/dev/loop12
>> TEST_FS_MOUNT_OPTS=3D"-o rtdev=3D/dev/loop12 -o logdev=3D/dev/loop13"
>> SCRATCH_DEV_POOL=3D"/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8
>> /dev/loop9 /dev/loop10 /dev/loop11"
>> MKFS_OPTIONS=3D"-f -m reflink=3D0,rmapbt=3D0, -d rtinherit=3D1 -lsize=3D=
1g"
>> SCRATCH_LOGDEV=3D/dev/loop15
>> SCRATCH_RTDEV=3D/dev/loop14
>> USE_EXTERNAL=3Dyes
>>=20
>
> Sorry, running xfs/556 with this configuration was successful in my
> environment, and my mkfs.xfs version is 6.8.0:
>
> xfs/556
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 fedora 6.11.0-rc3-00015-g1a9f212eb19f #42
> SMP PREEMPT_DYNAMIC Fri Aug 16 10:19:47 CST 2024
> VMIP          -- 192.168.240.11
> MKFS_OPTIONS  -- -f -f -m reflink=3D0,rmapbt=3D0 -d rtinherit=3D1 -l size=
=3D1g
> /dev/vde
> MOUNT_OPTIONS -- /dev/vde /tmp/scratch
>
> xfs/556 4s ...  5s
> Ran: xfs/556
> Passed all 1 tests
>
> I am not sure if it is because of the specific user mode tools or other
> environment configuration differences caused?
>

My Linux kernel is based on v6.11-rc4. The sources can be found at
https://github.com/chandanr/linux/commits/xfs-6.11-fixesC-without-jump-labe=
l-fixes/.

Please note that I have reverted commits modifying kernel/jump_label.c. This
is to work around
https://lore.kernel.org/linux-xfs/20240730033849.GH6352@frogsfrogsfrogs/.

Also, I am running xfsprogs v6.9.0. The sources can be found at
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?qt=3Drange&q=3D=
v6.9.0

--=20
Chandan
