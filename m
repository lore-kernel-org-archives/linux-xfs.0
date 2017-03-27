Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33564 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbdC0R6W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:58:22 -0400
Subject: Re: [PATCH 0/2 V2] xfs_io: hook up statx
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <5245.1490608817@warthog.procyon.org.uk>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <07e3308b-11a8-90d4-4ac9-96c3c36d3c4a@sandeen.net>
Date: Mon, 27 Mar 2017 12:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <5245.1490608817@warthog.procyon.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On 3/27/17 5:00 AM, David Howells wrote:
> Eric Sandeen <sandeen@sandeen.net> wrote:
> 
>> These 2 patches are a second pass to add a statx command
>> to xfs_io in hopes that it will aid creation of xfstests
>> statx regression tests.
> 
> Would it be possible to redirect all the stat() calls made by xfstests to
> statx() with translation of the output buffer back to struct stat?

I'm sure LD_PRELOAD tricks could do that, but it'd be a little unusual
for xfstests, at least - kind of a side hack that's not really expected
and therefore wouldn't get consistently run.

Honestly, just write a bash script for xfstests which tests expected
statx behavior for various inputs, verifies what it can against stat,
and it's all good...

If you have xfstests-specific questions or problems we'll be happy
to help.

Thanks,
-Eric

> David
> 
