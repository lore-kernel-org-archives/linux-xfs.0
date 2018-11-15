Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34708 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbeKPIcd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 03:32:33 -0500
Subject: Re: file write that exceeds thin device capacity
References: <18125274-1c2e-6171-a597-4e2ffb165162@redhat.com>
 <20181113221004.GT19305@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3759a449-5bc8-5fa8-1a6e-1ecf714c847d@sandeen.net>
Date: Thu, 15 Nov 2018 16:22:51 -0600
MIME-Version: 1.0
In-Reply-To: <20181113221004.GT19305@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Todd Gill <tgill@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 11/13/18 4:10 PM, Dave Chinner wrote:
> On Tue, Nov 13, 2018 at 02:57:18PM -0500, Todd Gill wrote:
>> Hi,
>>
>> This script creates a 1 TB thin device (device mapper)  backed by 1 GB
>> of physical space.  The script then writes more than 1 GB via
>> $BLOCK_SIZE files to XFS.  I'm testing to see if recovery can be
>> automated.
>>
>> https://paste.fedoraproject.org/paste/ropelNyOQWCjk3hfK0jltA
>>
>> When the $BLOCK_SIZE passed to dd is 4k - dd gets an error on the file
>> write that exceeds the physical capacity that backs the thin device.
>> XFS doesn't indicate any problems.

> user data write error.

To put a finer point on this, because it's a user data write error, it
is up to userspace to cope, and xfs isn't going to indicate that it has an
internal error (as it would for metadata writes).

i.e. dd should have seen an error bubbled up, and you
would then know to retry, error handle, take evasive action, etc as you
see fit.

-Eric
