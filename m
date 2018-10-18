Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728141AbeJRVST (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Oct 2018 17:18:19 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] vfs: Fix crashes when reading /proc/mounts
Date: Thu, 18 Oct 2018 15:17:07 +0200
Message-Id: <20181018131709.11976-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ted Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

Hello,

this patch series aims at fixing possible races between functions formatting
output for /proc/mounts and friends and remount. Especially ->show_options
functions of filesystems are not counting with the fact that options can
change under them and thus races can result in bogus output or outright
crashes (like was the case with ext4 handling of quota mount option, or udf
could crash when printing charset name, or xfs when printing log device name
etc.).

Admittedly the patch 2/2 is somewhat ugly because namespace_sem ranks below
sb->s_umount semaphore but I think it is bearable. Al, what do you think?

								Honza
