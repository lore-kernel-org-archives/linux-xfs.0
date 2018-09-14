Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54840 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbeINTI0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:08:26 -0400
Subject: Re: [PATCH] xfs: re-enable FIBMAP on reflink; disable for swap
References: <bf6e7f18-25fa-2b41-9532-78bffe33a241@sandeen.net>
 <20180914134607.GA6334@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <abb81c65-4ec8-87a3-0362-1812bca43d09@sandeen.net>
Date: Fri, 14 Sep 2018 08:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <20180914134607.GA6334@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs <linux-xfs@vger.kernel.org>



On 9/14/18 8:46 AM, Christoph Hellwig wrote:
> On Wed, Sep 12, 2018 at 08:55:35PM -0500, Eric Sandeen wrote:
>> The commit:
>>
>>  db1327b1 xfs: report shared extent mappings to userspace correctly
>>
>> disabled FIBMAP on reflinked files, with this very clear rationale
>> regarding swapfiles:
>>
>> "Have xfs_vm_bmap return zero for reflinked files because the
>> bmap-based swap code requires static block mappings, which is
>> incompatible with copy on write."
>>
>> However, this broke the FIBMAP interface for existing userspace
>> apps, including bootloaders.
> 
> It didn't break any interface because the reflink flag has been
> experimental and a mkfs-time opt in.
> 
> So NAK for this patch.

That's a really weak argument, but I guess it shouldn't be surprising
because this whole episode has been a string of weak arguments.
