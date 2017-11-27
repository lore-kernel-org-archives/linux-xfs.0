Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50734 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdK0UQs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 15:16:48 -0500
Subject: Re: [PATCH for 4.15] libxfs: fix dev_t handling in inode forks
From: Eric Sandeen <sandeen@sandeen.net>
References: <20171116011505.GH5119@magnolia>
 <20171117165706.GB17447@infradead.org>
 <91f84193-e3c8-c4f7-ca93-5caea3a7bb03@sandeen.net>
Message-ID: <4be5c1a1-d274-11b8-935b-ddf23d5b5e64@sandeen.net>
Date: Mon, 27 Nov 2017 14:16:47 -0600
MIME-Version: 1.0
In-Reply-To: <91f84193-e3c8-c4f7-ca93-5caea3a7bb03@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>



On 11/27/17 1:26 PM, Eric Sandeen wrote:
> On 11/17/17 10:57 AM, Christoph Hellwig wrote:
>> Hmm.
>>
>> I guess we should just clean up the calling conventions, and keep
>> the conversion helpers in xfs_linux.h so that xfsprogs can turn them
>> into noops.
>>
>> Something like the untested patch for the kernel space, xfsprogs would
>> then just stub out the two inlines to return the passed in value.
>>
>> ---
>> From e0ed26ab66774c1611e71a3c290efbe4e21d483c Mon Sep 17 00:00:00 2001
>> From: Christoph Hellwig <hch@lst.de>
>> Date: Fri, 17 Nov 2017 17:55:48 +0100
>> Subject: xfs: abstract out dev_t conversions
>>
>> And move them to xfs_linux.h so that xfsprogs can stub them out more
>> easily.
> 
> Ok I'm a little confused by this, actually (sorry for the late reply).
> 
> I added an i_rdev to the "vfs inode" in xfsprogs... but if that's
> really supposed to be a "linux inode" then we probably want to keep
> the conversions to/from linux dev_t format when it's stored there,
> even if it's never actually used as such.
> 
> So I'm not sure no-ops are the right answer.  That'd work, but it
> seems odd to carry around the xfs device format in the "linux" inode
> even in xfsprogs, from a "least surprise" POV.
> 
> So moving these to the header file is (was) fine, but I'll probably
> keep the translation in xfsprogs.
> 
> Unless I'm missing something ...

Maybe what I'm missing is that it's stupid to carry all those conversions
around if they're not needed.   ;)  

I'll stuff the xfs format device number into the "linux" i_rdev, with a comment
stating that it's so.

-Eric
