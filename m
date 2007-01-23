Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 07:44:36 -0800 (PST)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.238])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NFiUqw023519
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 07:44:31 -0800
Received: by wx-out-0506.google.com with SMTP id t4so1560680wxc
        for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 07:43:36 -0800 (PST)
Message-ID: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com>
Date: Tue, 23 Jan 2007 16:16:59 +0100
From: "Peter Gervai" <grinapo@gmail.com>
Subject: how to sync / commit data to disk?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

[Tried to search archieves, found nothing, probably my keywords are bad. :-)]

What is the recommended way to make sure that a file is written
physically to the disk? (apart from the cache of the disk.)

This problem seem to have arisen in grub bootloader under Debian linux
(and most probably everywhere else): it must be sure that the copied
files are there, and can be addressed by C/H/S and modified there, at
the given sector address.

My educated guess would be
xfs_freeze -f
sync
xfs_freeze -u

but I give a large chance to be wrong about it.

Ideas?

Please cc on me if possible. Thanks.

-- 
 byte-byte,
    grin
