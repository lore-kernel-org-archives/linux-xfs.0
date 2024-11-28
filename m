Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440FF537F8
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732828168; cv=none; b=EnvIz+1gQvrX1jRgB5Y3wNFFlAQHiD3dARjpwT1hGe8DmXpd+fLg3OCh/aNjrwgMEXMmxpL3dqi/NymQZPBaLtZQ9pwSrDIIooMTyqnXyylWXhOjz7O9LClcFJIELA+VLgHOq8LgFP8cvb11T8Nmf0vtd5++U6Po12RgCIdYDl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732828168; c=relaxed/simple;
	bh=Vej/mfGqnrcu4kYeshA6IRsO38SQr5F5xErtQ+ziI2Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I39jvDcWAi1rH8aSxHfn3YEMzJLxs0dYuVhBZJt16vsYWcuGCGUHhc+3bitO5M4u1N3V1A/5gchI3TE3esvZVxj4k5/e3g1XhRIRt+fmaHf9uXEZCW8eNBWrd55wu9Cq2PkU6jYhS8bp9C3J1ROS7zpi++RD3TJpISfqMFKkXzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKZ5P8LH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKZ5P8LH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5797C4CED9
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732828167;
	bh=Vej/mfGqnrcu4kYeshA6IRsO38SQr5F5xErtQ+ziI2Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MKZ5P8LHv1t42xj/H9qZUpy8pEnhuOrfVVJUsaOCTKiisiat3t8Ija+PG5u9H6ebG
	 KattZ9uQdhopntR8hwvQt7vJycm7gE/Ta+Kl9vB5FxufVw8HmPo0CDTeKMbw0Dcl8u
	 srPiriJm9p5mXBi+LmW9hHMT76af/uS9NBLe+3LFuFTOtmAuFI1Nxgv9ZFVqkUDDZd
	 w02b6hhZNL8+fdMiS++eZkyMkysIRy7uQTWabEzYO66e1mLBJlSplj3JPrNwyhjSxh
	 3NtBlJlcj5AjLtCeYJfXDXOrfjfdsA6e+bwAfhzF3XCVyxEW3r5ewPNWAYKpujDdKg
	 Lbd+xFYO3+0iA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id AC071C53BC2; Thu, 28 Nov 2024 21:09:27 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] XFS crashes with kernel Version > 6.1.91. Perhaps
 Changes in kernel 6.1.92 for XFS/iomap causing the problems?
Date: Thu, 28 Nov 2024 21:09:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-219504-201763-DK3k4WyihR@https.bugzilla.kernel.org/>
In-Reply-To: <bug-219504-201763@https.bugzilla.kernel.org/>
References: <bug-219504-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D219504

--- Comment #2 from Mike-SPC (speedcracker@hotmail.com) ---
Hello Long Li,

thanks for investigation.
It seems, that the patch went into the kernel 6.1.113:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=
=3De3aa99b13a99405d935910306d1bbf419edfd679

It looks like this:

--- snip ---

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 98617f00101d68..1833608f39318e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -990,7 +990,15 @@ static int iomap_write_delalloc_release(struct inode
*inode,
                        error =3D data_end;
                        goto out_unlock;
                }
-               WARN_ON_ONCE(data_end <=3D start_byte);
+
+               /*
+                * If we race with post-direct I/O invalidation of the page
cache,
+                * there might be no data left at start_byte.
+                */
+               if (data_end =3D=3D start_byte)
+                       continue;
+
+               WARN_ON_ONCE(data_end < start_byte);
                WARN_ON_ONCE(data_end > scan_end_byte);

                error =3D iomap_write_delalloc_scan(inode, &punch_start_byt=
e,

--- snap ---

Looks like your's:

https://patchwork.kernel.org/project/xfs/patch/20231216115559.3823359-1-leo=
.lilong@huawei.com/

Due to lack of time, I haven't gotten around to testing the latest kernel w=
ith
this patch in it.

Regards,
Mike

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
