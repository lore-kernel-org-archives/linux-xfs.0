Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:53347 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727763AbfFYKMS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:12:18 -0400
Subject: Re: [PATCH 2/2] xfs: implement cgroup aware writeback
References: <20190624134315.21307-1-hch@lst.de>
 <20190624134315.21307-3-hch@lst.de> <20190624162215.GS5387@magnolia>
 <20190625100057.GD1462@lst.de>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <044a8a27-ad1c-73ff-5a29-189f0b38c3d9@profihost.ag>
Date: Tue, 25 Jun 2019 12:06:52 +0200
MIME-Version: 1.0
In-Reply-To: <20190625100057.GD1462@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Am 25.06.19 um 12:00 schrieb Christoph Hellwig:
> On Mon, Jun 24, 2019 at 09:22:15AM -0700, Darrick J. Wong wrote:
>> On Mon, Jun 24, 2019 at 03:43:15PM +0200, Christoph Hellwig wrote:
>>> Link every newly allocated writeback bio to cgroup pointed to by the
>>> writeback control structure, and charge every byte written back to it.
>>>
>>> Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
>>
>> Was this tested by running shared/011?  Or did it involve other checks?
> 
> I verified it with shared/011 and local frobbing.  Stefan can chime
> in on what testing he did.

I ran some real life Tests:

1.) using Dovecot for IMAP and limit Disk I/O

2.) Using dd without oflag=direct in systemd slices.

3.) Limit apache slice with various PHP applications in it.

Greets,
Stefan
