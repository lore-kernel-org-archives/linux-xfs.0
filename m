Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5321C728F
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 11:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732189774; cv=none; b=J+kBaniCxsEA8SHyO8bZObXjwuEO64m3zWmLVRKdicjlkmfxha8kiR025ICJCLrmt2V8097w6rRvXWml634u0fhpFTz73Xy39hsH37/cTA8MbMojrOCcPHBsrbS3lN8cl+tuVxlVk2vs5mg2rUXcbwtS67FnKUQZLTHDathabIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732189774; c=relaxed/simple;
	bh=i1ASXbR/DjSykTaP6qqvQ8A1N8wKWZ666y/LYxYgfIA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aa667UMOFR+8N21oJjB6vkCgf6k4zMawwDRB0iaau8DBSB56p4X3G/NEyjwCAZ0EDBtwsisg/ntYK4h1TqJa1YFe65Wj72IE8iGQFLnFuR5IHjXvh+BkH9ECQ/ZZJ/JhM9GU8nQtZhq7DL/ArhH1T+omxK1o1paH9EFcji+GKs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpwFMzx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpwFMzx3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0923C4CED6
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 11:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732189773;
	bh=i1ASXbR/DjSykTaP6qqvQ8A1N8wKWZ666y/LYxYgfIA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cpwFMzx3SHSnR5gjx5EUK22OB65RDTlJssdbmtIfCZ7JOAVQ0u4B87UOz08mPI+6k
	 DMMefMKmCKe05NGFWbKZlLYiaSzKog2aUSuWqo31DUP5/cV4EvyiWQQfVpVwQGmZIr
	 ghhSC7dYgdQywgOBAutZd9GnGxyuvp5Ac6UUzw7Zgvaoa8XvqPUGpDxqY8RkmdDjPP
	 kD+3SQF7fTTZJOQiFJlWEcutTSjhe7Dbf7bkfWAVJkR32wkYwK9I7ABrD0weQdkkbF
	 MJo8SMiXzoi+b8kEjvXIKu/k7/WFTzQl969jOuLmX9P9H33EdOms42G54l1cuncFX6
	 80DEeXbLFNsng==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id B5704C53BBF; Thu, 21 Nov 2024 11:49:33 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] XFS crashes with kernel Version > 6.1.91. Perhaps
 Changes in kernel 6.1.92 for XFS/iomap causing the problems?
Date: Thu, 21 Nov 2024 11:49:33 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: leo.lilong@huawei.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-219504-201763-vTyDamg688@https.bugzilla.kernel.org/>
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

Long Li (leo.lilong@huawei.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |leo.lilong@huawei.com

--- Comment #1 from Long Li (leo.lilong@huawei.com) ---
Hi, Mike:

Look at the code of 6.1.106:

 970                 /*
 971                  * If there is no more data to scan, all that is left =
is
to
 972                  * punch out the remaining range.
 973                  */
 974                 if (start_byte =3D=3D -ENXIO || start_byte =3D=3D scan=
_end_byte)
 975                         break;
 976                 if (start_byte < 0) {
 977                         error =3D start_byte;
 978                         goto out_unlock;=20
 979                 }
 980                 WARN_ON_ONCE(start_byte < punch_start_byte);
 981                 WARN_ON_ONCE(start_byte > scan_end_byte);
 982=20=20=20=20=20=20=20=20=20
 983                 /*
 984                  * We find the end of this contiguous cached data rang=
e by
 985                  * seeking from start_byte to the beginning of the next
hole.
 986                  */
 987                 data_end =3D mapping_seek_hole_data(inode->i_mapping,
start_byte,
 988                                 scan_end_byte, SEEK_HOLE);
 989                 if (data_end < 0) {
 990                         error =3D data_end;
 991                         goto out_unlock;
 992                 }
 993                 WARN_ON_ONCE(data_end <=3D start_byte);=20=20
 994                 WARN_ON_ONCE(data_end > scan_end_byte);
 995=20
 996                 error =3D iomap_write_delalloc_scan(inode,
&punch_start_byte,
 997                                 start_byte, data_end, punch);

Looking at your warning stack, it reminds me of a problem[1] I tried to sol=
ve
before, but it seems different. In my case, there was only a warning on line
993. Perhaps it's not the same issue. Below is a link to my attempted fix
patch, which wasn't accepted, but hopefully it can be helpful to you.

[1]
https://patchwork.kernel.org/project/xfs/patch/20231216115559.3823359-1-leo=
.lilong@huawei.com/

Long Li

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
