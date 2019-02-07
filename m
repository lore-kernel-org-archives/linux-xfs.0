Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:39490 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbfBGNLH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Feb 2019 08:11:07 -0500
From: Nix <nix@esperi.org.uk>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at all?
References: <87h8dgefee.fsf@esperi.org.uk> <20190206234328.GH14116@dastard>
        <20190207002425.GX24140@tuebingen.mpg.de>
        <20190207022657.GI14116@dastard>
        <438851ef-ef77-b5f2-d46d-05762b6330b2@suse.de>
Date: Thu, 07 Feb 2019 13:10:52 +0000
In-Reply-To: <438851ef-ef77-b5f2-d46d-05762b6330b2@suse.de> (Coly Li's message
        of "Thu, 7 Feb 2019 10:38:58 +0800")
Message-ID: <875ztveobn.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Coly Li <colyli@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, Andre Noll <maan@tuebingen.mpg.de>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk

On 7 Feb 2019, Coly Li stated:
> On 2019/2/7 10:26 上午, Dave Chinner wrote:
>> So, yeah, that needs to be reverted if you want bcache to function
>> properly for metadata caching.
>
> Sure, I will fix this, once I make it clear to me.

I'll give it a test :)

The meaning of these flags was somewhat opaque to me, too (mostly due to
novelty: I've never really looked at anything in the block layer
before).

-- 
NULL && (void)
