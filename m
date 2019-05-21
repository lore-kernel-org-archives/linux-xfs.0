Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43846 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfEUTUw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:20:52 -0400
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
 <20190521170103.GD5141@magnolia>
 <c281d3c3-5385-90a3-125a-8a620944c971@sandeen.net>
 <20190521191946.GA5657@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d3a556b7-95ad-9fc9-1867-cd71d43f00e8@sandeen.net>
Date: Tue, 21 May 2019 14:20:51 -0500
MIME-Version: 1.0
In-Reply-To: <20190521191946.GA5657@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org



On 5/21/19 2:19 PM, Christoph Hellwig wrote:
> On Tue, May 21, 2019 at 01:59:58PM -0500, Eric Sandeen wrote:
>> So yeah I'm of the opinion that unless it's kernel(-ish?) code it should be
>> positive, and I can send a patch to clean up stuff that's not.
>>
>> I can be swayed by counterarguments if you have them.  :)
> 
> What speaks against everything is negative?  It isn't like returning
> positive errors really is a traditional userspace convention, as that
> is return -1 (negative!) and look at errno..

Sorry, I wasn't clear - I meant returning negative errnos.  That's
the part that's not consistent.

-Eric
