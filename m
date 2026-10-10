Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208431A683D
	for <linux-xfs@vger.kernel.org>; Sat, 10 Oct 2026 06:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791612594; cv=none; b=C8ySfMQ+rERmTNmFxUJlyOfgb9OrUrvfXPV0A/lg6cOZRjtl0SiurGbwOjmHTjFi4vjKI3TtwXnTWQ5HlOIVC6TMOFB7p5nqEkms9B7u1ysEkgb+7J/keN+forbSLaFGoCCX0tASJUi6+6d4GvT9mW1E6IWusEF9m+IM5d62Xk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791612594; c=relaxed/simple;
	bh=N0RJv5NcIWF7TBaIT+sTusYZKDh9ZxG6i0yS67Luhbo=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=KtRF/4zlK2/3MKMI5sBQ/R0uUNfR7I11SP9IRhvCaTCucakTGdLWDLetLldj61TiCR2haFF7X0ZO02jusD+gu/wMkdhbpVU1UsRWTxHuA/psddwQHxYSmLxUJGAz6bxh1o1ke45XXGK2qOXhXaeoKjOzAw4PgAlY/xW3U7uYBKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=v/q/xWC5; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=TTR0mWTL; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="v/q/xWC5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TTR0mWTL"
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 26FC01400141
	for <linux-xfs@vger.kernel.org>; Sat, 10 Oct 2026 02:09:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Sat, 10 Oct 2026 02:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1791612591;
	 x=1791698991; bh=v0OCdXABBpjfYNQfYPoDwdhjpRiOyZQCTyXfCu91BOQ=; b=
	v/q/xWC5Afef+vAEIbHNXTvIX1FlpvZelAq6pZJtUZ8d7BPPkWvyGF2wHEkFZirq
	5GdEuZL/o401HoGX/6ON/S8SdnL9PlqSWOel8ANHEs2DFEfk6DbXCdgiVEIDMd5+
	b3AIOCg2sjxkNHxAiAp0apEYmqUBavJxHK6P28m9MsUYJroi2AEaaoEjeiNerZs8
	WTXAHHQASPrbafaa5m6XL/g/S3BeZeZ08JgID9ntxb9V5bWixfaYQmiC8o4cSYkU
	r0vlL+e4w179ohFXwcYKBoCICAhkRXaVnqSUgnt/kA/P5Csx+GIM1lJpCdIuI8tn
	J5ItSB3pHds8cLlz0hw8yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791612591; x=
	1791698991; bh=v0OCdXABBpjfYNQfYPoDwdhjpRiOyZQCTyXfCu91BOQ=; b=T
	TR0mWTLoK5KPM2xujV/UeKpcbiqOjOw9R9Z5xfMdjgyPiKTJt6UTjimd2J1dpKTV
	WgjrGFSI2KeOGsk1d9IdqXRe0rIvncypEwXLX7GFQIKT6vHwVay7OVhCmcDPQiaf
	qF6CMO9ZKxPdDLHqUfgWd2jc3JBD8neaoo1NSeVOwIW1DefBqzaj32swUOWTaqoO
	Y50WYPaBT1+PNIJ63YV74POoYScieUlX7m9LkvMOuijNF+gwbadwbH+MPhOXurTv
	C3jR7HFh+F3O1xy83Wc3zN70jWg1ZNbll9S+OI3P3KLhz2XGT7LeRTFDZpC6meA+
	agbuNuaFgBaAQkyIsUQnw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=sandeen.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791612591; d=sandeen.net;
	mf=PHNhbmRlZW5Ac2FuZGVlbi5uZXQ+;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:Aoo2EqS8JWiCyfbjngfH9H3LL4BeLpmRbrj1CYw7mPWey88
	GXF/HEhJvijbrL1gi5/rzW8f1BY+W832/LqoeGv+eBbnzPHw9PtPySHedn05Kqnk
	WYosAEppZjj4CmaYOeaiCIf8d7b4O9kGwOMgvFkEer0zHyYSdJ4lzhjGgDXgfv2j
	SWKFqxpgvHZwn5PkuYHLr1cPvam3tY+wQX1PdcvkrP9FpHHMG9LvmOIOzCJrE3XN
	pycgpwzNTsiWMXFnWKUdJq6bJbvg76gyMebmsMmY8roTGWZR/CqudbiqQVpV3sde
	j3z0+/ZuvqWlOVtlY9gLongoZ0dgcmpmSmfDbZw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:5D3GuzzY/Ga/aHgr8i+AHrBsRC7dmPmnQUk7VO4/EH0=:N0RJv5NcIWF7TBaIT+sTusYZKDh9ZxG6i0yS67Luhbo=;
