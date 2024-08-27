Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A848B158DCC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724792824; cv=none; b=a9BP6WTL1r2GKTwBrFXH72542YjDTvP0jsGn83uYTQV2fjlOj9wiKPdbYEe1QQ3oqL4V6sQRHb0kMfO2JO2cYv5FycsrLOVg6ovfGkOd1C7044SxABGcG4lWhQzWtFoEtn6fIhgBp+LVO9u7k0+ku3K6NO3JA6czbyi0yVPcrE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724792824; c=relaxed/simple;
	bh=XdAFM5Yyo5h5nzeSta3PCt1dAx9x28x6CCK8dfx2ujs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=TdqzP9FhLieQvAdheZ6WUl1QdBbHz8uBiMju6ug91M+qRm3i6qAKvdmpezHMvKLVlwuLuREh5kw3cuc/ZahdH4kMA+VeXRe2FpGI6myIqIEcqDMVFv13Fltd1Z+nsMzHS0ppeTiD49o7txakcPJ7NX1l/cQJhoSSOxQiQdaATCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jcbzE0j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jcbzE0j4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E0DAC4DDEA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 21:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724792824;
	bh=XdAFM5Yyo5h5nzeSta3PCt1dAx9x28x6CCK8dfx2ujs=;
	h=From:To:Subject:Date:From;
	b=jcbzE0j4+vKYt5vjhtSSTuoQFzDzs+/0xtJcGi9KN0GiciAh2Fk3P2Dx3OeBjJKZE
	 Zgztfq55ENtxFh/txVvcaVctG8RMRUOIG8OhBpH2jwoAh6c7jXmuLzO7cjXKI4uvpr
	 BDSM8V4U8TQY2Ql1xSgrGUssm+0ZPCb7e4XTk0X7q3dRk5lTW1yTRlmywznjqeLw6O
	 jPAYayxzryjPvl/0Jbbn1ve3vZpWXXuuo6hEWGpHZyuHBxmdwBep0jD05c1rGQtE75
	 AHv/UfvNZIFO5/jh/rDpVR9csW7Nrn7oImZPqRjVx/DeIJFPyFde1RPCixrBL5Qbqn
	 YEwMOgJck+GiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 185FCC53BC0; Tue, 27 Aug 2024 21:07:04 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219203] New: xfsprogs-6.10.0: missing cast in
 /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec) causes error in C++
 compilations
Date: Tue, 27 Aug 2024 21:07:03 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: kernel@mattwhitlock.name
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-219203-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D219203

            Bug ID: 219203
           Summary: xfsprogs-6.10.0: missing cast in
                    /usr/include/xfs/xfs_fs.h(xfs_getparents_next_rec)
                    causes error in C++ compilations
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: kernel@mattwhitlock.name
        Regression: No

C allows implicit casts from void* to any pointer type, but C++ does not. T=
hus,
when including <xfs/xfs_fs.h> in a C++ compilation unit, the compiler raises
this error:

/usr/include/xfs/xfs_fs.h: In function 'xfs_getparents_rec*
xfs_getparents_next_rec(xfs_getparents*, xfs_getparents_rec*)':
/usr/include/xfs/xfs_fs.h:915:16: error: invalid conversion from 'void*' to
'xfs_getparents_rec*' [-fpermissive]
  915 |         return next;
      |                ^~~~
      |                |
      |                void*


The return statement in xfs_getparents_next_rec() should have used an expli=
cit
cast, as the return statement in xfs_getparents_first_rec() does.

--- /usr/include/xfs/xfs_fs.h
+++ /usr/include/xfs/xfs_fs.h
@@ -912,7 +912,7 @@
        if (next >=3D end)
                return NULL;

-       return next;
+       return (struct xfs_getparents_rec *)next;
 }

 /* Iterate through this file handle's directory parent pointers. */

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
