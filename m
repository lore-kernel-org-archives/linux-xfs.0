Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46112 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751430AbdJ0Q1I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 12:27:08 -0400
Subject: Re: [PATCH 06/10] xfs_repair: fix cowextsize field checking and
 repairing
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <150905613147.28563.3642613984403228295.stgit@magnolia>
 <b57f41c8-ce22-043a-ba04-b1692530a4de@sandeen.net>
 <20171027161739.GI5483@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eb3a9811-eff5-10b2-07ed-3a2725debc04@sandeen.net>
Date: Fri, 27 Oct 2017 11:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <20171027161739.GI5483@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 10/27/17 11:17 AM, Darrick J. Wong wrote:
> On Thu, Oct 26, 2017 at 09:06:10PM -0500, Eric Sandeen wrote:
>> On 10/26/17 5:15 PM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>
>>> Make sure that we never leave the filesystem with a zero cowextsize hint
>>> while the cowextsize inode flag is set.
>>>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Ok.  Is there anything that catches cowextsize set on di_version < 3?
> 
> No, because the inode core structure isn't large enough to have
> cowextsize if version < 3.

Oh right - no di_flags2 to hold the XFS_DIFLAG2_COWEXTSIZE flag, and
no di_cowextsize to hold a value.  Derp, sorry for the noise.

-Eric