X-ME-Sender: <xms:rtbJapUW4tnAmTReO4MI35_d56ceVGRutp32HrWKWcr744bqIygXnw>
    <xme:rtbJatS8WuTU_z0qli6xRzzdgJlk0PZhgGeAM-bX6EISoS1DssimcLkv7zPaJW1M8
    7-CQYO_xjGzV30f8tJMm9vskbkOFTI_4nvbDgX0Xbltwnd7ycEXg9xA>
X-ME-Received: <xmr:rtbJavM4fPQszzIi4z1smaL5LaxcNk3Y509js7l_HxuDBSb9sFpJ55Au6S0YNddPrPkXcO67VlOFYqVSURfJj9WShLgAr8itJQw>
X-ME-Proxy-Cause: dmFkZTEh4tdBqCf/HDilEP09IzWc9ANaAFd0JLwMFT6Fyxd/1M8Kp4JJkVUB4JPq62Q4pR
    9mWP7nvTSiGL3bPStu27wfb1rxdHmxhtJlwQhS/O8z1etILOBLddmVurl17Xyb4s6dQP6N
    iUlc3AZ/IolXiz5c8fT9zAnaF3DhCvi00S3Os9edJuLvIzIaJytSo201MIAlKJB8wWUAe8
    xBC/8TPuXpWiYO1NpbD/PX4OtMf/Aq9DUpmK/BnVHflxi3BAU/bz1wsN1uMjiCqAf0ZKix
    nQ9wi2R/dyUoWpynSkQs9A/8xRq0aupX8HdRUrGV6Qz/JfkRWxzIFs7PdMQGkWavLQQGNW
    XwU/ptKly+Lmb5HKIZFrRSpsr/ocKbK0JvFriAru29mwtXz/1rCFt0OaHfoQaP8uEmZXAB
    Anm/yOy7mCdmQLKIzf2kpjbbW0VN72yNUOdyRjBs33dsLyscZcWvFtIQ2w+80x/rq9B1IE
    mTVy60BRqlchKCxxgN+lulgf/re3499miAUrhd7Pq4XGrdtkYkwty2/PxSGd5uJKi+EcMs
    36mrlQc7f2hY95EbIwU/bgXEcH7lz7sS7vksV8/BjQsTE7LRSdzEnJcZavfdWT7NrJGHBN
    LCwm3dhNwzNecIbezSuAjqe9NptjZPlfBJP6NxqV6NoZKUf+Ey+fghVB/Ryw
