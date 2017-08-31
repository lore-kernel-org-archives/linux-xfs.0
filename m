Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from yrk.mx.bytemark.co.uk ([80.68.81.84]:42504 "EHLO
        yrk.mx.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbdHaKdr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 06:33:47 -0400
Subject: Re: XFS reflinks
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
 <20170829130046.GA28896@infradead.org> <20170829160308.GR4757@magnolia>
 <20170829162310.GA22552@infradead.org> <20170829220316.GD10621@dastard>
From: Chris Cottam <chris.cottam@bytemark.co.uk>
Message-ID: <3b025b43-3ca5-567f-d9e0-c45245d37ecb@bytemark.co.uk>
Date: Thu, 31 Aug 2017 11:33:44 +0100
MIME-Version: 1.0
In-Reply-To: <20170829220316.GD10621@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On 29/08/17 23:03, Dave Chinner wrote:
> On Tue, Aug 29, 2017 at 09:23:10AM -0700, Christoph Hellwig wrote:
>> On Tue, Aug 29, 2017 at 09:03:08AM -0700, Darrick J. Wong wrote:
>>> First, should we land the incore extent map rework (not that I've seen a
>>> patchset yet) so that the increased extent map fragmentation resulting
>>> from cow/dedupe don't overwhelm the memory allocator with high order
>>> allocations?  Incore extent map memory usage hasn't been an issue here...
>>
>> Working on this now, but so far this hasn't been a major issue.
>> The main workload where the extent list currently hurts and that
>> prompted my work in this area doesn't even involve reflinks (sparse
>> VM image).
> 
> Yup, that's a problem, and it's going to be even more of a problem
> once people start using reflink to snapshot sparse VM images. I
> think that the extent rework is probably the most important thing we
> need to solve for COW to be generally usable.

Assuming I was feeling brave, what should I be doing to limit the
chances of hitting this issue? Would smaller filesystems or lots of
memory on the host help etc?
Also what should I be monitoring to warn me before anything actually breaks?

Thanks for the help so far.

Chris
