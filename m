Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752495AbcJNKYo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Oct 2016 06:24:44 -0400
From: "Benjamin Coddington" <bcodding@redhat.com>
Subject: Re: SEEK_HOLE second hole problem
Date: Fri, 14 Oct 2016 06:24:39 -0400
Message-ID: <879EDADE-C646-4173-A3FD-253D11470799@redhat.com>
In-Reply-To: <20161012205405.GE27872@dastard>
References: <2303295B-3B56-404D-BAE3-A644D67EEC49@redhat.com>
 <8273699b-8f7d-e7b9-492f-77cbb4f74ec5@sandeen.net>
 <4639FD81-EE17-4497-AB45-CC87348AE4F1@redhat.com>
 <20161012205405.GE27872@dastard>
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On 12 Oct 2016, at 16:54, Dave Chinner wrote:
>> Like me, generic/285 seems to have gotten this wrong too, but
>
> The test isn't wrong - it's just a demonstration of the fact we
> can't easily cater for every different allocation strategy that
> filesystems and storage uses to optimise IO patterns and pervent
> fragmentation.

Regarding generic/285 -- I'd like to have it work for NFS.  Maybe using
SEEK_DATA to discover an appropriate allocation size for filesystems
exported by NFS could work by writing to increasing offsets until a seek for
data from the beginning of the file reveals the second allocation.

That seems to work for xfs, ext4, btrfs, and tmpfs exports.  I'll send a
patch with that to fstests.

Ben
