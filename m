Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794447442;
	b=jqodAUulLVOszYSx5zXPokcO1TWMGBqxw4SuSNBg0yVLsHfJjFSbjeDSDW1g5N9JQ8jj
	 yufCklTVLIGSSzQg9nqQCRaalfpyQYlS/bsmgxDOo5cAr4ZgwoWjA7pav0pL+2a4mWLmn
	 ty6zZD0uFCZCKy8kEQhwNzeEjMfZvU8n2oM78VP8CbLwTQH5XitgTKeblgpi7TRnReCY7
	 09G4sfRzm0GDWjxbW0kOy5uDqKOXSx9cl4UK58IlD+f9lCBESx/Qw1ETZzfj0gzA6Noj+
	 wI6UvMZ3qJqUsMZ81/P1FAlGu49v2VfINREfq1rAgG1+PwS+tblc5lWXoIhMXkzG4bQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794447442;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OvSeMbIegdy6KLQs5HpzoD8DDaWn8gOElZnDH9XUj30=;
	b=Zvwr7tY9lDtcuhF2krCyqCn/9NkE2G75eoV6tPRaAjxMBYNVMt0G2/KHAUarntn27+lF
	 ooqN/UuVrt14gQaC53eGpGQ1/lgKvP6GBPg0nLNxySP8kmUSLnp3ZJ4mG4tmycU+qlSna
	 FERwS5EZdeJs2s7lo5mKuxwkpTJmgoiXV2GO60GhtoJGN/BIXU7aVSkcm0F3/Ove/d81N
	 UsReJ5/DW5oPjxtO80e9zwB4W914sYMz52jUER598kb5bYYfPbdUqWz+dgef92KzTv448
	 O57arfDCu/El3SvifIgDXkCU2IwuBP4ld9MKl1T53OykCSYoocVon7h9BNUMJcY8ZiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZY14VQT9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D102606A880;
	Thu, 12 Nov 2026 01:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZY14VQT9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794447442;
	b=I8HVNOjo/HiV5lfTourmd78+nz7KX2FSLfZNDtfsEIny/jNKBV5O8MQXCr5A0DkGPqf4
	 UdS/8dn4P51mgDcCKmciOa5RtBD1rrw2esJCnPXTjVNKuvBAdlsz1wImM4YjKcruw2/Xf
	 EviS1P5PprQsYIAJkEcr7MAuEczxxbusPtSVKbV4DjUktNoEXZu4QTDBRqgTD2fXuhyyJ
	 FSv9zyv//TuWE9wwSQGi7guJbh52GFCVRdxm/+bsezvaTYUtKd2IEk3m/++tfAEArNsGQ
	 Na1//YuMVNcbpemHnLckxTGhoaHYLg1bHT/bnxD6s9RpU23SVHam8qeCif2gPjMuEbw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794447442;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=OvSeMbIegdy6KLQs5HpzoD8DDaWn8gOElZnDH9XUj30=;
	b=2jQWLD6/mOO/Ku5SIjjQyxuaEEODZkNmIgLmijdA4PJop2GD1t6VcleugAEqI+cF8bu6
	 9m3TqnoQxbIAMyAQiSmXjIj7OpJICAuBncpKNOLU3jgyCp7quIPK0VN20F1DV0pntHIZf
	 UW1fukOMIT7qTOVrQgrWBUsbBT0M8dYfxvpBQUkLYtiTQ9QgPIP4a37PhHH+4PA35fjuh
	 FDWuuZF1UWJ3Q9HoKLA4RZp1OJKu03rzfaRAlGK3R7UPmdzRZujAgIj3ON0W2S6OQLxYS
	 SjGcYQByso5lFeEXY3LDCsafhMLNe8N3Ghmgf3+Uz+yfQaP69L9WxgzX3mpUyfv4uYQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E8FE41F00A0B;
	Thu, 12 Nov 2026 01:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794447442;
	bh=OvSeMbIegdy6KLQs5HpzoD8DDaWn8gOElZnDH9XUj30=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZY14VQT9bTzG+Lxc7EiUpmv2h7jW6ZGiM9gdjitdufnwmHR9NQqjtqtMJzuf1TwRO
	 eCJpnhy0kgGn7MI5IEdiL2muAZL+OWPj0Yseb+pKqKuj6wLUoxkXhv2/BBSlq4gXKl
	 +VWFPlfmh04zn7DHL7FjhBpsDMORZorCfDsipFaFVNbge1yUq/ZfQ6XpQKhDTOig1u
	 RQQsg3QrkY+93cJ1Uff1HAH20ZR7KWwDOUUyhB+FQ5X8IOU5LY6uPr5CCVyPJge8BO
	 M3KTrFGuPEz+ZR8zHhLt9cfYNmidmYH/a8hgsDEBXZbNWIRDzhXptJdrYi6IpGnbdJ
	 6WFqmxr1ysC3A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 74230491BF;
	Thu, 12 Nov 2026 01:37:20 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 12 Nov 2026 10:37:18 +0900
