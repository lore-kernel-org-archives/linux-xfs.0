Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34282 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934957AbcKJQzU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Nov 2016 11:55:20 -0500
Subject: Re: sb_agblocks
References: <44d2cb2765781d64e9549b371a2f9686.squirrel@mail2.postbox.xyz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bbd0f6bd-2d69-29ab-4205-19e3202c8444@sandeen.net>
Date: Thu, 10 Nov 2016 10:55:19 -0600
MIME-Version: 1.0
In-Reply-To: <44d2cb2765781d64e9549b371a2f9686.squirrel@mail2.postbox.xyz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris <chris2014@postbox.xyz>, linux-xfs@vger.kernel.org

On 11/10/16 8:15 AM, Chris wrote:
> All,
> 
> howto display size and number of Allocation Groups? I think 1 varialbe is
> sb_agblocks.

(whoops, reply-all this time)

xfs_info /path/to/mount/point will tell you, if it's mounted.

Otherwise xfs_db -c "sb 0" -c "p blocksize" -c "p agblocks" -c "p agcount" /dev/whatever

will give you block size, blocks per AG, and number of AGs.

-Eric

> - Chris
