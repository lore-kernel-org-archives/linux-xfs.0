Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48986 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933008AbeCFTen (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 14:34:43 -0500
Subject: Re: [PATCH 12/16] xfs_db: add a superblock info command
From: Eric Sandeen <sandeen@sandeen.net>
References: <151993157539.22223.6269629008244777191.stgit@magnolia>
 <151993165958.22223.10507415725288169958.stgit@magnolia>
 <20edb4dd-80c4-76e6-d63d-09c6553b5c29@sandeen.net>
Message-ID: <777384a3-90de-4715-21fc-a3f7b45387d8@sandeen.net>
Date: Tue, 6 Mar 2018 13:34:42 -0600
MIME-Version: 1.0
In-Reply-To: <20edb4dd-80c4-76e6-d63d-09c6553b5c29@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org



On 3/6/18 1:32 PM, Eric Sandeen wrote:
> On 3/1/18 1:14 PM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Add an 'info' command to pretty-print the superblock geometry.
> I'm on the fence about this; xfs_db generally just dumps representations
> of individual disk structures.  This seems like a bit of an expansion of
> its charter.  What is the use case for this?  Convince me that it's good
> to add this code?
> 
> Thanks,
> -Eric
> 

Sorry - of course later patches make xfs_info work offline, but still,
I'd like to see some rationale for why we need that capability.  I'm all
for the code reduction of the common printing routine but what's the big
picture rational for teaching all these other tools to print mkfs-like output?

Thanks,
-Eric
