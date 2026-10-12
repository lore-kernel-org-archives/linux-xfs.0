Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AAD49B1F2
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 17:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791827290; cv=pass; b=eChKOmnC4Xz36Lb5Sz0vU0nXllmcX/AbY8juh4fJhZPFu0ejfBhJNGpzAiZgQtMsLSbVPICbRNIpHVogBjeFlpF7+47YVjntyt1TjPxUU+y961PgITDep8SSxCTnlyP2uVukpTrgc2Lq7RcYL6B1MpJ6vwBcBZG7qeGgGHlcqLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791827290; c=relaxed/simple;
	bh=4OrXI+/YqVXcmvDxhAHpQKju3y6wH4zzvB7y/FO5rnY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=QOvZB7SXIORI7evuyDV+QrlmJcqDKD31Nh6jZQ3Sj7RwtoQl2ogCmhC4b06NBmqGEwF5slSK5aOvZQOoxrLYnORzF413KuU8/YNZ29HrQ0SiA+NR8SqnMOb5btMhBBYGKMHFjazKODIUxp5Wi7z3RZ84fBc1vkrJQZgZMVCLT5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SaS0mpEI; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SaS0mpEI"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-88c72646f03so959268b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 10:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791827288; cv=none;
        d=google.com; s=arc-20260327;
        b=RZq61p8ZGtIftWOd6mE4AwEHDbMZCO8y5DQVhTbizTCPz/QA2+DZ643yefuTuQMbLO
         oW8Xt9pchU7RRp/ASK4n+VVocruJQx7XxoDlm01AGSoH3v1hNMy81N7o0C/JTCPVy167
         gTSlsvLHgS/nctu4LV0t7ixPO2yAFHqx96Z5QpxYSBnkBXb6HdV/Na4UDdoJH913n4OE
         wEqXkwwNxS0U2QRVN7pcbsGHrqWtHRphuta6865FgwRqHT4NAwCkYHBeddOcBignug8y
         QAYoXUzKfFxk897g9C9noezY9Fw1OzERweHdpGOH5uZN4NjBTG5sxza/QZ+oAMew9dxE
         dwkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=LuJf79Z8ZzQX8dV82WmfLx6+py3fzuPVWjBGEn7zqK0=;
        fh=717UJfa65qmxQPHgXYe7gUuNhUmUVEsh3JzHptCWmjI=;
        b=r4U8yj+6oVzIc7KUX+DDUfomR7jaKxGIM3DeEhXFXG5ghAJbZCDLYZcdaRAbT4tA9f
         Zl2JiLO9hb3fqBD2EI3PAosp2Cobf9qPNJ9436jqlaXSef1ERUWe4JigNI5LJjgA1WoK
         1KOaWqJI3olL08S2qqpBR0E+jUINmDpCpY1TFMlB8IJ60nmEmn+dibOSbXdT0mM0J1M5
         WbsAfTDcZxRmFOL9HUhxxZoCVnYJQmfGO31mIbrttOwboE+TSXcqXVjAdBOdwaauY+yW
         xO9iAr1/xrZwyBbzOYZiK6+c8CuS8M91CLcfwtNHn95bS//vQOWo1C1bMuVJ/lh+C2yP
         6HRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791827288; x=1792432088; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LuJf79Z8ZzQX8dV82WmfLx6+py3fzuPVWjBGEn7zqK0=;
        b=SaS0mpEIvBGfcSdOp4ifuRaTAhHUzp1p2xMWx/p43OP/J5RkztsSa520rz0OKT+Y2X
         01fi31dD/4pDBWSzitGz2ZX/de1zO2JyzTpph9fpzDcQA2TJYLOThcTIqAEEThGjhM1f
         nXaJ7+W3bRH+a+BP3u2yY6nK3+9SaFQq6DSVrBzM9ZT3w5QbR3az9W0vKJ5uJzC/6WZ9
         Qqwoog7HtlauU0Ys+h3vYxZh7/vAl17hfN6gqleMcVhO5LrIEZGS/cUswhS38hBtfJ2b
         o1wDU5hLeGx9sTciwdUFGtXSmBfHSKmrwq7TI3lmO7mEBvlc5swUqE7P6Cb8o36IF4F6
         psgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791827288; x=1792432088;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LuJf79Z8ZzQX8dV82WmfLx6+py3fzuPVWjBGEn7zqK0=;
        b=MQz0OrZuFhwE1QWyaVktMU48P5VK7n2HY4PyKOwtsF77ruz6sJjQY7Nk2G5ruMmOqI
         mMuiJFqMyUX1bsgx1/PNlKOqmEBqwvYszfA+3uMbv9NfFxQKOwabuB1gjzkByZBuLSZb
         h9U1I/eIYmKTo2Hh9Agu//vuEzW6qkv61v3DWCP+4q63fqVJL62SG2usJI/2a+ypUwJy
         01v2xsxPa2bjm3Rl15/Ji3GimJrhZBrVfVUwTCKU0odW4+4PLWR0njxnBpOpidPbLakf
         DNk9WgiL1MdlToBZH8YG0Ow9K7MukC0WJWswqOPDUtvr+e+xFKF/LfTd58d4kmd2DIJZ
         GXUw==
