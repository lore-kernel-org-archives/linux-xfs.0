Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49116 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbeK2Llz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Nov 2018 06:41:55 -0500
Subject: Re: [PATCH 4/6] xfs_scrub: handle totally empty inode chunks
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181073901.3727.3960278646297663354.stgit@magnolia>
 <8de9dcd7-4bcd-2f4b-0043-835611317bed@sandeen.net>
 <20181129003508.GJ8125@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2ab342dd-f654-390a-5c36-8eda3d310834@sandeen.net>
Date: Wed, 28 Nov 2018 18:38:26 -0600
MIME-Version: 1.0
In-Reply-To: <20181129003508.GJ8125@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 11/28/18 6:35 PM, Darrick J. Wong wrote:
> On Wed, Nov 28, 2018 at 06:16:37PM -0600, Eric Sandeen wrote:
>> On 11/9/18 6:45 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> We try to load a single inobt record with each FSINUMBERS call.  If the
>>> chunk is totally empty (which can happen when there are more than one
>>> inobt record per block) we should skip to the next INUMBERS call since
>>> there are no inodes to bulkstat.
>>
>> It's not clear to me if this is a bugfix or an optimization, but meh,
>> seems like the right thing to do :)
> 
> It's a bug fix for 64k-block filesystems, which can have multiple empty
> inobt records that map to a single 64k block; if we try to BULKSTAT an
> empty inobt group then we get zero inodes and scrub erroneously says the
> fs is broken when in reality it's just stupid.

Ok thanks, didn't dig into whether it did needless no-op calls, or something
worse.

-eric
