Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465728;
	b=MxomSiT/Nl1U3b2h9CbbkDUCjZRNVMSYUYS8lO1KI861jm+fbCUgmMtbSSeUJ9jY8khL
	 IBfUI6W1z10aZoLcZlfAVBw7I5WfgpIx34BUC2ZyvOKgO8GJamCb4VMySjZprm8kOrvjr
	 X4gbd6gbKxCsRM5Mwnk2BqsIK50qwxcHEP/mDlMtDNa4Wu28F4jZHLRt8Xp/ItPmseS/i
	 qseDCyUlrvrH2klRkYg4ZIZBuodWXff7bZI67GevzO6ix71fW95qcR9eoYyg4zJct+GEZ
	 URwTm+YDFM6HNdYNi+HMNEqPemi3MWBk66eIQb2m1FCiDSs2KMyBmRo9uRtqHdmzH9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465728;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X85kjBINdVfaDrnJk8BmLgtcQVuPyF+arFPTAr2kSiA=;
	b=IjE8ZrM0zibWhFCGu5OhDK+VbkGpXTcaobBqZFmQPKNXddMCTlMOeDPhAoobfBn7A7cp
	 zPMc61sy3UKc7o4pXbX8F/yxnNqqSCzhcN/okn3FQNwBIEvtV0VvJhCVzNefJ2nGp1Mon
	 Rf7WnbYWmhXhJftp7EnP11vRvSSPzAp4PkNNCMbNR658uUyvvOag3K44UmrWondSVjfmw
	 GB5IC6a0WkcvNsefKVTH87Ue7JKGEu9ffxqdSipnPBC9dnNrMC/NzurJBSmRYvfv3CSlF
	 MpxlAI+qAIqJ+DboC1RE+jnk6gHYn7Xso8X8RtXfS4bhXfI5usE9GBZb/Fh+03EAY1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKugfJKk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA79606A330;
	Tue, 20 Oct 2026 03:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UKugfJKk
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465727;
	b=01BAHbIRQjkTfxrofa+wG5FNmcfKQhKwnTwCWsLFdrpJTO2KAQfrpJJahYlvRtzEfdhA
	 3UaBRqc4OCCvmWphSexTOn3VBPC5peeUGhJ3emW04HvWWcoI5a6Musg1ubEaqt/RZjrxy
	 mDB/8Fd6D2EJlgH9EZmmvLwszzkDjigf/sYpa6NT85OI1C57hjVHostqpuRXcawdtJJPo
	 aGxMvZzZ7rZkoMAtSSzOWbp5YzH8d5gK7K0BKb75jfPG90YiFmK4ozNl9OIZNt5i2Vj/X
	 wmYpw2L5QFbB5HEtjcF4zITxLiOwrP/+3namI7yZTrbZgLcbljGrlfVhe0hLpJZVGvw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465727;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X85kjBINdVfaDrnJk8BmLgtcQVuPyF+arFPTAr2kSiA=;
	b=oU9ZLgkJzWxHT4njS3hb1Bvhe+liCzrpCEOhq6FWljvkZWQdklPe+I3D71rc/2D6tQqi
	 AiR9GuEE2WvIpi4dGqeitmojEqLKoABnY+VWAR/uxlYiSs5k7ryaH2C1e+EXT4UryHs61
	 6+YGUMpH5PnELgyok8/i0mUlqzhuGcVVdP8u5qhW/QE5Wl5ILHj4YQAfkzD4VVXYQWpUa
	 eGZghf/O2bCe6FSL6OlK2MR47IbTQ74s4f1/sG1QKHTd2Uoi2GY7Rcsg28fL99SG2+Ndy
	 +nvIhicdPWLBTRQGqO/l4wNp6oADDYrwoEgMdpji43K7lAqIPPk5yJ9QPvn3oH32OjA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B78FD1F000D2;
	Tue, 20 Oct 2026 03:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465727;
	bh=X85kjBINdVfaDrnJk8BmLgtcQVuPyF+arFPTAr2kSiA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UKugfJKkCygObdhUzVIYqOiNhL/INB/Jw3M1kv0sEA/a/SkutNYQx70urkknExQuu
	 6ENKj7kb439k/kLtxmEp8qf1VZj3Q6ro59QOSabf0KhQ2yMUtWeH9/S++mj9JDo5Ac
	 q6YNWNhXuHD2WnCG7XFisJttOBFLcWDT4pstKsaCSw46vFxIlASF8V5JDSgVwaTFwc
	 AtZ1FkQtJxdnsFLHVg2yulwT0FGlGc+YkH810tAIUcsUqRbHsrvONQ7xe1G85OoPwV
	 ImIvTkRj6pzXYoThDQIachF8Rsf2Zto3easAJOumSuzQTyULfQD8xE5RCOJ2gmNWNm
	 P3d+otNBYltGw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 04B754163C;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:49 +0900