X-Gm-Message-State: AFq9FYIGcgsihvjG44Las+DOsNbC++RsqvglbblxpSTUDeim2r5K3GCt
	9ZGopXM3szEZgY0uWUnNvbkLf07zdOUIrL1WNzljI9YxswM/oUWPyKQNhE4rksdnKF4coZCLiqR
	sz1p4905krxp7vY11rkaASUmBgLGUJD2pMp0j
X-Gm-Gg: AYBFou1mue4tmg8+uy4cpVoSpgSEh9yXi361Z+03PLAJfO+cywxUqWKq173bniqkBBO
	azi/t2eAMNtfGubHbr+ZVPxaTbpPXLXIq9C5OK2HMGgLtdmnR+9HDEoxyx76Dhh9omHiL9c/DRf
	TFmZwAwsPdmSB80RHzFzGHp5txvh64m2zL2NeTUKvzzPqrKemyq3TXPYbOD/ClLDCv8NFHoum0z
	tmy6Ni786FCUhLx2iQbEsqiRX/X6BC1r2Hq8ZFJM59+hn4qkn0YB2LLHMKMF+orNZsVYrc49+pK
	vkgJCKHLngSIn0+em19H+dWqV92FqkbWIrEiaDlOC2mwavK/FJJ4TNKDqpBZNbCmgrrexxpLuYn
	oNK9+OtY6qs5DcPIZ1kt/e2Q=
X-Received: by 2002:a05:6a00:b8d:b0:886:3bd6:fe65 with SMTP id
 d2e1a72fcca58-897c710528amr8855554b3a.19.1791827288209; Mon, 12 Oct 2026
 10:48:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Vitali Lovich <vlovich@gmail.com>
Date: Mon, 12 Oct 2026 10:47:56 -0700
X-Gm-Features: AclHuK-3yVRWDAutx5UAGBfZqZq-dAFweKOlWQb6Mwqi7L_xry6FJJ4X1xSX4K4
Message-ID: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
Subject: Really bad I/O lock contention between non-overlapping reader and writer
To: linux-xfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000003630d065da84d65"

--00000000000003630d065da84d65
Content-Type: text/plain; charset="UTF-8"

I think I encountered suboptimal locking behavior with concurrent
readers and writers on a file, which resulted in huge latency spikes
for the reader even though the writers and readers are touching
unrelated ranges within the file. The writer/hole puncher hold an
exclusive lock on the inode while forcing a flush of outstanding
writes to disk which creates huge latency spikes for reads.

I've observed read's taking >> 500ms even though none of the writes
could be overlapping and traces seem to indicate it's the shared inode
lock contending with the exclusive inode lock that writes / hole
punching is holding. In my real-world test case traces indicated that
the cause might be inode_dio_wait while holding the exclusive inode
lock.

I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
general VFS challenge. Generally, Btrfs seems to have less read
latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
which in turn has smaller and fewer tail latencies than XFS  (~2x more
at 0-1ms and extreme is smaller) although all filesystems exhibit the
issue. Starting with the XFS list in case I'm way off base that this
is a problem.

