Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45426 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbeLRSUg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Dec 2018 13:20:36 -0500
Subject: Re: [PATCH 1/3] iomap: use SECTOR_SIZE instead of 512 in iomap_page
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-2-git-send-email-sandeen@sandeen.net>
 <20181215105155.GD1575@lst.de>
 <37aec6a5-d846-eca1-1708-bf80ea63c463@sandeen.net>
 <20181218180617.GB15138@lst.de> <20181218181920.GA27208@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <cc261321-9c01-c066-60d2-a6fe8ff54af6@sandeen.net>
Date: Tue, 18 Dec 2018 12:20:33 -0600
MIME-Version: 1.0
In-Reply-To: <20181218181920.GA27208@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org



On 12/18/18 12:19 PM, Darrick J. Wong wrote:
> On Tue, Dec 18, 2018 at 07:06:17PM +0100, Christoph Hellwig wrote:
>> On Mon, Dec 17, 2018 at 05:45:10PM -0600, Eric Sandeen wrote:
>>> Then we should hard code "512" in iomap_page_create I guess.  Just need
>>> consistency.
>>
>> Fine with me.
> 
> Please don't just hardcode 512 here.  AFAICT the usage in iomap.c seems
> to be "minimum expected fs block size" so that the iop's uptodate bitmap
> is sized to handle the worst case blocks-per-page.
> 
> Can we please have a "#define IOMAP_MIN_FS_BLOCKSIZE SECTOR_SIZE" to
> capture the intent behind the 512?  Or, if you don't want to require all
> includers of iomap.h to also have to include blkdev.h, define it to 512
> and have a BUILD_BUG_ON somewhere so that we don't leave a subtle bug if
> we ever change SECTOR_SIZE?

Right, seems like something needs to tie this into the rest of reality
and not just blaze past it if we somehow ever encounter a block size
< 512.

-Eric
