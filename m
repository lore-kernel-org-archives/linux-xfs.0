Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52036 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750761AbdHLJAx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 12 Aug 2017 05:00:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sat, 12 Aug 2017 11:00:51 +0200
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing and
 dirtying helpers
In-Reply-To: <20170811151805.22896-1-hch@lst.de>
References: <20170811151805.22896-1-hch@lst.de>
Message-ID: <f4d52f4d8b1cb6dfb91acaa8612d4bba@molgen.mpg.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, stockhausen@collogia.de, it+linux-nfs@molgen.mpg.de

Dear Christoph,


On 2017-08-11 17:18, Christoph Hellwig wrote:
> Fix the min_t calls in the zeroing and dirtying helpers to perform the
> comparisms on 64-bit types, which prevents them from incorrectly
> being truncated, and larger zeroing operations being stuck in a never
> ending loop.
> 
> Special thanks to Markus Stockhausen for spotting the bug.
> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>

Thank you very much for providing the fix that quickly.

Please don’t forget to tag it for the stable series (4.8+).

Cc: stable@vger.kernel.org


Kind regards,

Paul
