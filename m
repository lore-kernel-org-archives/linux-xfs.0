Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965614AbeE2TKL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 15:10:11 -0400
Subject: Re: [PATCH 0/7] xfsprogs-4.17: last of the fixes
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9b740760-3890-057a-5650-f8a4b5c468dc@sandeen.net>
Date: Tue, 29 May 2018 14:10:09 -0500
MIME-Version: 1.0
In-Reply-To: <152728629694.22515.17699396814561914788.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 5/25/18 5:11 PM, Darrick J. Wong wrote:
> Hi all,

Thanks, I will pull these all in today.

And thank for the reviews, that helps.

Alison, can you be sure to add a "-" in your "Reviewed-by:" tags
in the future, please?

Thanks,
-Eric
  
> The first patch fixes a Coverity bug that was introduced in the latest
> push of for-next.
> 
> Then there are three patches to fix some deficiencies I found when I
> tried to use xfsbuflock.py to diagnose deadlocks in generic/388.  The
> script didn't know that buffers are created locked, it didn't tell you
> the line number of when a buffer got locked, and it got a little
> confused about trylock.  So fix all three of those.
> 
> The fourth patch fixes another bashism in fsck.xfs.
> 
> The fifth patch removes crc32 support (not crc32c support) which is not
> used anywhere in xfs.  This reduces text segment size by 8K in all
> programs.
> 
> --D
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
