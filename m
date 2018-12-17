Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39178 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbeLQXpL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Dec 2018 18:45:11 -0500
Subject: Re: [PATCH 1/3] iomap: use SECTOR_SIZE instead of 512 in iomap_page
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-2-git-send-email-sandeen@sandeen.net>
 <20181215105155.GD1575@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <37aec6a5-d846-eca1-1708-bf80ea63c463@sandeen.net>
Date: Mon, 17 Dec 2018 17:45:10 -0600
MIME-Version: 1.0
In-Reply-To: <20181215105155.GD1575@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org



On 12/15/18 4:51 AM, Christoph Hellwig wrote:
> On Thu, Dec 13, 2018 at 04:25:27PM -0600, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> because iomap_page_create initializes the uptodate bitmap using the macro,
>> not the open-coded value.
> 
> I find the use of SECTOR_SIZE rather confusing, especially as often
> the sector size might actually be something else.  It also forces
> us to pull in another huge header file.

Then we should hard code "512" in iomap_page_create I guess.  Just need
consistency.

-Eric
