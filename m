Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34172 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbdATKxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 05:53:01 -0500
Received: by mail-oi0-f52.google.com with SMTP id m124so41004730oif.1
        for <linux-xfs@vger.kernel.org>; Fri, 20 Jan 2017 02:53:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170120100504.GD32659@infradead.org>
References: <1484904118-17703-1-git-send-email-amir73il@gmail.com> <20170120100504.GD32659@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Jan 2017 12:53:00 +0200
Message-ID: <CAOQ4uxhW=dxCVEc3Fybapu_QFk=qE69e2OX0eGRtXnsgOKnWGQ@mail.gmail.com>
Subject: Re: [PATCH] xfs_io: fix missing syncfs command
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Fri, Jan 20, 2017 at 12:05 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Oops..  Time to add tests that use syncfs :)
>

Was just about to when I saw this surprise..

problem is. I only figured out an easy way to test using xfs stats:
https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs.sh

and I am wondering what would be a more generic way to test it.
This test case fails to flush xfs log on syncfs from overlayfs over xfs,
which is why I wrote it.