X-ME-Proxy: <xmx:rtbJajQBANImVjor0FCZSj6qgaln1zsb4xOAPKw0OHFBZwzVxGOTag>
    <xmx:rtbJalgKewUDJgdHdXMuKcwTrsdPTXrAi_iQTwRZuiw_8ut2BO6xTw>
    <xmx:rtbJak-W_kiodayyywWJq1Jk9AWh5m-Iq1h5_aXjjb8lBJppDAAj0A>
    <xmx:rtbJakFwTfBig2KIMdW9oGXRBHIwEllvaBacjNLcycLDQrQa4a3Ezw>
    <xmx:r9bJaoeP7N5MvkRtduIA80Yji9aJsvdBkOqS6y51oToj91YRV4vKN4Jd>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 10 Oct 2026 02:09:50 -0400 (EDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Eric Sandeen <sandeen@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs: add regression test for swapext reflux
Date: Sat, 10 Oct 2026 01:09:39 -0500
Message-Id: <101C0648-521A-4ADE-97A2-E03C7A43E4EF@sandeen.net>
References: <20261009221130.GT1615495@frogsfrogsfrogs>
Cc: Lang Zorro <zlang@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Norbert Szetei <norbert@doyensec.com>, linux-xfs@vger.kernel.org,
 Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20261009221130.GT1615495@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: iPhone Mail (24A446)



> On Oct 9, 2026, at 17:11, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> =EF=BB=BFOn Fri, Oct 09, 2026 at 11:13:53AM -0500, Eric Sandeen wrote:
>>> On 10/7/26 12:05 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>=20
>>> This is a regression test for a bug that Norbert Szetei reported in the
>>> XFS swapext ioctl.  I've ported his reproducer program to fstests so
>>> that everyone can run it.
>>=20
>> A couple things I notice -
>>=20
>> 1) this still requires EXCHRANGE?
>> 2) if the EXCHRANGE ioctl fails with EOPNOTSUPP the test passes silently
>=20
> Huh?  Oh, the reproducer actually requires it.  Ok, I'll add a _require
> clause here.

Should it test that exchrange is fully available and mkfs scratch with that o=
ption if so?

