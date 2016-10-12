Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933957AbcJLSka (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Oct 2016 14:40:30 -0400
From: "Benjamin Coddington" <bcodding@redhat.com>
Subject: Re: SEEK_HOLE second hole problem
Date: Wed, 12 Oct 2016 14:40:06 -0400
Message-ID: <4639FD81-EE17-4497-AB45-CC87348AE4F1@redhat.com>
In-Reply-To: <8273699b-8f7d-e7b9-492f-77cbb4f74ec5@sandeen.net>
References: <2303295B-3B56-404D-BAE3-A644D67EEC49@redhat.com>
 <8273699b-8f7d-e7b9-492f-77cbb4f74ec5@sandeen.net>
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On 12 Oct 2016, at 13:06, Eric Sandeen wrote:

> On 10/12/16 11:15 AM, Benjamin Coddington wrote:
>> While investigating generic/285 failure on NFS on an XFS export I think I
>> found a seek hole bug.
>>
>> For a file with a hole/data pattern of hole, data, hole, data; it appears
>> that SEEK_HOLE for pattern chunks larger than 65536 will be incorrect for
>> seeking the start of the next hole after the first hole.
>
> [sandeen@sandeen ~]$ ./bcodding testfile
> SEEK_HOLE found second hole at 196608, expecting 139264
> [sandeen@sandeen ~]$ xfs_bmap testfile
> testfile:
> 	0: [0..135]: hole
> 	1: [136..383]: 134432656..134432903
> 	2: [384..407]: hole
> 	3: [408..543]: 134432392..134432527
>
> the numbers in brackets are sector numbers, so there is a hole
> at 0, blocks at 69632, hole at 196608, and more blocks at 208896.
>
> As bfoster mentioned on IRC, I think you are seeing xfs's speculative
> preallocation at work; more data got written than you asked for,
> but there's no guarantee about how a filesystem will allocate
> blocks based on an IO pattern.
>
> The /data/ is correct even if a zero-filled block ended up somewhere
> you didn't expect:

OK, this makes sense.  It's clear my understanding of a "hole" was off --
we're really looking for the next unallocated range, not the next unwritten
or zero range. Like me, generic/285 seems to have gotten this wrong too, but
the short allocation sizes aren't triggering this preallocation when used
directly on XFS.  For NFS the larger st_blksize means we see the
preallocation happen.

Thanks Eric,
Ben