Subject: [PATCH v4 6/9] xfs: clamp the pNFS layout range to the maximum
 file size
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261020-xfs-pnfs-batch-v4-6-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=3202;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=vQ4LiIt/NmuGWeXUIuUBhafpRniW8Y+jVNMB3njYRIg=;
 b=WkjR1eO3nwiHnjf+AcrqF6WyicGfW4bFYQ8JFirI6W6xxUaW/dFBjRLXth+BIFfF35zmRfWax
 7chTQs8YL5VBnCR2ZjtnwxE8hB3Zk++BYqu4uv1RUMfqa7Em4gkZOpt
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() checks the range of a layout with

	if (offset > limit)
		goto out_unlock;
	if (offset > limit - length)
		length = limit - offset;

limit - length is computed in u64, so a length larger than the limit
wraps and the length is not clamped. nfsd passes the LAYOUTGET range
through, and RFC 8881 lets a client ask for NFS4_UINT64_MAX bytes, for
the rest of the file. offset + length then wraps to offset - 1, end_fsb
rounds back to offset_fsb, and xfs_bmapi_read() maps nothing. For a read
layout, xfs_bmbt_to_iomap() then gets an uninitialized imap: with a
zeroed stack it logs "Access to block zero", marks the data fork sick
and fails with -EFSCORRUPTED, and otherwise the mapping is whatever was
on the stack and can reach the client. For a write layout,
xfs_iomap_write_direct() is called with a count of zero, which trips an
ASSERT with XFS_DEBUG. An offset of 2^63 or more, which nfsd accepts
too, becomes negative in the loff_t argument and passes the first check.

Reject a negative offset and an offset at the limit, and compare the
length with what is left up to the limit, which cannot wrap once the
offset is below it.

With pynfs as the client, a READ LAYOUTGET for NFS4_UINT64_MAX bytes at
offset 0 got NFS4ERR_IO, as did an RW one on an empty file, which also
made nfsd warn
about the non-standard errno -63, and a READ LAYOUTGET at offset 2^63
got NFS4ERR_IO as well. With this patch and the previous one, the one at
2^63 gets NFS4ERR_INVAL, the RW one gets NFS4ERR_NOSPC after nfsd has
allocated one extent after the other until fewer than
XFS_MAX_BMBT_EXTLEN blocks were free, which left less than 8 GiB of the
32 GiB free, and the server logs nothing. The READ one gets NFS4ERR_INVAL
as well: nfsd, which maps a layout one extent at a time since
commit cc6c40e09d7b ("NFSD/blocklayout: Support multiple extents per
LAYOUTGET"), asks again from the maximum file size on. An RW one on a
file whose first 64 KiB are allocated, with a loga_maxcount that has
room for one extent, is granted 0+65536.

This depends on the previous patch. Without it, an RW LAYOUTGET to the
end of the file, whose length is now clamped instead of wrapping, asks
xfs_iomap_write_direct() for every block up to the maximum file size,
which wraps the block reservation and shuts the filesystem down where it
got NFS4ERR_IO before.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 401a790299..7b508f63d3 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -176,9 +176,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
+	if (length > limit - offset)
 		length = limit - offset;
 
 	error = filemap_write_and_wait(inode->i_mapping);

-- 
2.43.0


