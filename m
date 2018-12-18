Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33949 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbeLRBYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 20:24:45 -0500
Received: by mail-lj1-f196.google.com with SMTP id u89-v6so2040562lje.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Dec 2018 17:24:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20181215012259.28358-1-nbowler@draconx.ca>
References: <20181215012259.28358-1-nbowler@draconx.ca>
From: Nick Bowler <nbowler@draconx.ca>
Date: Mon, 17 Dec 2018 20:24:42 -0500
Message-ID: <CADyTPEzBC2xnUjY30hSM_vLZ5C=w7kX+KZe6QXZqhEPp6-zjKQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] Fixing xfs ioctls on x32
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

On 2018-12-14, Nick Bowler <nbowler@draconx.ca> wrote:
> Note that glibc's fallocate wrapper appears to be buggy on x32,
> which causes several test failures.  I hacked around that in xfs_io
> (the fallocate syscall itself appears to work perfectly fine on x32)
> to get a cleaner test run.  Obviously this bug should be fixed but
> it doesn't appear to be a kernel or xfsprogs problem.

Update: turns out this bug has already been fixed in glibc 2.27.

Cheers,
  Nick
