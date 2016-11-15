Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932518AbcKONlU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Nov 2016 08:41:20 -0500
Subject: Re: [PATCH 05/16] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
 <20161115101650.GE1607@infradead.org>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <47f53245-13eb-f77a-f9d8-f532efc907fe@redhat.com>
Date: Tue, 15 Nov 2016 07:41:19 -0600
MIME-Version: 1.0
In-Reply-To: <20161115101650.GE1607@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 11/15/16 4:16 AM, Christoph Hellwig wrote:
> On Fri, Nov 04, 2016 at 05:08:30PM -0700, Eric Sandeen wrote:
>> >From c400ee3ed1b13d45adde68e12254dc6ab6977b59 Mon Sep 17 00:00:00 2001
> 
> It should claim to be from Eric here I think..

> And mention that it's a port from a kernel commit.

I suppose - do we have a clear policy on that?  What should the format
be for kernel<->userspace cross-ports in terms of From:, SoB:, etc?

I guess the libxfs-apply script in tools/ implicitly defines that, i.e. -

        # We want to format it like a normal patch with a line to say what repo
        # and commit it was sourced from:
        #
        # xfs: make several functions static
        #
        # From: Eric Sandeen <sandeen@sandeen.net>
        #
        # Source kernel commit: 0d5a75e9e23ee39cd0d8a167393dcedb4f0f47b2
        #
        # <body>

-Eric

 
> Otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