Attaching a simplified reproduction of what I'm doing with one writer
appending data to the file, a separate writer punching holes in
unrelated ranges, and an O_DIRECT reader that's reading data. Reads
are doing random 4kib I/O in [0, 64MiB), hole punching is punching
4kib holes in [64MiB, 576Mib] and writing is always appending after
577MiB of the file. The directory the anonymous file is created in is
CWD by default unless you pass a different path. I'd expect read
latencies to not be impacted by waiting for writes to flush yet it
seems like clearly there is such a serialization.

cc -O2 -g -std=gnu11 -Wall -Wextra -Werror repro-syscall.c -pthread -o
syscall-repro

--00000000000003630d065da84d65
Content-Type: text/x-csrc; charset="US-ASCII"; 
	name="pessimistic_locking_between_readers_and_writers.c"
Content-Disposition: attachment; 
	filename="pessimistic_locking_between_readers_and_writers.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mv5jm7uz0>
X-Attachment-Id: f_mv5jm7uz0

LyoKICogRmlsZSBsYXlvdXQgKE1pQjsgcmFuZ2VzIGFyZSBoYWxmLW9wZW4pOgogKiAgIFswLCA2
NCkgICAgIHJhbmRvbSA0IEtpQiByZWFkcwogKiAgIFs2NCwgNTc2KSAgIG9uZS10aW1lIDQgS2lC
IGhvbGUgcHVuY2hlcwogKiAgIFs1NzYsIDU3NykgIHVudXNlZCBndWFyZAogKiAgIFs1NzcsIC4u
LikgIHJlcGVhdGVkIDUxMiBNaUIgd3JpdGVzCiAqCiAqIEJlZm9yZSBzdGFydGluZyB0aGUgd29y
a2VyIHRocmVhZHMsIGluaXRpYWxpemF0aW9uIHdyaXRlcyBhbmQgZnN5bmNzIHRoZQogKiBlbnRp
cmUgWzAsIDU3NykgcmFuZ2UgaW4gMSBNaUIgY2h1bmtzLiBUaHVzIGV2ZXJ5IHB1bmNoZWQgcmFu
Z2Ugd2FzIHdyaXR0ZW4KICogZmlyc3QuIFRoZSByZWFkZXIgY2hvb3NlcyBhbGlnbmVkIGJsb2Nr
cyBvbmx5IHdpdGhpbiBbMCwgNjQpLCBhbmQgZWFjaAogKiBwcmVhZCBlbmRzIG5vIGxhdGVyIHRo
YW4gNjQgTWlCLiBQdW5jaGVzIHN0YXkgd2l0aGluIFs2NCwgNTc2KTsgdGhlIHdyaXRlcgogKiBz
dGFydHMgYXQgNTc3IE1pQiBhbmQgYXBwZW5kcywgc28gbm9uZSBvZiB0aGUgdGhyZWUgb3BlcmF0
aW9ucyBvdmVybGFwLgogKgogKiBUaGUgcmVhZCwgd3JpdGUsIGFuZCBwdW5jaCBkZXNjcmlwdG9y
cyBhcmUgb3BlbmVkIG9uIHRoZSBzYW1lIGlub2RlLiBUaGUKICogcGF0aG5hbWUgaXMgdW5saW5r
ZWQgYWZ0ZXIgb3BlbmluZzsgdGhlIGRlc2NyaXB0b3JzIGtlZXAgdGhhdCBmaWxlIGFsaXZlLgog
Ki8KI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZXJybm8uaD4KI2luY2x1ZGUgPGZjbnRs
Lmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzdGRhdG9taWMuaD4KI2luY2x1ZGUg
PHN0ZGludC5oPgojaW5jbHVkZSA8c3RkYm9vbC5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgoj
aW5jbHVkZSA8dGltZS5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CgojZGVmaW5lIEsgKDEwMjRVTEwp
CiNkZWZpbmUgTSAoMTAyNFVMTCAqIEspCi8qIEZpbGUgbGF5b3V0OiByZWFkYWJsZSBkYXRhIHwg
cHVuY2hlZCBkYXRhIHwgZ3VhcmQgfCBhcHBlbmRlZCB3cml0ZXMuICovCiNkZWZpbmUgUkVBRF9N
SUIgNjQKI2RlZmluZSBIT0xFX01JQiA1MTIKI2RlZmluZSBXUklURV9NSUIgNTEyCiNkZWZpbmUg
UFVOQ0hfS0lCIDQKI2RlZmluZSBCVUNLRVRTIDEwMDEKCnN0YXRpYyBpbnQgcmZkLCB3ZmQsIHBm
ZDsKc3RhdGljIGF0b21pY19ib29sIHN0b3A7CnN0YXRpYyBhdG9taWNfdWxsb25nIHdyaXRlcywg
cHVuY2hlcywgcmVhZHM7CnN0YXRpYyB1aW50NjRfdCBoaXN0W0JVQ0tFVFNdLCBtYXhfcmVhZF9u
cywgb3ZlcjEwMG1zOwpzdGF0aWMgaW5saW5lIHVpbnQ2NF90IG5zKHZvaWQpIHsKICAgIHN0cnVj
dCB0aW1lc3BlYyB0OwogICAgY2xvY2tfZ2V0dGltZShDTE9DS19NT05PVE9OSUMsICZ0KTsKICAg
IHJldHVybiAodWludDY0X3QpdC50dl9zZWMgKiAxMDAwMDAwMDAwICsgdC50dl9uc2VjOwp9CnN0
YXRpYyB2b2lkIGRpZShjb25zdCBjaGFyICpzKSB7IHBlcnJvcihzKTsgZXhpdCgxKTsgfQpzdGF0
aWMgdm9pZCAqYWxpZ25lZChzaXplX3QgbikgewogICAgdm9pZCAqcDsKICAgIGludCBlID0gcG9z
aXhfbWVtYWxpZ24oJnAsIDQwOTYsIG4pOwogICAgaWYgKGUpIHsgZXJybm8gPSBlOyBkaWUoInBv
c2l4X21lbWFsaWduIik7IH0KICAgIG1lbXNldChwLCAweDVhLCBuKTsKICAgIHJldHVybiBwOwp9
CnN0YXRpYyB2b2lkICpyZWFkZXIodm9pZCAqdW51c2VkKSB7CiAgICAodm9pZCl1bnVzZWQ7CiAg
ICBjaGFyICpiID0gYWxpZ25lZCg0MDk2KTsKICAgIHVpbnQ2NF90IHggPSAweDllMzc3OWI5N2Y0
YTdjMTVVTEw7CiAgICB3aGlsZSAoIWF0b21pY19sb2FkKCZzdG9wKSkgewogICAgICAgIHggXj0g
eCA8PCAxMzsgeCBePSB4ID4+IDc7IHggXj0geCA8PCAxNzsKICAgICAgICBvZmZfdCBvZmYgPSAo
b2ZmX3QpKCh4ICUgKFJFQURfTUlCICogTSAvIDQwOTYpKSAqIDQwOTYpOwogICAgICAgIHVpbnQ2
NF90IGEgPSBucygpOwogICAgICAgIHNzaXplX3QgbiA9IHByZWFkKHJmZCwgYiwgNDA5Niwgb2Zm
KTsKICAgICAgICB1aW50NjRfdCBkID0gbnMoKSAtIGE7CiAgICAgICAgaWYgKG4gIT0gNDA5Nikg
ZGllKCJwcmVhZCIpOwogICAgICAgIGlmIChkID4gbWF4X3JlYWRfbnMpIG1heF9yZWFkX25zID0g
ZDsKICAgICAgICB1bnNpZ25lZCBidWNrZXQgPSBkIC8gMTAwMDAwMDsKICAgICAgICBoaXN0W2J1
Y2tldCA8IEJVQ0tFVFMgPyBidWNrZXQgOiBCVUNLRVRTIC0gMV0rKzsKICAgICAgICBvdmVyMTAw
bXMgKz0gZCA+PSAxMDAwMDAwMDA7CiAgICAgICAgYXRvbWljX2ZldGNoX2FkZCgmcmVhZHMsIDEp
OwogICAgfQogICAgZnJlZShiKTsgcmV0dXJuIE5VTEw7Cn0Kc3RhdGljIHZvaWQgKndyaXRlcih2
b2lkICp1bnVzZWQpIHsKICAgICh2b2lkKXVudXNlZDsKICAgIGNoYXIgKmIgPSBhbGlnbmVkKFdS
SVRFX01JQiAqIE0pOwogICAgb2ZmX3Qgb2ZmID0gKFJFQURfTUlCICsgSE9MRV9NSUIgKyAxKSAq
IE07CiAgICB3aGlsZSAoIWF0b21pY19sb2FkKCZzdG9wKSkgewogICAgICAgIHNpemVfdCBkb25l
ID0gMDsKICAgICAgICB3aGlsZSAoZG9uZSA8IFdSSVRFX01JQiAqIE0pIHsKICAgICAgICAgICAg
c3NpemVfdCBuID0gcHdyaXRlKHdmZCwgYiArIGRvbmUsIFdSSVRFX01JQiAqIE0gLSBkb25lLCBv
ZmYgKyBkb25lKTsKICAgICAgICAgICAgaWYgKG4gPCAwKSBkaWUoInB3cml0ZSIpOwogICAgICAg
ICAgICBpZiAoIW4pIHsgZXJybm8gPSBFSU87IGRpZSgiemVybyBwd3JpdGUiKTsgfQogICAgICAg
ICAgICBkb25lICs9IChzaXplX3QpbjsKICAgICAgICB9CiAgICAgICAgb2ZmICs9IFdSSVRFX01J
QiAqIE07CiAgICAgICAgYXRvbWljX2ZldGNoX2FkZCgmd3JpdGVzLCAxKTsKICAgIH0KICAgIGZy
ZWUoYik7IHJldHVybiBOVUxMOwp9CnN0YXRpYyB2b2lkICpwdW5jaGVyKHZvaWQgKnVudXNlZCkg
ewogICAgKHZvaWQpdW51c2VkOwogICAgb2ZmX3Qgb2ZmID0gUkVBRF9NSUIgKiBNOwogICAgY29u
c3Qgb2ZmX3QgZW5kID0gKFJFQURfTUlCICsgSE9MRV9NSUIpICogTTsKICAgIHdoaWxlICghYXRv
bWljX2xvYWQoJnN0b3ApICYmIG9mZiA8IGVuZCkgewogICAgICAgIGlmIChmYWxsb2NhdGUocGZk
LCBGQUxMT0NfRkxfUFVOQ0hfSE9MRSB8IEZBTExPQ19GTF9LRUVQX1NJWkUsIG9mZiwgUFVOQ0hf
S0lCICogSykpIGRpZSgiZmFsbG9jYXRlIHB1bmNoIik7CiAgICAgICAgb2ZmICs9IFBVTkNIX0tJ
QiAqIEs7CiAgICAgICAgYXRvbWljX2ZldGNoX2FkZCgmcHVuY2hlcywgMSk7CiAgICB9CiAgICBy
ZXR1cm4gTlVMTDsKfQppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpIHsKICAgIGNvbnN0
IGNoYXIgKmRpciA9IGFyZ2MgPiAxID8gYXJndlsxXSA6ICIuIjsKICAgIHVuc2lnbmVkIHNlY29u
ZHMgPSBhcmdjID4gMiA/IHN0cnRvdWwoYXJndlsyXSwgTlVMTCwgMTApIDogMTA7CiAgICBjaGFy
IHBhdGhbNDA5Nl07CiAgICBpZiAoc25wcmludGYocGF0aCwgc2l6ZW9mKHBhdGgpLCAiJXMvc3lz
Y2FsbC1yZXByby1YWFhYWFgiLCBkaXIpID49IChpbnQpc2l6ZW9mKHBhdGgpKSB7IGVycm5vID0g
RU5BTUVUT09MT05HOyBkaWUoInBhdGgiKTsgfQogICAgaW50IGZkID0gbWtzdGVtcChwYXRoKTsg
aWYgKGZkIDwgMCkgZGllKCJta3N0ZW1wIik7CiAgICByZmQgPSBvcGVuKHBhdGgsIE9fUkRPTkxZ
IHwgT19ESVJFQ1QpOyBpZiAocmZkIDwgMCkgZGllKCJvcGVuIHJlYWQiKTsKICAgIHdmZCA9IG9w
ZW4ocGF0aCwgT19SRFdSIHwgT19ESVJFQ1QpOyBpZiAod2ZkIDwgMCkgZGllKCJvcGVuIHdyaXRl
Iik7CiAgICBwZmQgPSBvcGVuKHBhdGgsIE9fUkRXUik7IGlmIChwZmQgPCAwKSBkaWUoIm9wZW4g
cHVuY2giKTsKICAgIHVubGluayhwYXRoKTsKICAgIGNoYXIgKmluaXQgPSBhbGlnbmVkKE0pOwog
ICAgb2ZmX3QgZW5kID0gKFJFQURfTUlCICsgSE9MRV9NSUIgKyAxKSAqIE07CiAgICBmb3IgKG9m
Zl90IG8gPSAwOyBvIDwgZW5kOyBvICs9IE0pCiAgICAgICAgaWYgKHB3cml0ZShmZCwgaW5pdCwg
TSwgbykgIT0gTSkgZGllKCJpbml0aWFsaXplIik7CiAgICBpZiAoZnN5bmMoZmQpKSBkaWUoImZz
eW5jIGluaXQiKTsKICAgIGZyZWUoaW5pdCk7IGNsb3NlKGZkKTsKICAgIHByaW50ZigiZGlyZWN0
IHByZWFkL3B3cml0ZTsgZmFsbG9jYXRlIHB1bmNoOyByZWFkPVswLCVkIE1pQiksIHB1bmNoPVsl
ZCwlZCBNaUIpLCB3cml0ZSBzdGFydHMgYXQgJWxsZCBNaUI7IHNlY29uZHM9JXVcbiIsIFJFQURf
TUlCLCBSRUFEX01JQiwgUkVBRF9NSUIgKyBIT0xFX01JQiwgKGxvbmcgbG9uZykoUkVBRF9NSUIg
KyBIT0xFX01JQiArIDEpLCBzZWNvbmRzKTsKICAgIHB0aHJlYWRfdCBydCwgd3QsIHB0OwogICAg
aWYgKHB0aHJlYWRfY3JlYXRlKCZydCwgTlVMTCwgcmVhZGVyLCBOVUxMKSB8fCBwdGhyZWFkX2Ny
ZWF0ZSgmd3QsIE5VTEwsIHdyaXRlciwgTlVMTCkgfHwgcHRocmVhZF9jcmVhdGUoJnB0LCBOVUxM
LCBwdW5jaGVyLCBOVUxMKSkgZGllKCJwdGhyZWFkX2NyZWF0ZSIpOwogICAgc2xlZXAoc2Vjb25k
cyk7CiAgICBhdG9taWNfc3RvcmUoJnN0b3AsIHRydWUpOwogICAgcHRocmVhZF9qb2luKHJ0LCBO
VUxMKTsgcHRocmVhZF9qb2luKHd0LCBOVUxMKTsgcHRocmVhZF9qb2luKHB0LCBOVUxMKTsKICAg
IHByaW50Zigic3VtbWFyeSByZWFkcz0lbGx1IHdyaXRlcz0lbGx1IHB1bmNoZXM9JWxsdSBtYXgt
cmVhZD0lLjFmIG1zID4xMDBtcz0lbGx1XG4iLCBhdG9taWNfbG9hZCgmcmVhZHMpLCBhdG9taWNf
bG9hZCgmd3JpdGVzKSwgYXRvbWljX2xvYWQoJnB1bmNoZXMpLCBtYXhfcmVhZF9ucyAvIDFlNiwg
KHVuc2lnbmVkIGxvbmcgbG9uZylvdmVyMTAwbXMpOwogICAgcHV0cygibGF0ZW5jeS1tcyxjb3Vu
dCIpOwogICAgZm9yICh1bnNpZ25lZCBpID0gMDsgaSA8IEJVQ0tFVFM7ICsraSkgaWYgKGhpc3Rb
aV0pIHByaW50ZigiJXUsJWxsdVxuIiwgaSwgKHVuc2lnbmVkIGxvbmcgbG9uZyloaXN0W2ldKTsK
ICAgIHJldHVybiAwOwp9Cg==
--00000000000003630d065da84d65--
