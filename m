Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f50.google.com ([209.85.208.50]:45782 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbeJAVKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 17:10:37 -0400
MIME-Version: 1.0
From: Joshi <joshiiitr@gmail.com>
Date: Mon, 1 Oct 2018 20:02:17 +0530
Message-ID: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
Subject: cross-fs copy support
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org

I was wondering about the cross-fs copy through copy_file_range.
It seems current implement has below check, that disables such copy.

1577         /* this could be relaxed once a method supports cross-fs copies */
1578         if (inode_in->i_sb != inode_out->i_sb)
1579                 return -EXDEV;

May I know what are the thoughts behind disabling cross-fs copy?
Code has the comment "once a method supports", but that leaves me
wondering exactly what 'method' is expected, and from whom.

I disabled the check, and copy across volumes seemed to work fine. At
least for a single file (1G size), with no data mismatch, and faster
speed than regular copy.

-- 
Joshi