Subject: [PATCH 2/2] xfs/438: fail metadata writes with the buf_ioerror
 error tag
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
Message-Id: <20261112-xfs-438-dquot-retry-v1-2-73149b823246@samsung.com>
References: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
In-Reply-To: <20261112-xfs-438-dquot-retry-v1-0-73149b823246@samsung.com>
To: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Brian Foster <bfoster@redhat.com>, Dave Chinner <dgc@kernel.org>, 
 linux-xfs@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794447436; l=5124;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=uxhvdiV7rEpIfQfXZG8qo3IqaiTTume2rGdCDhiHHLQ=;
 b=3dTDa/quXyfGp9o1QrxebipImw93Jf5AUadk4lsGPoISbTArITjRzCsBtxiT7Bh3oEeluVGLR
 xqVXGUicocPCDE9W83Qxyy4Qlkusxlt4fiBjRe8xm6vSzAvASJaVUKJ
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

xfs/438 needs metadata writes to fail while the log keeps working.
With a write cache, dm-flakey also fails the flushes that dm sends it
with REQ_PREFLUSH log writes. The internal log survives only because
dm drops that error. The dm patch "dm: fail a REQ_PREFLUSH bio with
data when its preflush fails" fixes that. With an external log, the
flakey table fails the log device too.

Use the buf_ioerror error tag. It fails async metadata buffer writes
and leaves log writes alone. The test now needs XFS_DEBUG.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
On v7.4-rc2 and on v7.4-rc2 with the dm patch, the test passes with
an internal log (3 of 3) and an external log (1 of 1). The failed
dquot write is retried until the unmount. On the TEST ONLY kernel of
patch 1 the unmount hangs with both logs (1 of 1 each).
---
 tests/xfs/438 | 76 ++++++-----------------------------------------------------
 1 file changed, 7 insertions(+), 69 deletions(-)

diff --git a/tests/xfs/438 b/tests/xfs/438
index e4850ff..5c228e4 100755
--- a/tests/xfs/438
+++ b/tests/xfs/438
@@ -14,9 +14,9 @@
 # get the same IO error, XFS will let xfsaild to restart the write and
 # xfs_buf_do_callbacks() will not be inovked.
 #
-# This test emulates the write error by using dm-flakey. The log
-# area of the XFS filesystem is excluded from the range covered by
-# dm-flakey, so the XFS will not be shutdown prematurely.
+# This test emulates the write error with the buf_ioerror error tag,
+# which fails async metadata buffer writes. Log writes are not buffer
+# writes, so the XFS will not be shutdown prematurely.
 #
 # Fixed by upstream commit 373b058 ("xfs: Properly retry failed dquot
 # items in case of error during buffer writeback")
