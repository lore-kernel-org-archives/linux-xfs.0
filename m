Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43994 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbdEIV0j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 17:26:39 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] xfs: remove XFS_HSIZE
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20170509211857.GA2295@lst.de>
Date: Tue, 9 May 2017 16:26:37 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <7482DC25-4BF8-419C-82C6-3E91B11FDB57@sandeen.net>
References: <20170509090018.30094-1-hch@lst.de> <ba048d82-a8b9-863f-121e-a1319fdef0f3@sandeen.net> <20170509211857.GA2295@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



> On May 9, 2017, at 4:18 PM, Christoph Hellwig <hch@lst.de> wrote:
> 
> On Tue, May 09, 2017 at 10:40:31AM -0500, Eric Sandeen wrote:
>>> -
>>> -        hsize = XFS_HSIZE(handle);
>>> +        hsize = sizeof(xfs_handle_t);
>> 
>> at this point, no need to have the hsize assignment in if { } as well as else { }, right?
>> 
> 
> In the other branch hsize is smaller, it only covers the fsid.

Ugh I misread, sorry.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> 

