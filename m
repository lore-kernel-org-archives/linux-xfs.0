Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795434266;
	b=wGBJ27iB1RvGA8VpeH9odOxM2sADlxeUqZk8ywQZk3brbt0BstMhQv7BHrxX4uFQM5mJ
	 3CkjWD6cxmKVYwys7CB/4Hp82+Fi3Z6GyJcN/J/7wMPabjupZIfJKNJ3VoPSikYNM97Wy
	 9ss3xyp13BxgPPAwsdXY2IrZxovEi463WMi6T4RhIuM06oIq8tS5uIG9VE831SUHFEtJg
	 JkotJXhjJdbcniKcwosKAHT4ZAoRk7WT05TSBalaBiWftLGTRcgrPJbKJxlJsyEbQW0Y+
	 QmL+LNQSDT6vYxS4pfS6YftXZuNGX9PbpLLGjPJHV8oGhO5oIuHL9a7K+2VlMUnU2SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795434266;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=KSPJpgxONTi5o9CF6eF74Es5Fdi/zpIXDquEucgCeQM=;
	b=m2hO0gU8m9lA6SVf6i/5vZTpbRUuWcUjnovJqm1Jrzjmk1AZl6MJX2WjxCDZO+EwBGmZ
	 UgcHb8h4Fm72Ia+TcpFXUYNDVUWmCvwtWC57LF0JBGBLwPLsXSa2B+sdj8xyEiVFrc71v
	 2OMgHq0qgumjVCQtxwrndnv1dcdRdVUqlh2ba7tJkppiDijh9DpNRE1AdcRH/9DDoGnNP
	 woWuqxr+ndeo76TU3GfAHmHd+5OvpAzwX51sr7Y1eYxWcrSv64L3GBT5QhAoAr5BzfaXv
	 KjNmj4zeZOyHh+uebyMZALxsltoHIFFAMh/cCVAjqBrIZ/Dxk8uh5I63yTlM4a+6rKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IE09jNRr;
	arc=none smtp.remote-ip=91.218.175.2
Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560CD606A31A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 11:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 560CD606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IE09jNRr
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jrk2Zp++qPc8yb5VkZ39l/dhx6zbgkBDUoTuzM7KDdU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795434262; v=1; x=1796039062;
 b=IE09jNRrYuJjiO12AN4fwvEZxwDgzU7rZslvtxsNlaYnrqcDEEEQ2vUuiZKD9oKFPDL2A/Mh
 h5dDdOb/SGgHrU3V5ruU+eBwgF64cUjpqGAWHQ+YDOP51SfGHaEWTFAzScYUYT9qAMn+szqDeEg
 xevhCcxbjHBVelCNjEmZ3KVI=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 99e3707534fd8d1c;
	Mon, 23 Nov 2026 11:44:22 +0000
X-Mizu-Trace-ID: 99e3707534fd8d1c
X-Migadu-Flow: FLOW_OUT
Message-ID: <1801b5bf-6cb2-40ee-b553-5bcba04875b4@linux.dev>
Date: Mon, 23 Nov 2026 11:44:19 +0000
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] xfs: add a per-filesystem switch to force atomic CoW
To: Wayne Gao <Wayne.Gao1@solidigm.com>, "cem@kernel.org" <cem@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <LV0PR10MB997684D5CA8A6AC037F6D1CD8AB9472@LV0PR10MB997684.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/26 15:47, Wayne Gao wrote:
> 

Christoph was proposing something similar here:

https://lore.kernel.org/linux-xfs/20250714131713.GA8742@lst.de/

Plesse check it. But it is for a difference purpose to what you propose, 
below. Actually, I am not sure on the motivation.

> 
> Hardware-capable devices normally prefer hardware atomic writes, making
> it difficult to exercise the software CoW path deterministically without
> changing file layouts or affecting ordinary writes.
> 
> Add a non-debug force_atomic_cow sysfs control for each filesystem.
> When enabled, route RWF_ATOMIC writes directly to the existing software
> CoW path regardless of hardware eligibility. Keep automatic selection
> as the default and reject enabling the control without software atomic
> write support.
> 
> Sample the setting once per I/O so in-flight requests retain their
> selected path. Preserve existing validation, completion and error
> handling, and leave non-atomic writes unchanged.
> 
> Report no separate optimized atomic write limit while CoW is forced
> and document the control's runtime scope and lifetime.
> 
> Validation: strict checkpatch passed. Linux kernel build and mounted-XFS
> runtime tests have not been run.
> 

