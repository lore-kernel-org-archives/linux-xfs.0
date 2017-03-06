Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38434 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdCFMCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 07:02:03 -0500
Received: by mail-it0-f43.google.com with SMTP id m27so48345569iti.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2017 04:02:02 -0800 (PST)
MIME-Version: 1.0
From: Bill McDuck <billmcdave@gmail.com>
Date: Mon, 6 Mar 2017 12:02:01 +0000
Message-ID: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
Subject: Significantly longer fallocate times with Flag Unwritten Extents disabled
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello.

I have been testing the performance of XFS with "Flag Unwritten
Extents" enabled and disabled.

For security reasons I know XFS flags all unwritten extents by
default, so that uninitialized disk space cannot be read by the user.
In my application I actually want to have access to this uninitialized
disk space. I have been modifying the superblocks using xfs_repair to
enable this functionality.

Interestingly, I have found that creating a 10 GB file using fallocate
is significantly slower with unwritten flag extents disabled.  For
instance, creating a 10GB file takes 32 seconds on my (slow) machine,
whereas with the flag enabled, the process is almost instantaneous.

Does anyone know why creating an uninitialized file is so much slower
when the unwritten extents flag functionality is disabled?  I know
that the disk is not being initialized to zero, as I can read back non
zero content.

For my application I'm interested in creating large uninitialised
files quickly, so I'm very interested to know what additional
operations are being performed with the flagging disabled.

Thanks for the help.

Bill.
