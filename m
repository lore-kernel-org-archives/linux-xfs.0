Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53436 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbeJZAX6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Oct 2018 20:23:58 -0400
Subject: Re: [PATCH v3 0/2] Try to squash metadump data leaks
References: <20181011194424.20306-1-stefanrin@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5209fec0-c7b3-ae1f-a909-23adfdee1072@sandeen.net>
Date: Thu, 25 Oct 2018 10:50:36 -0500
MIME-Version: 1.0
In-Reply-To: <20181011194424.20306-1-stefanrin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On 10/11/18 2:44 PM, Stefan Ring wrote:
> This is the same as v2, but with the correct e-mail address this time. Sorry!
> 
> Stefan Ring (2):
>   xfs_metadump: Extend zapping to multi fsb dir blocks
>   xfs_metadump: Zap more stale data
> 
>  db/metadump.c | 121 +++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 107 insertions(+), 14 deletions(-)

Still reading through the patches (this stuff makes my brain hurt)

but I think it'd be nice to structure this in a more incremental way, perhaps:

1) fix dir leaf block processing to handle LEAFN
2) add existing leaf block processing to multi-fsb dirs
3) add the dir2 free processing function, and add it to both single & multi-fsb dirs
4) add the process_btinode fixes
5) add the device inode processing

1,2,3 are dependent, 4 and 5 should be independent, they can each be
reviewed for their sole purpose.  One change, one patch.  :)

Thanks,
-Eric
