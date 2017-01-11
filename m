Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33371 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759547AbdAKO2o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 09:28:44 -0500
Received: by mail-oi0-f65.google.com with SMTP id j15so22090036oih.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 06:28:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1dec16e5-66ea-1876-1105-2219b6f1c17c@sandeen.net>
References: <20170110194249.GK14038@birch.djwong.org> <CAOQ4uxggOoFJ_KR40XX2hU+bSr9zqXu9y_7HWqVxTfQ6ETC4hA@mail.gmail.com>
 <CAOQ4uxj+H4ZAXkPgob5ANJW=BDBzj6P2nKbb3aE9w1igGmcRfw@mail.gmail.com> <1dec16e5-66ea-1876-1105-2219b6f1c17c@sandeen.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Jan 2017 16:28:43 +0200
Message-ID: <CAOQ4uxh2WZ4XQKEu6Rb82XSu5MuH+Yt7bCEwRZy48TQAM8Y_WA@mail.gmail.com>
Subject: Re: [RFC PATCH] xfs_db: sanitize geometry on load
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

On Wed, Jan 11, 2017 at 4:09 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 1/11/17 4:01 AM, Amir Goldstein wrote:
>> Now I am hitting these xfs_db crashes during xfs/1316, which are apparently not
>> related to OOM killer. I have seen them last run as well but dmesg is quiet now.
>
> Please install debug bits and get a proper coredump, or try valgrind,
> to get a real backtrace here so we can see what's going on...
>

Since this is the second run where I am getting the same core dumps
(and they happen many times during xfs/1316 I doubt that this is not
reproducible on any system.

Anyway, scrub tests are still running and will be running for a while,
so I can re-run 1316 tomorrow to get the coredump.
Is there a standard configure/make way to install the xfsprogs debug binaries?
