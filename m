Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EAC408028
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795193; cv=none; b=JmsrmKraKQgDXSelASDIMr3KRgVtN4LcFTXGE9p/1dx7TmuQMOxOGlyauTkSF5dO9zoudbxMrKaoCP73cvshBcBLkIxZyN8D2IKZKx1xBTGzECRpM0bUrgV0s/Nw++Ty8+cr7zgRjnWv7b8YFwvbARUxG1WGJS8IGhugdnb9ixg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795193; c=relaxed/simple;
	bh=m2GOhaykBp0qlH6zEwQn91M5hGh0L9KErQWd9AFdXCY=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=nhhTabc9i0dyBLPxuMfsG2sXDGUGtlzLzLbD/SKMO7Zkx04qJ+DCjVm51GtixcTS4rgvPIHInskqaisupVlYRhRowUJ4r5qoBduuQ+O5HB6eU21YoD+HMWVhPqPtJSAoufuNdvC4/Fvl/N8ZcV15l6AvA3W6GT/O5C25tVX7pCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hS1wNtyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hS1wNtyz"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 027B2C4AF17
	for <linux-xfs@vger.kernel.org>; Wed, 30 Sep 2026 19:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790795193;
	bh=m2GOhaykBp0qlH6zEwQn91M5hGh0L9KErQWd9AFdXCY=;
	h=From:To:Subject:Date:From;
	b=hS1wNtyzfFMxMPg1pzrG1QJC0Hr0rmRISR7sovPlrRSfMhGQ1PDUsuUOGgYo5mk77
	 IlftKPsbqUQdTBgBa9VchDlALwjEGsxz1GlSM8SCFke4E5ieHUHTOBp41+lE3e6ZBM
	 xUy6EI0ybaIb2uzVAUxHpdw96lRzJ6TOeS+lRv38r2D55BNYeYPf8B6axUrK5qux0E
	 KF8b8L29s2sEs7gYf8emPFbjZV77qMipnvJmgaA0dCusF6HeoXdlAWKvBExGn0pRWi
	 fSqsdLZBl/pDdFPg7DknxJCYaGosx/0OGh/RfupSaFig1qC/H1+HmhpMwPZQ/BGPsK
	 C4J0uQzLgruhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id DD5BDC53BC5; Wed, 30 Sep 2026 19:06:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 222081] New: xfs stops if link count is to high
Date: Wed, 30 Sep 2026 19:06:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sachse@gmx.net
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-222081-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D222081

            Bug ID: 222081
           Summary: xfs stops if link count is to high
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: high
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: sachse@gmx.net
        Regression: No

Created attachment 310977
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D310977&action=3Dedit
Kernel trace

Environment is an docker on a xfs with overlay.
Inside the docker a bitbake/yocto build is running.

Is link count reaches 552 an allocation error occours and the filesystem is
stopped.

Kernels: 6.18.28 and 6.18.48

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
