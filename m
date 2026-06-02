Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2537EFE2;
	Tue,  2 Jun 2026 10:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395022; cv=none; b=q93NuGytkaRHq+U6NZRrRJKFfhcWYOvz0gqLeWnVhDFWoBbTVnMJAE06bWNWQWnupaS5coR0JH4QL/pg8QCdk6WmwT0nz5UmOeq/GydSGcnoV+PcYYJQcqlgUlshXqEEkpYv9MupjQZm5VLTQCY+B7WWDbP6UPbhHWLhnMv7lJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395022; c=relaxed/simple;
	bh=8PAOYH0N838UHayA/tOONu2IcWfdoIg+edZyFkLDa8o=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=aBVaKIhRuFzO7d96YbbuWIg0ElqAO97dznr5EgUWB191j4A4pPOHCgJpALqnpk0BWu0NChvV7UqUKKGAYjZiCPbCRN67CcXMZikgVbXvTMIBXQYfVDuktOwTZKvNVRmaY9LFOTtfAdud56tkh3X1J/WGMIG9UL1+iqi5VUlk/0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4YSpK4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4YSpK4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2201F00893;
	Tue,  2 Jun 2026 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780395020;
	bh=0sPLzsNzNrE5sYBDRc7UQyK3KG2m+vueA9urvjX/WEs=;
	h=From:Subject:Date:To:Cc;
	b=S4YSpK4f2pH92GwKlT/TH7osx/3MRT19koRieRsuI8QrPrzw9Y4FYYnYq0otMcoyp
	 VSHl8KQnZDBBKDmDUPyKjCMUWJ6ZGoOengV4oTpi2xqiMC4Yjmy78OEQcCssvY+VZu
	 DqL0TX5jcsKhAYFp0YcTJIZz7cPNS7drfGUuWJbMB9lNcwUoC7WbeQWEf0vvEytf4g
	 E2hEwx3SZQkoNeSkVDldR9nbV1lcHQM+HfWvflJSfugCh/uOt4BzAXg3uR21ZxXMDF
	 TQG+Ip0ZgtZRMEhGNLTRZiLwK11BdWG0F8eUdP2xTsna7AngAggXRan6Z6nnT86IXO
	 VpU0aTWvxNBfQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 0/8] fs: support freeze/thaw/mark_dead/sync with shared
 devices
Date: Tue, 02 Jun 2026 12:10:06 +0200
Message-Id: <20260602-work-super-bdev_holder_global-v1-0-bb0fd82f3861@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAP+rHmoC/yWM0QqCQBAAf0X2uRU90KLXoA/oNUJu7za9Mk921
 QLx39N6nGGYGZQlsMIxmUF4Chpit0K+S8A1tqsZg18ZTGbKrMwMvqM8UceeBcnzVDWx9SxV3Ua
 yLR4c2YILQ+wLWB+98D18fv8rXM4nuP2ljvRgN2znLSOrjCS2c82mXlYHlnTapzmKy2FZvtNKv
 tmoAAAA
X-Change-ID: 20260602-work-super-bdev_holder_global-8cba5e52bed5
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, 
 linux-xfs@vger.kernel.org, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
 Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-fffa9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2309; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8PAOYH0N838UHayA/tOONu2IcWfdoIg+edZyFkLDa8o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJreG4GXYx+0Zi52NGHc+ynRf2b+1hern5Se/Jry/CN
 IQiT9qzdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzktTsjw7bF/kr3QxgvK7a9
 qGtq7bnpZLzseI7IvqWc+y5dOfCuehYjw8kbi46lLWmzqL7e/awsJuK+hcjZUx3XwhU5tbNsg4Q
 ucwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Note, this is on the border between RFC/POC and so I haven't pushed this
through testing yet. But I don't want to waste more time on this before
showing it.

I surveyed various fs implementations because I want the ability to
extend userspace the ability to manage what devices can be onlined in a
centralized way without having to force every fs to care about this.

I realized that erofs allows sharing block devices with multiple
superblocks. Any freeze, thaw, removal, or sync on those devices will
not be communicated to the superblocks using it and our current
infrastructure is unable to deal with this.

This attempts to add the ability to go from device number to all the
superblock using that device, iterate through them one-by-one and
perform actions on them. For most fses this is a 1:1 mapping but for
erofs its a 1:many mapping.

This is not unreasonable infastructure to support in my opinion. I
played around with some ideas for this and I want to send out an RFC to
gather some early input.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (8):
      fs, block: move blk_mode_t and fop_flags_t into <linux/types.h>
      fs: add a global device to super block hash table
      fs: refuse to claim any frozen block device
      xfs: port to fs_bdev_file_open_by_path()
      btrfs: open via dedicated fs bdev helpers
      ext4: open via dedicated fs bdev helpers
      erofs: open via dedicated fs bdev helpers
      super: make fs_holder_ops private

 fs/btrfs/dev-replace.c   |   6 +-
 fs/btrfs/ioctl.c         |   4 +-
 fs/btrfs/volumes.c       |  26 ++-
 fs/erofs/data.c          |   6 +
 fs/erofs/internal.h      |  10 ++
 fs/erofs/super.c         |  66 +++++--
 fs/erofs/zdata.c         |  10 +-
 fs/ext4/super.c          |  12 +-
 fs/super.c               | 452 ++++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_buf.c         |   2 +-
 fs/xfs/xfs_super.c       |  10 +-
 include/linux/blkdev.h   |   9 -
 include/linux/fs.h       |   2 -
 include/linux/fs/super.h |   7 +
 include/linux/types.h    |   2 +
 15 files changed, 433 insertions(+), 191 deletions(-)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260602-work-super-bdev_holder_global-8cba5e52bed5

