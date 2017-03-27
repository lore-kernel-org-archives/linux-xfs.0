Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34290 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdC0SF5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Mar 2017 14:05:57 -0400
Subject: Re: [PATCH 0/2 V2] xfs_io: hook up statx
References: <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <5245.1490608817@warthog.procyon.org.uk>
 <07e3308b-11a8-90d4-4ac9-96c3c36d3c4a@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f365c442-23be-447d-b1ad-36b394e3d71c@sandeen.net>
Date: Mon, 27 Mar 2017 13:05:49 -0500
MIME-Version: 1.0
In-Reply-To: <07e3308b-11a8-90d4-4ac9-96c3c36d3c4a@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>



On 3/27/17 12:47 PM, Eric Sandeen wrote:
> On 3/27/17 5:00 AM, David Howells wrote:
>> Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>>> These 2 patches are a second pass to add a statx command
>>> to xfs_io in hopes that it will aid creation of xfstests
>>> statx regression tests.
>> Would it be possible to redirect all the stat() calls made by xfstests to
>> statx() with translation of the output buffer back to struct stat?
> I'm sure LD_PRELOAD tricks could do that, but it'd be a little unusual
> for xfstests, at least - kind of a side hack that's not really expected
> and therefore wouldn't get consistently run.

(and thinking about it a bit more, s/stat/statx/ would be the barest
of bare minimum testing - it leaves out verification of all the
interesting behaviors of the new interface...)

-Eric
