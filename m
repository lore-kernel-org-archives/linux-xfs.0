Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37506 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758950AbcJ1KMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2016 06:12:03 -0400
Received: by mail-wm0-f48.google.com with SMTP id 140so68392683wmv.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Oct 2016 03:12:02 -0700 (PDT)
Subject: Re: discard improvements
References: <1476735753-5861-1-git-send-email-hch@lst.de>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <64a1c5dc-4a36-1ef6-606e-b382d36161ef@scylladb.com>
Date: Fri, 28 Oct 2016 13:11:55 +0300
MIME-Version: 1.0
In-Reply-To: <1476735753-5861-1-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Cc: michaelcallahan@fb.com

On 10/17/2016 11:22 PM, Christoph Hellwig wrote:
> iThis series improves XFS discard support so that we don't stall the
> log commit thread and improve performance for workloads with lots
> of deletions.
>
> The first patch is a fix for a long-standing allocator issue when we
> have busy extents in the way of an allocation.  Without the async
> discard support it was harder to hit, but it's basically been there
> since we added busy extent tracking and non-synchronous delete
> transactions.
>
> The second patch is the main async discard support, and the third
> one allows to batch up multiple extents into a single discard bio,
> which is a common occurance.
>

With these patches, is it reasonable to run with discard enabled, or is 
more work needed?
