Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.hosts.co.uk ([85.233.160.19]:28238 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbeLNInc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 03:43:32 -0500
Subject: Re: XFS and RAID10 with o2 layout
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
 <20181213220533.GH6311@dastard>
 <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
From: Wols Lists <antlists@youngman.org.uk>
Message-ID: <5C13694A.8070303@youngman.org.uk>
Date: Fri, 14 Dec 2018 08:26:50 +0000
MIME-Version: 1.0
In-Reply-To: <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sinisa <sinisa@4net.rs>, linux-raid@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

On 14/12/18 07:03, Sinisa wrote:
>> And another MD flush thread waiting on a MD sync barrier.
>>
>> Basically, this looks and smells like a MD sync barrier race
>> condition, not an XFs problem.
>>
>> Cheers,
>>
>> Dave.
> 
> But why don't we see the same issue with other filesystems?

Possibly because, iirc, xfs is aware of the underlying raid?

I don't know, but I seem to remember that from earlier discussions about
"xfs over mdraid".

Cheers,
Wol
