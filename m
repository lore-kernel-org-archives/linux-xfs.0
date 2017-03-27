Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdC0KBR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 06:01:17 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: Re: [PATCH 0/2 V2] xfs_io: hook up statx
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5244.1490608817.1@warthog.procyon.org.uk>
Date: Mon, 27 Mar 2017 11:00:17 +0100
Message-ID: <5245.1490608817@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

Eric Sandeen <sandeen@sandeen.net> wrote:

> These 2 patches are a second pass to add a statx command
> to xfs_io in hopes that it will aid creation of xfstests
> statx regression tests.

Would it be possible to redirect all the stat() calls made by xfstests to
statx() with translation of the output buffer back to struct stat?

David