>> 3) su $qa_user -c "$here/src/xfs-swapext-reflink $userdir1 $rootdir/peer1=
"
>>   requires $qa_user to be able to traverse to $here/src/xfs-swapext-refli=
nk and if
>>   it can't, the test fails oddly
>>=20
>> For 3) I think just dropping the $here might fix it?
>>=20
>> su $qa_user -c "./src/xfs-swapext-reflink $userdir1 $rootdir/peer1"
>=20
> Yeah.  =46rom commit b7cecbea22ba6d ("fstests: Add path $here before
> src/<file>"):
>=20
>    [Eryu: some tests run src/<file> as regular user, don't add $here
>    prefix in such case, as a regular user may have no search permission
>    on $here]
>=20
> <grumble> Will fix.
>=20
> --D
>=20
>> -Eric
>>=20
>>> Cc: Norbert Szetei <norbert@doyensec.com>
>>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
>>> ---
>>> src/Makefile              |    2
>>> src/xfs-swapext-reflink.c |  230 +++++++++++++++++++++++++++++++++++++++=
++++++
>>> tests/xfs/1939            |   69 ++++++++++++++
>>> tests/xfs/1939.out        |    2
>>> 4 files changed, 302 insertions(+), 1 deletion(-)
>>> create mode 100644 src/xfs-swapext-reflink.c
>>> create mode 100755 tests/xfs/1939
>>> create mode 100644 tests/xfs/1939.out
>>>=20
>>> diff --git a/src/Makefile b/src/Makefile
>>> index 211b16a832ad5d..eaf0621fc4b876 100644
>>> --- a/src/Makefile
>>> +++ b/src/Makefile
>>> @@ -37,7 +37,7 @@ LINUX_TARGETS =3D xfsctl bstat t_mtab getdevicesize pr=
eallo_rw_pattern_reader \
>>>    detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
>>>    uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignmen=
t \
>>>    rw_hint btrfs_ioctl refluxfs xfs-exchange-to-eof \
>>> -    xfs-exchange-to-dirty-eof
>>> +    xfs-exchange-to-dirty-eof xfs-swapext-reflink
>>>=20
>>> EXTRA_EXECS =3D dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
>>>          btrfs_crc32c_forged_name.py popdir.pl popattr.py \
>>> diff --git a/src/xfs-swapext-reflink.c b/src/xfs-swapext-reflink.c
>>> new file mode 100644
>>> index 00000000000000..e2a240d5a0af91
>>> --- /dev/null
>>> +++ b/src/xfs-swapext-reflink.c
>>> @@ -0,0 +1,230 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +
>>> +// Trick swapext into screwing up the file reflink flags after data exc=
hange
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <unistd.h>
>>> +#include <fcntl.h>
>>> +#include <sys/ioctl.h>
>>> +#include <sys/stat.h>
>>> +#include <sys/vfs.h>
>>> +#include <linux/fs.h>
>>> +#include <linux/fiemap.h>
>>> +
>>> +#ifndef FICLONERANGE
>>> +#define FICLONERANGE _IOW(0x94, 13, struct file_clone_range)
>>> +#endif
>>> +
>>> +#ifndef XFS_EXCHANGE_RANGE_TO_EOF
>>> +struct xfs_exchange_range {
>>> +    __s32        file1_fd;
>>> +    __u32        pad;
>>> +    __u64        file1_offset;
>>> +    __u64        file2_offset;
>>> +    __u64        length;
>>> +    __u64        flags;
>>> +};
>>> +#define XFS_IOC_EXCHANGE_RANGE        _IOW('X', 129, struct xfs_exchang=
e_range)
>>> +#define XFS_EXCHANGE_RANGE_TO_EOF    (1ULL << 0)
>>> +#endif
>>> +
>>> +#ifndef XFS_IOC_SWAPEXT
>>> +typedef struct xfs_bstime {
>>> +    long        tv_sec;
>>> +    __s32        tv_nsec;
>>> +} xfs_bstime_t;
>>> +
>>> +struct xfs_bstat {
>>> +    __u64        bs_ino;
>>> +    __u16        bs_mode;
>>> +    __u16        bs_nlink;
>>> +    __u32        bs_uid;
>>> +    __u32        bs_gid;
>>> +    __u32        bs_rdev;
>>> +    __s32        bs_blksize;
>>> +    __s64        bs_size;
>>> +    xfs_bstime_t    bs_atime;
>>> +    xfs_bstime_t    bs_mtime;
>>> +    xfs_bstime_t    bs_ctime;
>>> +    __s64        bs_blocks;
>>> +    __u32        bs_xflags;
>>> +    __s32        bs_extsize;
>>> +    __s32        bs_extents;
>>> +    __u32        bs_gen;
>>> +    __u16        bs_projid_lo;
>>> +    __u16        bs_forkoff;
>>> +    __u16        bs_projid_hi;
>>> +    __u16        bs_sick;
>>> +    __u16        bs_checked;
>>> +    unsigned char    bs_pad[2];
>>> +    __u32        bs_cowextsize;
>>> +    __u32        bs_dmevmask;
>>> +    __u16        bs_dmstate;
>>> +    __u16        bs_aextents;
>>> +};
>>> +
>>> +struct xfs_swapext {
>>> +    __s64            sx_version;
>>> +#define XFS_SX_VERSION        0
>>> +    __s64            sx_fdtarget;
>>> +    __s64            sx_fdtmp;
>>> +    __s64            sx_offset;
>>> +    __s64            sx_length;
>>> +    char            sx_pad[16];
>>> +    struct xfs_bstat    sx_stat;
>>> +};
>>> +#define XFS_IOC_SWAPEXT        _IOWR('X', 109, struct xfs_swapext)
>>> +#endif
>>> +
>>> +static unsigned long blksz;
>>> +static int peer, f1;
>>> +
>>> +static unsigned long long phys(int fd, unsigned long long off)
>>> +{
>>> +    struct { struct fiemap f; struct fiemap_extent e[1]; } q;
>>> +
>>> +    memset(&q, 0, sizeof q);
>>> +    q.f.fm_start =3D off;
>>> +    q.f.fm_length =3D blksz;
>>> +    q.f.fm_extent_count =3D 1;
>>> +    if (ioctl(fd, FS_IOC_FIEMAP, &q.f) || q.f.fm_mapped_extents < 1)
>>> +        return 0;
>>> +    return (q.e[0].fe_physical + (off - q.e[0].fe_logical)) / blksz;
>>> +}
>>> +
>>> +static void show(const char *tag)
>>> +{
>>> +    struct stat st;
>>> +    int i;
>>> +
>>> +    fstat(f1, &st);
>>> +    printf("%-26s peer [%llu]   file1 size %5lld  [", tag, phys(peer, 0=
),
>>> +           (long long)st.st_size);
>>> +    for (i =3D 0; i < 3; i++)
>>> +        printf("%llu%s", phys(f1, (unsigned long long)i * blksz),
>>> +               i =3D=3D 2 ? "]\n" : "] [");
>>> +}
>>> +
>>> +static int mkfile(const char *name, char fill, int blocks)
>>> +{
>>> +    char *buf;
>>> +    int fd;
>>> +
>>> +    unlink(name);
>>> +    fd =3D open(name, O_RDWR | O_CREAT | O_EXCL, 0600);
>>> +    if (fd < 0)
>>> +        return fprintf(stderr, "open %s: %m\n", name), -1;
>>> +    buf =3D malloc(blocks * blksz);
>>> +    memset(buf, fill, blocks * blksz);
>>> +    if (pwrite(fd, buf, blocks * blksz, 0) !=3D (ssize_t)(blocks * blks=
z))
>>> +        return fprintf(stderr, "pwrite %s: %m\n", name), -1;
>>> +    free(buf);
>>> +    fsync(fd);
>>> +    return fd;
>>> +}
>>> +
>>> +int main(int argc, char *argv[])
>>> +{
>>> +    struct xfs_exchange_range xr;
>>> +    struct file_clone_range cr;
>>> +    struct xfs_swapext sx;
>>> +    char before[65536], after[65536], *buf;
>>> +    struct statfs sfs;
>>> +    struct stat st;
>>> +    int d1, d2;
>>> +
>>> +    if (argc !=3D 3) {
>>> +        fprintf(stderr, "Usage: $0 dir path_to_peer\n");
>>> +        return 2;
>>> +    }
>>> +
>>> +    if (chdir(argv[1]))
>>> +        return perror(argv[1]), 2;
>>> +
>>> +    if (statfs(".", &sfs))
>>> +        return fprintf(stderr, "statfs: %m\n"), 2;
>>> +    blksz =3D sfs.f_bsize;
>>> +
>>> +    peer =3D open(argv[2], O_RDONLY);
>>> +    if (peer < 0)
>>> +        return fprintf(stderr, "open peer: %m\n"), 2;
>>> +    fstat(peer, &st);
>>> +    printf("peer uid %u mode %04o size %lld, block size %lu\n\n",
>>> +           st.st_uid, st.st_mode & 07777, (long long)st.st_size, blksz)=
;
>>> +    if (pread(peer, before, blksz, 0) !=3D (ssize_t)blksz)
>>> +        return fprintf(stderr, "read peer: %m\n"), 2;
>>> +    syncfs(peer);    /* so FIEMAP reports peer's real block */
>>> +
>>> +    f1 =3D mkfile("file1", 'A', 3);
>>> +    d1 =3D mkfile("donor1", 'B', 1);
>>> +    d2 =3D mkfile("donor2", 'C', 1);
>>> +    if (f1 < 0 || d1 < 0 || d2 < 0)
>>> +        return 2;
>>> +    show("start");
>>> +
>>> +    /* 1. share peer's block into the middle of file1 */
>>> +    cr =3D (struct file_clone_range){ .src_fd =3D peer, .src_offset =3D=
 0,
>>> +                    .src_length =3D blksz,
>>> +                    .dest_offset =3D blksz };
>>> +    if (ioctl(f1, FICLONERANGE, &cr))
>>> +        return fprintf(stderr, "FICLONERANGE: %m\n"), 2;
>>> +    show("1 FICLONERANGE");
>>> +
>>> +    /*
>>> +     * 2. exchange file1's last block against the whole of donor1 with
>>> +     * TO_EOF.  The sizes are exchanged too, so file1 claims one block
>>> +     * while still owning three.  file2_offset is block 2, so this exch=
ange
>>> +     * cannot clear a reflink flag.
>>> +     */
>>> +    xr =3D (struct xfs_exchange_range){ .file1_fd =3D d1, .file1_offset=
 =3D 0,
>>> +                      .file2_offset =3D 2 * blksz,
>>> +                      .length =3D 0,
>>> +                      .flags =3D XFS_EXCHANGE_RANGE_TO_EOF };
>>> +    if (ioctl(f1, XFS_IOC_EXCHANGE_RANGE, &xr))
>>> +        return fprintf(stderr, "EXCHANGE_RANGE TO_EOF: %m\n"), 2;
>>> +    show("2 EXCHANGE_RANGE TO_EOF");
>>> +
>>> +    /*
>>> +     * 3. XFS_IOC_SWAPEXT with file1 as the target.  sx_offset is 0 and=

>>> +     * sx_length equals both inodes' i_disk_size, so the "Verify all da=
ta
>>> +     * are being swapped" test passes.  xfs_swap_extent_rmap() then bou=
nds
>>> +     * its remap loop with XFS_B_TO_FSB(mp, i_size_read(VFS_I(ip))), wh=
ich
>>> +     * is one block, so file1's two mappings above its size are left in=

>>> +     * place -- and the reflink flags are swapped anyway, clearing file=
1's.
>>> +     */
>>> +    fsync(f1);
>>> +    fsync(d2);
>>> +    if (fstat(f1, &st))
>>> +        return fprintf(stderr, "fstat file1: %m\n"), 2;
>>> +    memset(&sx, 0, sizeof sx);
>>> +    sx.sx_version        =3D XFS_SX_VERSION;
>>> +    sx.sx_fdtarget        =3D f1;
>>> +    sx.sx_fdtmp        =3D d2;
>>> +    sx.sx_offset        =3D 0;
>>> +    sx.sx_length        =3D st.st_size;
>>> +    sx.sx_stat.bs_mtime.tv_sec  =3D st.st_mtim.tv_sec;
>>> +    sx.sx_stat.bs_mtime.tv_nsec =3D st.st_mtim.tv_nsec;
>>> +    sx.sx_stat.bs_ctime.tv_sec  =3D st.st_ctim.tv_sec;
>>> +    sx.sx_stat.bs_ctime.tv_nsec =3D st.st_ctim.tv_nsec;
>>> +    if (ioctl(f1, XFS_IOC_SWAPEXT, &sx))
>>> +        return fprintf(stderr, "SWAPEXT: %m\n"), 2;
>>> +    show("3 SWAPEXT");
>>> +
>>> +    /* 4. write to the block file1 still shares with peer */
>>> +    buf =3D malloc(blksz);
>>> +    memset(buf, 'X', blksz);
>>> +    if (pwrite(f1, buf, blksz, blksz) !=3D (ssize_t)blksz)
>>> +        return fprintf(stderr, "pwrite: %m\n"), 2;
>>> +    fsync(f1);
>>> +    show("4 pwrite(file1, 4096)");
>>> +
>>> +    posix_fadvise(peer, 0, 0, POSIX_FADV_DONTNEED);
>>> +    if (pread(peer, after, blksz, 0) !=3D (ssize_t)blksz)
>>> +        return fprintf(stderr, "re-read peer: %m\n"), 2;
>>> +    printf("\npeer first byte %c -> %c   %s\n", before[0], after[0],
>>> +           memcmp(before, after, blksz) ? "PEER REWRITTEN" : "peer inta=
ct");
>>> +    return memcmp(before, after, blksz) ? 0 : 1;
>>> +}
>>> +
>>> +
>>> diff --git a/tests/xfs/1939 b/tests/xfs/1939
>>> new file mode 100755
>>> index 00000000000000..b08ea09e977628
>>> --- /dev/null
>>> +++ b/tests/xfs/1939
>>> @@ -0,0 +1,69 @@
>>> +#! /bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +# Copyright (c) 2026 Oracle.  All Rights Reserved.
>>> +#
>>> +# FS QA Test No. 1939
>>> +#
>>> +# Regression test for an swapext bug which unintentionally results in f=
iles
>>> +# that share data blocks but don't have the reflink flag set.  This ena=
bles
>>> +# attackers to rewrite shared blocks to gain root privileges, similar t=
o
>>> +# refluxfs.
>>> +. ./common/preamble
>>> +_begin_fstest auto quick swapext
>>> +
>>> +. ./common/filter
>>> +. ./common/reflink
>>> +
>>> +_require_test_program "xfs-swapext-reflink"
>>> +_require_user fsgqa
>>> +_require_group fsgqa
>>> +_require_scratch_reflink
>>> +_require_xfs_scratch_rmapbt
>>> +_require_cp_reflink
>>> +
>>> +_fixed_by_fs_commit xfs XXXXXXXXXXXXXX \
>>> +    "xfs: stop exchanging reflink flags when exchanging mappings"
>>> +
>>> +_scratch_mkfs >> $seqres.full
>>> +_scratch_mount
>>> +
>>> +rootdir=3D$SCRATCH_MNT/root
>>> +userdir1=3D$SCRATCH_MNT/user1
>>> +blksz=3D$(_get_file_block_size $SCRATCH_MNT)
>>> +
>>> +# Fill $mnt/peer with "P", run reproducer program
>>> +mkdir -p $rootdir $userdir1
>>> +$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer.copy >> $seq=
res.full
>>> +$XFS_IO_PROG -f -c "pwrite -S 0x50 0 $blksz" $rootdir/peer1 >> $seqres.=
full
>>> +sync
>>> +
>>> +chown $qa_user:$qa_group $userdir1
>>> +chmod +r $rootdir/peer1
>>> +
>>> +_su $qa_user -c "$here/src/xfs-swapext-reflink $userdir1 $rootdir/peer1=
" &> $tmp.out1
>>> +
>>> +echo "Errors from reproducer:" >> $seqres.full
>>> +cat $tmp.out1 >> $seqres.full
>>> +
>>> +# Check for file corruption
>>> +grep -q REWRITTEN $tmp.out1 && \
>>> +    echo "$rootdir/peer1 rewritten, filesystem corrupt!"
>>> +
>>> +cmp -s $rootdir/peer.copy $rootdir/peer1 || \
>>> +    echo "$rootdir/peer1 changed since its snapshot, filesystem corrupt=
!"
>>> +
>>> +# Check reflink flags
>>> +_scratch_unmount
>>> +_scratch_xfs_db \
>>> +    -c "path /user1/file1" -c 'print' \
>>> +    | grep v3.reflink
>>> +_scratch_mount
>>> +
>>> +# Check for file corruption now that we've blown away all caches
>>> +grep -q REWRITTEN $tmp.out1 && \
>>> +    echo "$rootdir/peer1 rewritten, filesystem corrupt!"
>>> +
>>> +cmp -s $rootdir/peer.copy $rootdir/peer1 || \
>>> +    echo "$rootdir/peer1 changed since its snapshot, filesystem corrupt=
!"
>>> +
>>> +_exit 0
>>> diff --git a/tests/xfs/1939.out b/tests/xfs/1939.out
>>> new file mode 100644
>>> index 00000000000000..ad52293f986ac6
>>> --- /dev/null
>>> +++ b/tests/xfs/1939.out
>>> @@ -0,0 +1,2 @@
>>> +QA output created by 1939
>>> +v3.reflink =3D 1
>>>=20
>>=20
>=20

