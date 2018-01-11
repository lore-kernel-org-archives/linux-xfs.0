Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36186 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753715AbeAKXmb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:42:31 -0500
Subject: Re: [PATCH 8/8] libxfs: Catch non-empty zones on destroy
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-9-git-send-email-sandeen@sandeen.net>
 <20180111202918.GI5602@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <504f8f43-b368-3f14-0fc8-34315f83b2dd@sandeen.net>
Date: Thu, 11 Jan 2018 17:42:30 -0600
MIME-Version: 1.0
In-Reply-To: <20180111202918.GI5602@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 1/11/18 2:29 PM, Darrick J. Wong wrote:
>> +kmem_zone_t		*xfs_inode_zone;
>>  extern kmem_zone_t	*xfs_ili_zone;
>> -extern kmem_zone_t	*xfs_inode_zone;
> /me wonders what's going on here?  Alphabetizing, I guess...
> 
> <shrug> meh, whatever :)

it's moving the definition of the inode zone variable into this
file which is directly related, rather than randomly plopped in init.c
and referring to it here with extern.

As for placement, I put the actual definition above an extern
reference to something else somewhere else, seemed to make sense
to "rank" them like that.

As for splitting the patch up, *shrug* ok.  Without
the libxfs_destroy() code none of this ever runs, but sure,
I can build it up then enable it separately.

-Eric
