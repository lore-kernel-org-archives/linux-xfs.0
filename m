Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48178 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751735AbeEDUyo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 16:54:44 -0400
Subject: Re: [PATCH 03/11] xfs_repair: validate some of the log space
 information
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401961080.13319.3976228325503296406.stgit@magnolia>
 <aad78f86-a7a2-ade3-812b-fe78c921d15d@sandeen.net>
 <20180504202539.GM26569@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <49e48aee-bbb8-988c-aac7-583a0c6c0402@sandeen.net>
Date: Fri, 4 May 2018 15:54:42 -0500
MIME-Version: 1.0
In-Reply-To: <20180504202539.GM26569@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On 5/4/18 3:25 PM, Darrick J. Wong wrote:
> On Fri, May 04, 2018 at 02:29:55PM -0500, Eric Sandeen wrote:
>> On 4/17/18 9:46 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Validate the log space information in a similar manner to the kernel so
>>> that repair will stumble over (and fix) broken log info that prevents
>>> mounting.  Fixes logsunit fuzz-and-fix failures in xfs/350.

...

>> Hm, this could use a comment about why these things only matter on v5 supers.
> 
> /*
>  * We only do this validation on v5 filesystems because the kernel
>  * didn't reject too-small logs in the past.
>  */
> 
> ?


"... doesn't reject malformed logs on older revision filesystems"

also, it'll probably happen anyway, but the new check-stuff function should
probably be called on its own and not tacked on via || to the inode checks.

-Eric
