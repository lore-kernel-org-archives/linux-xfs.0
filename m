Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:57286 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdIKQqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2017 12:46:33 -0400
Date: Mon, 11 Sep 2017 12:46:29 -0400
From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: WARN_ON_ONCE in fs/iomap.c:993
Message-ID: <20170911164629.4kuuqgklyelld7am@codemonkey.org.uk>
References: <CAASgV=ugG=Chc5RK4CK-=FsVm+9UEd-2kSTxQrZFG90bYHpMpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAASgV=ugG=Chc5RK4CK-=FsVm+9UEd-2kSTxQrZFG90bYHpMpw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shankara Pailoor <sp3485@columbia.edu>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Zhu Aday <andrew.aday@columbia.edu>, syzkaller <syzkaller@googlegroups.com>, viro@zeniv.linux.org.uk

On Mon, Sep 11, 2017 at 06:56:05AM -0400, Shankara Pailoor wrote:
 > Hi,
 > 
 > I am fuzzing linux 4.13-rc7 with XFS using syzkaller on x86_64 and I
 > found the following warning:
 > 
 > WARNING: CPU: 2 PID: 5391 at fs/iomap.c:993 iomap_dio_rw+0xc79/0xe70
 > 
 > Here is a reproducer program: https://pastebin.com/tc014k97

pwrite in one thread, sendfile on another. Same thing trinity has been hitting.
 
See thread "Subject: Re: iov_iter_pipe warning".

	Dave

