Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42758 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753878AbdGLQxD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 12:53:03 -0400
Subject: Re: xfstests failures with current kernel/xfsprogs/xfstests
References: <20170712114433.GA2231@infradead.org>
 <20170712162954.GA4220@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dba1ac97-e3b9-bddd-61e5-78f164d3dc50@sandeen.net>
Date: Wed, 12 Jul 2017 11:53:02 -0500
MIME-Version: 1.0
In-Reply-To: <20170712162954.GA4220@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 07/12/2017 11:29 AM, Darrick J. Wong wrote:
>> generic/417 seems to fail to recover things on a r/o to r/w mount.
>>
>> I thoght Eric had a fix for this, but it seems like it didn't get merge.
> He did, but Dave wanted to know more about the side effects of recovering
> unlinked inodes on the rootfs during the ro->rw mount and the thread died
> after that.
> 

Because I really don't know how to answer that.  I didn't see a way to
address the vague concerns.  I tried to find a way to make a test which
does this, but wasn't able to come up with any way to produce the old/lost
orphans on a kernel with the fix.

-Eric
