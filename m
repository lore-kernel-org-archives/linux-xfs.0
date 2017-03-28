Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33813 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754313AbdC1Hah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 03:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <5245.1490608817@warthog.procyon.org.uk>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net> <5245.1490608817@warthog.procyon.org.uk>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 28 Mar 2017 03:30:20 -0400
Message-ID: <CAOQ4uxgBkNRzJkE7qVjv_Ej0LBRHzG_7=1qd4uW62SH1kO1DMQ@mail.gmail.com>
Subject: Re: [PATCH 0/2 V2] xfs_io: hook up statx
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 27, 2017 at 6:00 AM, David Howells <dhowells@redhat.com> wrote:
> Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> These 2 patches are a second pass to add a statx command
>> to xfs_io in hopes that it will aid creation of xfstests
>> statx regression tests.
>
> Would it be possible to redirect all the stat() calls made by xfstests to
> statx() with translation of the output buffer back to struct stat?
>

David,

xfstests is all 99% bash scripts and most of the uses of stat(2) are
by executing
stat(1), so all you have to do in order to exercise a statx() with existing
tests is install a stat executable in your path that uses statx()
instead of stat().

For that purpose, the xfs_io patch does not really help you because it does
not provide the stat -c output formatting options, which the tests expect.

This may not be enough long term, but it could be a nice validation.

xfs_io -c statx would be useful to write new xfstests that exercise
statx specifically.

It sounds like you are new to xfstests?
What you probably want to run is ./check -g quick.
xfstests is not extensively documented, but it quite simple, so it
usually "just works".
Let us know if you have troubles staring up.

Cheers,
Amir.
