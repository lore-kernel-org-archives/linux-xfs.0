Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47352 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbeJHXBL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Oct 2018 19:01:11 -0400
Subject: Re: [PATCH 14/15] xfsprogs: eliminate shadow variables
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
 <1538712196-13625-15-git-send-email-sandeen@sandeen.net>
 <20181006101655.GN28114@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9a7008ef-7500-f041-5c4d-4b316059ea4f@sandeen.net>
Date: Mon, 8 Oct 2018 10:48:48 -0500
MIME-Version: 1.0
In-Reply-To: <20181006101655.GN28114@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 10/6/18 5:16 AM, Christoph Hellwig wrote:
> On Thu, Oct 04, 2018 at 11:03:15PM -0500, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> None of these seem activel harmful, but to avoid confusion, remove all
>> shadow variables by just renaming them in their local scope.
>>
>> Fixes sparse warnings about this.
> 
> I'd feel much more comforable reviewing this with one patch per
> function that explains why the transformation is safe, especially
> as the patch itself contradicts the explanation above - some variables
> are removed instead of renamed for example.
> 

Well, existing variables are used in their place, i.e. another existing
loop counter "i" is re-used instead of one which shadows a global variable
("x").

But ok, I can split it up more.