@@ -33,85 +33,27 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	_scratch_unmount >/dev/null 2>&1
-	_cleanup_flakey > /dev/null 2>&1
-}
-
-# inject IO write error for the XFS filesystem except its log section
-make_xfs_scratch_flakey_table()
-{
-	local tgt=flakey
-	local opt="0 1 1 error_writes"
-	local dev=${SCRATCH_DEV}
-	local dev_sz=$(blockdev --getsz $dev)
-
-	# If using an external log device, just making the writing of
-	# entire data/metadata area fail forever.
-	if [ "${USE_EXTERNAL}" = "yes" -a ! -z "$SCRATCH_LOGDEV" ]; then
-		echo "0 ${dev_sz} $tgt $dev 0 $opt"
-		return
-	fi
-
-	local blk_sz=$(_scratch_xfs_get_sb_field blocksize)
-	local log_ofs=$(_scratch_xfs_get_sb_field logstart)
-	local log_sz=$(_scratch_xfs_get_sb_field logblocks)
-	local table=""
-	local ofs=0
-	local sz
-
-	log_ofs=$(_scratch_xfs_db -r -c "convert fsb ${log_ofs} bb" | \
-			  $AWK_PROG '{gsub("[()]", "", $2); print $2}')
-	let "log_sz *= blk_sz / 512"
-
-	# Add a flakey target for the area before the log section
-	# to make the data/metadata write fail forever
-	if [ "$ofs" -lt "${log_ofs}" ]; then
-		let "sz = log_ofs - ofs"
-		table="$ofs $sz $tgt $dev $ofs $opt"
-	fi
-
-	# Add a linear target for the log section, so the log write
-	# will work normally
-	table="$table\n${log_ofs} ${log_sz} linear $dev ${log_ofs}"
-
-	# Add a flakey target for the area after the log section
-	# to make the data/metadata write fail forever
-	let "ofs = log_ofs + log_sz"
-	if [ "$ofs" -lt "${dev_sz}" ]; then
-		let "sz = dev_sz - ofs"
-		table="$table\n$ofs $sz $tgt $dev $ofs $opt"
-	fi
-
-	echo -e $table
 }
 
 # Import common functions.
-. ./common/dmflakey
 . ./common/quota
+. ./common/inject
 
 
 # due to the injection of write IO error, the fs will be inconsistent
 _require_scratch_nocheck
-_require_flakey_with_error_writes
 _require_user
 _require_xfs_quota
 _require_freeze
 _require_test_sysfs_dev_attr error/fail_at_unmount
 _require_test_sysfs_dev_attr error/metadata/EIO/max_retries
 _require_test_sysfs_dev_attr error/metadata/EIO/retry_timeout_seconds
+_require_xfs_io_error_injection buf_ioerror
 
 echo "Silence is golden"
 
 _scratch_mkfs > $seqres.full 2>&1
 
-# this needs to happen after mkfs, but before _init_flakey overrides SCRATCH_DEV
-FLAKEY_TABLE_NON_LOG_ERROR=$(make_xfs_scratch_flakey_table)
-
-# no error will be injected
-_init_flakey
-FLAKEY_TABLE_ERROR=${FLAKEY_TABLE_NON_LOG_ERROR}
-$DMSETUP_PROG info >> $seqres.full
-$DMSETUP_PROG table >> $seqres.full
-
 # save the old value for _cleanup()
 interval=$(sysctl -n fs.xfs.xfssyncd_centisecs 2>/dev/null)
 # shorten the time waiting for the push of ail items
@@ -139,10 +81,8 @@ $XFS_QUOTA_PROG -x -c "report -ih" $SCRATCH_MNT >> $seqres.full
 xfs_freeze -f $SCRATCH_MNT
 xfs_freeze -u $SCRATCH_MNT
 
-# inject write IO error
-_load_flakey_table ${FLAKEY_ERROR_WRITES}
-$DMSETUP_PROG info >> $seqres.full
-$DMSETUP_PROG table >> $seqres.full
+# fail every async metadata buffer write from now on
+_scratch_inject_error buf_ioerror 1
 
 # update the dquota buffer
 $XFS_QUOTA_PROG -x -c "limit -u isoft=400 $qa_user" $SCRATCH_MNT
@@ -160,8 +100,6 @@ stat $SCRATCH_MNT > /dev/null
 
 _scratch_unmount
 
-_cleanup_flakey
-
 # success, all done
 status=0
 exit

-- 
2.43.0


