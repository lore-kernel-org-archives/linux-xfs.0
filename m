Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFEB49AA22;
	Thu, 17 Sep 2026 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789636193; cv=none; b=PasuKJFrnHoyDxX78XyVrYj2lzy6L0cBEBA3RGQ7Wn6u+xbdG19ge1YEHdVniK42LjaqoaIyQNpqcedw2ATFPFkHX7TUfWd4IwSnT6h280Drs3waUVBGeZqaZ/8VmquWdloN+n+Kg/qiaJefkoLX9ukmlIyQtmcGIXMj1oFoBr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789636193; c=relaxed/simple;
	bh=a/nFbwjEIOju3X1MIW/sqlGlbwK5FvdVNYvXKi7Xlgo=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GYhsb3+lA5n0+16BoowBuR5up2VZNdBa4lZGnREh/FIzTSRQrWX82Kq6rrjaNRT3ZIwbyVzXkgimRLGTyNgttSv9SVQuAeQ50Xe70x6KOfTC3IxXsIO/Lwps78HDyi+6kvcGiuVZ+dJW1z7KobJQoymAUYXLMfrpJdAHX8RG50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ru9GCvTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ru9GCvTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105E01F000FF;
	Thu, 17 Sep 2026 09:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636192;
	bh=5vMJLxb2WgC5tIFea55buznoCzbmE9D2zqOOZHr4b34=;
	h=From:Subject:Date:To:Cc;
	b=Ru9GCvTohAXBBstl0Oex+tcL4dV1TFEds9pYcha8vwp3uXnuo6Bi4iRCjcMaYUc+X
	 FRaoT2J2ypp7jwP9fPqAlO/8jTWjT4ksZdMcaLNFBxXAspLv+oGpF0LfPNTAi4FeRt
	 4Q2/SIm6LLegLzIYwqwWdk/okWRmseIE3TDOfXCE5QKsTkdlIxWMOJJ4MgoXgzagyR
	 D3G+JLehh1359FDR5O9sk1BkGQKTU/1oPN6qAJf25VfXR3/OX8XHyxlc7t7ueaI1N/
	 lP61+MRN4zBiGK9O42ALPFdK1N7Cr5jEb6wskgo1qJAnOwL3dMe2iSuNiJ2MtPEWxZ
	 rwbNFtO1doZmA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/4] file: simplify and harden cleanup handling
Date: Thu, 17 Sep 2026 11:09:41 +0200
Message-Id: <20260917-work-file-fd_prepare-v1-0-b87534ca49f3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0WMywrCMBBFf6XM2oS20Gj8FRGZJBM7KmmZ+ILSf
 zfRhctzuPcskEmYMuybBYSenHlKBbpNA37EdCbFoTD0bW9a223Va5KrinwjFcNpFppRSBEO1ph
 gdmgHKNfiI7+/2cPxx/nhLuTvtVUXDjMpJ5j8WFWt6lrV/6quG1jXDxZPwXekAAAA
X-Change-ID: 20260917-work-file-fd_prepare-ea5966d68a95
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org, 
 wine-devel@list.winehq.org, linux-xfs@vger.kernel.org, 
 io-uring@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2102; i=brauner@kernel.org;
 h=from:subject:message-id; bh=a/nFbwjEIOju3X1MIW/sqlGlbwK5FvdVNYvXKi7Xlgo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStXhfJMm/N0WLv17efbFU+rraYVfylV+3zo4W9JoeUt
 rC+/ezh0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAnCRSYwMi+JkYraZzsnZOaXx
 0UUrBavd6ybar69ZsHjTIzYDdp1D3xgZrrx7/l/ZyezGU4H7pU9+Tpr0xWLmd7ErnyWOROy5EXb
 vHB8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The cleanup guards rely on unnecessary infrastructure and make the code
more complicated to follow than it needs to be. Clean it up. Also shrink
the struct a bit and get rid of the unnecessary error variable. We can
just make this more ergonomic by using fdf->fd directly. Also expose the
struct itself as const and hide the actual underlying local variable
behind a UNIQUE_ID() named variable so we avoid risking shadow variables
and polluting callsites. Code generation wise the outcome is exactly the
same but simpler.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (4):
      file: simplify FD_PREPARE()
      file: declare the FD_PREPARE() variable with __cleanup() directly
      cleanup: remove CLASS_INIT()
      file: make struct fd_prepare const and kill its err field

 arch/powerpc/platforms/cell/spufs/inode.c |  12 +--
 drivers/gpio/gpiolib-cdev.c               |  18 ++---
 drivers/gpu/drm/msm/msm_perfcntr.c        |   4 +-
 drivers/media/mc/mc-request.c             |   8 +-
 drivers/misc/ntsync.c                     |   6 +-
 fs/eventfd.c                              |   4 +-
 fs/eventpoll.c                            |   6 +-
 fs/file.c                                 |   8 +-
 fs/namespace.c                            |  12 +--
 fs/nsfs.c                                 |   4 +-
 fs/xfs/xfs_handle.c                       |   6 +-
 include/linux/cleanup.h                   |   7 --
 include/linux/file.h                      | 130 +++++++++++-------------------
 io_uring/mock_file.c                      |   8 +-
 kernel/bpf/bpf_iter.c                     |   6 +-
 kernel/bpf/token.c                        |   6 +-
 mm/userfaultfd.c                          |   6 +-
 net/core/scm.c                            |   8 +-
 net/handshake/netlink.c                   |   8 +-
 net/kcm/kcmsock.c                         |   6 +-
 20 files changed, 117 insertions(+), 156 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260917-work-file-fd_prepare-ea5966d68a95

