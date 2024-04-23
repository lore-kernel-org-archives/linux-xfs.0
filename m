Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE221B299
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 03:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713842673; cv=none; b=JoSSrU3P2EVOwfPsIG7Ham8ls/xDVKIwlwnZLfA7KjNl3sOQkUT8lMR7rEH3Ibpts592PIZoszQznfDljtyS+B0mSXOhzCfhsW868b0cXmrLpvCVnMbg60VCZW0QK8EGqbnfpQ+zhw+4Djv34/ihtCK+EU4wK0uHbtXm0GHyWcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713842673; c=relaxed/simple;
	bh=uz3sO02YWwgZDT03fveGkyuGF/c5d2u3uHtlKe3+/lE=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CPq/bAroHtVXxZsn3SWUK8dSPuhZEvHet/4TnM3rhAFdcLRD7fMyjUU5KVAZQ/WjL6hb5+A28BWhnsibc7tKyrxoLpW6IPrdRHvBwfBWstmzo8269/PnEVk49h7iyxrAvquDgc3UrOmqZfsa2XEVt5iUsRgf3p7EUA/cEZDab2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jki9UAGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jki9UAGi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC6DEC32781
	for <linux-xfs@vger.kernel.org>; Tue, 23 Apr 2024 03:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713842672;
	bh=uz3sO02YWwgZDT03fveGkyuGF/c5d2u3uHtlKe3+/lE=;
	h=From:To:Subject:Date:From;
	b=jki9UAGiUomPp50LeeEaV/uECgJEL5XwBWvprjpBZL9cszSE4LuLfAL93QsesLHmh
	 MGxqlzxgtpbDaB+2jc2lx+Mw7VJc9R23gie+PWvMAYydG6SV1v5vaSPk338K3OMJEe
	 c0/b5q87IhzQhfUWXGm06pxbfVefpwHSf55sAuocJbWmIuB5sBtT6cO/np6sRpnNWw
	 KEPDXUot37jOf9qiAn+LMVWWIzwe/zA4QVeHjDrzVEYY53CZo+er/1N6jpCpBjDsbk
	 T9a5un4/ZAAq+U1lWJU0zbFrw3odYD+O7Ms8AD8ZaX1lhFLtTHwkLeNgQOjYXHNV44
	 sIu/lmjkJaITA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id D54A7C433E2; Tue, 23 Apr 2024 03:24:32 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 218764] New: xfs_scrub_all.in: NameError: name 'path' is not
 defined
Date: Tue, 23 Apr 2024 03:24:32 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: 60510scott@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression attachments.created
Message-ID: <bug-218764-201763@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=3D218764

            Bug ID: 218764
           Summary: xfs_scrub_all.in: NameError: name 'path' is not
                    defined
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: 60510scott@gmail.com
        Regression: No

Created attachment 306198
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D306198&action=3Dedit
journalctl -b -u xfs_scrub_all.service

`path` variable is not defined in
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub=
_all.in#n166


Attached is the error log of `xfs_scrub_all.service`

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
