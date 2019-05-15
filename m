Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40502 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfEOMi6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:38:58 -0400
Subject: Re: [PATCH 05/11] libxfs: de-libxfsify core(-ish) functions.
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-6-git-send-email-sandeen@redhat.com>
 <b78a858b-8be1-ced1-0f16-f4a916a2e2ca@sandeen.net>
 <20190515065215.GE29211@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7c001628-3557-12e5-dec8-60ff525008d9@sandeen.net>
Date: Wed, 15 May 2019 07:38:56 -0500
MIME-Version: 1.0
In-Reply-To: <20190515065215.GE29211@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org



On 5/15/19 1:52 AM, Christoph Hellwig wrote:
> On Fri, May 10, 2019 at 04:41:03PM -0500, Eric Sandeen wrote:
>> On 5/10/19 3:18 PM, Eric Sandeen wrote:
>>> There are a ton of "libxfs_" prefixed functions in libxfs/trans.c which
>>> are only called internally by code in libxfs/ - As I understand it,
>>> these should probably be just "xfs_" functions, and indeed many
>>> of them have counterparts in the kernel libxfs/ code.  This is one
>>> small step towards better sync-up of some of the misc libxfs/*
>>> transaction code with kernel code.
>>
>> I should have changed internal callers too, will resend after other
>> review.
> 
> I have to admit I never got this whole libxfs renaming.  Why can't
> we just use the xfs_* namespace for libxfs as well to start with?
> 

I'm struggling to understand it as well.  I have a 2nd patch to move
still more of the shared-ish xfs functions to strip off the "lib" part,
and for the rest I don't know - I'm trying to get to where I understand
the original intent of all this ...

Thanks,
-Eric
