Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793487680;
	b=wlmXsZknRaN2VGqlc9DroKIG+ZZEfJ/W+CNaaGOJ0qePaLdr0RvltqwDCH8ZuzdydmTz
	 wNZvk68aPMIgOKp2tYF88zE5KAW0z91TSuwGGcv6G4oTDG/FjyWU0AOYzipvc+Rwa/QDU
	 1IZ4ZT8EGyvDANOZRK3/l9oVBVPeopYXfkPux/iMhBr7OBKgHrISvJIDI0/v31bsPrN/T
	 tqp06AURJ/h9R6mIEBk+M1/H9TVQM/JyZRIbvpn19AJO0WTVG7rMbLYNv4xtoQR5PDQjR
	 Sppq53QEDNkdG+fGyQDX4imfGF+X2Tz0T1oPsd16X4xAhi1+Q0QiCwEcvngXq0qf7Zw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793487680;
	h=Received:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 X-Bugzilla-Reason:X-Bugzilla-Type:X-Bugzilla-Watch-Reason:
	 X-Bugzilla-Product:X-Bugzilla-Component:X-Bugzilla-Version:
	 X-Bugzilla-Keywords:X-Bugzilla-Severity:X-Bugzilla-Who:
	 X-Bugzilla-Status:X-Bugzilla-Resolution:X-Bugzilla-Priority:
	 X-Bugzilla-Assigned-To:X-Bugzilla-Flags:X-Bugzilla-Changed-Fields:
	 Message-ID:Content-Type:Content-Transfer-Encoding:X-Bugzilla-URL:
	 Auto-Submitted:MIME-Version;
	bh=mKE+jkSKqU9Yolv4bxd6BupqR9EY5Hk4IfVNQiuPepc=;
	b=0D2ZDozUeciMCPxZhqdFU7FPJ0VjQnxkJB0yXbl7AjFDt1n6lL/WYtPISCMWSy6S2F7e
	 hem6s4g1cRioGsw+JzD6vlCm7w0YzHw2PKX+V8hEya7UXixBa40G9eL6xMwZu88xqUho8
	 mCLkkx6cr8vAmynKMoswngzwW1caA9jndpwe0h++1+b8KrRhikGt7MRKbJzB/47Tjab9+
	 xMENtvvk2JTXS49ZlM8y8SPL6bXlsFFY4E56VyHLZtIZWI0L+zDaYGWyJIKqJIOcCvzfx
	 T9smaQza0RJvv5P9T+UKt/hu3Nmz4T/oV/Z2zdCGxxzZ9wx4NLrJ8LXiq665lQ42HTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IsCfVMfq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FF7606A31A
	for <linux-xfs.vger.kernel.org@localhost.mlmmj>; Sat, 31 Oct 2026 23:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IsCfVMfq
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1E66513C0
	for <linux-xfs@vger.kernel.org>; Sat, 31 Oct 2026 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1793487680; cv=none; b=d3xKuwnQaW8WmrI1mWa3HZTI20g1AV9uOGmAPsxVAHmdhkNw5eacwE3gKS4ExDTyUTHZZCdl/IQ0uvNh+2wBhydirDrZhBDCJPLAxrCBWPuPxbKp5dS6rFCxvGyz+EJy48qWXrat9Nt1SX0GFZxhD+EYXRGAaJsev99upWThU60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1793487680; c=relaxed/simple;
	bh=H6dUIY/OtJAWjT+gZ54mOtTLl/glL/ZGV/2wVVU+jWE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aQFamJ9uEgG9YVjkd0nwCMDLxkqU8483zzVxNc9Yv6cryWxRc8FX05va9OIyZihpdpYs0zZxNYP+5gFYvNbmKVBGnknIS1jST+oMCwPcIA9MoGWAJmbJZBBFU3DUjAccdMGbfBhbQHKS9B84OLonGhKJV9MuajvRF8E64aL/jFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsCfVMfq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52813C2BCFF
	for <linux-xfs@vger.kernel.org>; Sat, 31 Oct 2026 23:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1793487679;
	bh=H6dUIY/OtJAWjT+gZ54mOtTLl/glL/ZGV/2wVVU+jWE=;
	h=From:To:Subject:Date:From;
	b=IsCfVMfqHz9qXP5GfDGzbhg7luE5RurTm7JOybiUXOifscnsoA1XB5fHJQv9f71D8
	 zkNeeQpfw+VnnRaQ3uyplaOVjKgheVe7MFHB1pWEF+8vhqjj81XrZPN6EE84qcIHwv
	 9iafoBIli0qtmlEWzWgofFvvV623Fg1BsEzmQxlI/2xNIAJys2Qt7VLtl+ZBQVquYu
	 YE75vY8CvsOVXAl72yJvThrm1rnjyTjq3BSabPVSsctYrp3D4jer98sXa9lMvfjJiq
	 AiaoEkHtzEP252vXxnCJJezbOCZo4lmzNl4spW0oNXsw9v01ZLtmvMHKyPHa68YN65
	 AToD2VobAdJUg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 38E6BCAB780; Sat, 31 Oct 2026 23:01:19 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222219] New: Support for option CPUAccounting= has been removed
Date: Sat, 31 Oct 2026 23:01:18 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: glitsj16@riseup.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-222219-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D222219

            Bug ID: 222219
           Summary: Support for option CPUAccounting=3D has been removed
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: glitsj16@riseup.net
        Regression: No

The CPUAccounting option has been removed in systemd for a while now.

Two of the service files in xfsprogs still refer to this deprecated entree.


Oct 31 22:25:20 systemd[1]: /usr/lib/systemd/system/xfs_scrub_all.service:2=
6:
Support for option CPUAccounting=3D has been removed and it is ignored


Oct 31 22:25:20 systemd[1]: /usr/lib/systemd/system/system-xfs_scrub.slice:=
15:
Support for option CPUAccounting=3D has been removed and it is ignored


$ dpkg -S /usr/lib/systemd/system/system-xfs_scrub.slice
xfsprogs: /usr/lib/systemd/system/system-xfs_scrub.slice


https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/system-xf=
s_scrub.slice#n15


$ dpkg -S /usr/lib/systemd/system/xfs_scrub_all.service
xfsprogs: /usr/lib/systemd/system/xfs_scrub_all.service


https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub=
_all.service.in#n26



Here's the Ubuntu bug report:
https://bugs.launchpad.net/ubuntu/+source/xfsprogs/+bug/2172690

HTH

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
