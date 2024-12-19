Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBE618C33C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734627733; cv=none; b=ozkoXy19P4hhq9FC5sWzRVj6aVuODIc25hERn2io9chBFzAHbQfkj7/s2JMyRvs0jvPsF6uXdx38LWQ2F6JY66+fC9saT/BD7/m4yubDf7BAEFoARB9+jBT0ulFY8hGqX7KdoCaGLhDAawb/6KuIw/RZc+5J4ymG7aDCmXJ0x0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734627733; c=relaxed/simple;
	bh=jzH0iQYYMJez1U0jypLUPv30THgCfXDmXV9dDbHJVkw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MpVJ63b/aQUsVB8tcUMc3LCU55rzOd7L1FG/bpnsK7Uv0u4vArgBmwJfq19G7Z6LqCHna11oxc4FiW0G8VG43+Yp4GXitAzIqja9WqAJII/SMsjr3LeVmQPi3J5+6N/DZNajFTGPOlSYsf+zJGkXu1fgc9D/kvSbm5PcagUcq/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrFf3Ejw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrFf3Ejw"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9832DC4CEDE
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734627732;
	bh=jzH0iQYYMJez1U0jypLUPv30THgCfXDmXV9dDbHJVkw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rrFf3Ejwh9JSvbH9obtt/+JOJH3gYk4RWXSffYzIlKd9A51xDFp6BANoAlqxyruod
	 JVzc8Me7xdn82AwLdXvKMGLIUyPZtFFZXiN8flO0wsXSq+0MrnkK26IPcAL0CYgzTK
	 Q9lXm9xoV6RLmWbVpwvM2wFlKGHxjphFGdDgFnADOCk3zPfQ/Nh8mlMVve2gnpMfPj
	 hQxBEWsvLeQzW1ZCS/2kcK2aAjHGtJe/I4BCn7pHE2UCB9pikakIvGTzSTN/Vh6d0X
	 GDUXWusdtWVMc7cveR+dqPxk9a+5W0w/tK6sclxI8ia1Db1C5sNhFog+xu98EMR/Pk
	 e+SaXHAb/uA8w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 8B35CC41606; Thu, 19 Dec 2024 17:02:12 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [Bug 219504] XFS crashes with kernel Version > 6.1.91. Perhaps
 Changes in kernel 6.1.92 (and up) for XFS/iomap causing the problems?
Date: Thu, 19 Dec 2024 17:02:12 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: speedcracker@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: component product
Message-ID: <bug-219504-201763-8aG5ZdMELJ@https.bugzilla.kernel.org/>
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

Mike-SPC (speedcracker@hotmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
          Component|Other                       |Other
            Product|IO/Storage                  |File System

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