Hmmm.. you are just describing what it does. Not why.

> Signed-off-by: Wayne Gao <wayne.gao1@solidigm.com>
> ---
> Hi Carlos and XFS developers,
> 
> I would appreciate feedback on this proposed interface.
> 
> The intended use is a controlled comparison of hardware-backed and
> software-backed RWF_ATOMIC writes on the same hardware, without having
> to construct misaligned mappings to trigger fallback.

Why do you want to compare?

> The existing
> DEBUG-only always_cow control also affects ordinary writes, which
> changes the workload being compared.
> 
> In particular, I would welcome feedback on:
> 
> 1. Whether a non-debug, per-filesystem sysfs control is appropriate,
>     or whether another existing testing mechanism should be extended.
> 
> 2. Whether reporting stx_atomic_write_unit_max_opt as zero while
>     software CoW is forced is the right behavior.
> 
> 3. The expected fstests coverage for this control. Intended coverage
>     includes off/on/off transitions on hardware-eligible writes,
>     per-filesystem isolation, unchanged non-atomic write routing,
>     rejection without software atomic write support, and concurrent
>     toggling with in-flight I/O.
> 
> Linux build, mounted-XFS testing and fstests coverage remain outstanding.
> This RFC is primarily requesting interface and semantic feedback, and
> does not make runtime performance claims.
> 
> Thanks,
> Wayne
> 
>   Documentation/ABI/testing/sysfs-fs-xfs | 42 ++++++++++++++++++++++++++
>   fs/xfs/xfs_file.c                      |  7 +++--
>   fs/xfs/xfs_iops.c                      |  4 +++
>   fs/xfs/xfs_mount.h                     |  1 +
>   fs/xfs/xfs_sysfs.c                     | 33 ++++++++++++++++++++
>   5 files changed, 84 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-fs-xfs b/Documentation/ABI/testing/sysfs-fs-xfs
> index 7da4de948..3d0c88df5 100644
> --- a/Documentation/ABI/testing/sysfs-fs-xfs
> +++ b/Documentation/ABI/testing/sysfs-fs-xfs
> @@ -35,3 +35,45 @@ Description:
>           outstanding transactions, including regrants due to
>           rolling transactions in bytes.
>   Users:         xfstests
> +
> +What:          /sys/fs/xfs/<disk>/force_atomic_cow
> +Date:          November 2026
> +Contact:       linux-xfs@vger.kernel.org
> +Description:
> +               Read-write boolean controlling the implementation of atomic
> +               writes. The default is 0, which prefers hardware atomic writes
> +               and falls back to software copy-on-write (CoW) when needed.
> +               Setting this to 1 forces RWF_ATOMIC writes to use software CoW,
> +               even when the request satisfies the hardware atomic write
> +               limits. Writes without RWF_ATOMIC are unaffected.
> +
> +               This control is available without CONFIG_XFS_DEBUG and is
> +               intended for testing and comparing the atomic write paths.
> +               Enabling it requires software atomic write support (currently
> +               the reflink feature); otherwise the write returns EOPNOTSUPP.
> +               Invalid boolean input returns EINVAL. Failed updates leave
> +               the setting unchanged.
> +
> +               The setting belongs to the filesystem instance and is shared
> +               by all mounts of that instance, including bind mounts. Each
> +               atomic write samples it once when selecting its I/O path.
> +               Changing it affects subsequent path selections, including
> +               writes through already open file descriptors, but does not
> +               wait for or redirect I/O that has already selected a path.
> +               Drain outstanding I/O before switching for comparisons that
> +               require an unambiguous boundary between the two modes.
> +
> +               Existing atomic write size, alignment and direct I/O
> +               requirements still apply. Forced CoW can fail for lack of
> +               space even when overwriting allocated data, and RWF_NOWAIT
> +               writes can return EAGAIN. Failures are not retried using
> +               hardware atomic writes.
> +
> +               While enabled, statx reports stx_atomic_write_unit_max_opt
> +               as 0, meaning that stx_atomic_write_unit_max is the optimized
> +               limit, with no separate hardware-optimized size range. The
> +               other atomic write limits are unchanged.
> +
> +               The setting survives remounts but is not stored on disk.
> +               A newly mounted filesystem instance starts with it disabled.
> +Users:         xfstests
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 8070a07e6..6f45b22e3 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -787,10 +787,11 @@ xfs_file_dio_write_atomic(
>       const struct iomap_ops     *dops;
> 
>       /*
> -        * HW offload should be faster, so try that first if it is already
> -        * known that the write length is not too large.
> +        * Prefer HW offload unless software CoW is forced or the write length
> +        * exceeds the hardware limit.
>        */
> -       if (ocount > xfs_inode_buftarg(ip)->bt_awu_max)
> +       if (READ_ONCE(ip->i_mount->m_force_atomic_cow) ||
> +           ocount > xfs_inode_buftarg(ip)->bt_awu_max)
>           dops = &xfs_atomic_write_cow_iomap_ops;
>       else
>           dops = &xfs_direct_write_iomap_ops;
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a84a4c1c3..c1720b2c9 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -664,6 +664,10 @@ xfs_get_atomic_write_max_opt(
>       const unsigned int hw_awu_max = xfs_inode_buftarg(ip)->bt_awu_max;
>       const xfs_fsize_t  hw_align_max = xfs_get_atomic_hw_write_align(ip);
> 
> +       /* Forced software writes have no separate hardware-optimized limit. */
> +       if (READ_ONCE(mp->m_force_atomic_cow))
> +               return 0;
> +
>       /* if the max is 1x block, then just keep behaviour that opt is 0 */
>       if (sw_awu_max <= mp->m_sb.sb_blocksize)
>           return 0;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index cbcfb89c6..71f574c21 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -239,6 +239,7 @@ typedef struct xfs_mount {
>                           /* low free space thresholds */
>       unsigned long              m_opstate;      /* dynamic state flags */
>       bool                       m_always_cow;
> +       bool                    m_force_atomic_cow;
>       bool                       m_fail_unmount;
>       bool                       m_finobt_nores; /* no per-AG finobt resv. */
>       bool                       m_update_sb;    /* sb needs update in mount */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 4a6a8c92c..b8fead80e 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -67,7 +67,40 @@ static const struct sysfs_ops xfs_sysfs_ops = {
>       .store = xfs_sysfs_object_store,
>   };
> 
> +static inline struct xfs_mount *to_xfs_mount(struct kobject *kobj)
> +{
> +       return container_of(to_kobj(kobj), struct xfs_mount, m_kobj);
> +}
> +
> +static ssize_t
> +force_atomic_cow_store(struct kobject *kobject, const char *buf, size_t count)
> +{
> +       struct xfs_mount        *mp = to_xfs_mount(kobject);
> +       bool            enable;
> +       int             ret;
> +
> +       ret = kstrtobool(buf, &enable);
> +       if (ret)
> +               return ret;
> +
> +       if (enable && !xfs_can_sw_atomic_write(mp))
> +               return -EOPNOTSUPP;
> +
> +       WRITE_ONCE(mp->m_force_atomic_cow, enable);
> +       return count;
> +}
> +
> +static ssize_t
> +force_atomic_cow_show(struct kobject *kobject, char *buf)
> +{
> +       struct xfs_mount        *mp = to_xfs_mount(kobject);
> +
> +       return sysfs_emit(buf, "%d\n", READ_ONCE(mp->m_force_atomic_cow));
> +}
> +XFS_SYSFS_ATTR_RW(force_atomic_cow);
> +
>   static struct attribute *xfs_mp_attrs[] = {
> +       ATTR_LIST(force_atomic_cow),
>       NULL,
>   };
>   ATTRIBUTE_GROUPS(xfs_mp);
> 
> base-commit: 5e7b6fe39324913f6416c854c6ed3a1793aaba8e
> --
> 2.54.0.windows.1
> 
> Wayne Gao
> Principle Storage Solution Architect
> wechat: 13636331364
> solidigm.com
> 
> 
> 
> CONFIDENTIALITY NOTICE: This email and any files attached may contain confidential information and may be restricted from disclosure by corporate confidentiality guidelines, or applicable state and federal law. It is intended solely for the use of the person or entity to whom the email was addressed. If you are not the intended recipient of this message, be advised that any dissemination, distribution, or use of the contents of this message is strictly prohibited. Please delete this email from your system if you are not the intended recipient.

