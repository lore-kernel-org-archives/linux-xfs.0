Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35532 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfFQOy2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 10:54:28 -0400
Subject: Re: xfs_db sigsegv, xfs.org wiki and misc
References: <20190617140924.7db29e91@narya.grin.hu>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c5193452-a2a3-703b-764a-6993096f3a81@sandeen.net>
Date: Mon, 17 Jun 2019 09:54:26 -0500
MIME-Version: 1.0
In-Reply-To: <20190617140924.7db29e91@narya.grin.hu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: grin <lxfs@drop.grin.hu>, linux-xfs@vger.kernel.org

On 6/17/19 7:09 AM, grin wrote:
> Hello,
> 
> I haven't checked XFS project lately, and that's a decade or so, it
> means that when I have met a bug I went out and tried to see where and
> how to report. Just mentioning the following, since you may not be
> aware from the inside:
> 
> The xfs.org seems to be the "main" xfs website, search gives it first,
> and has a huge amount of informations. Problem is: most links point to
> nonexistant pages (SGI links hijacked by HP main page), including those
> mentioning documentation, development or suggest bug reporting. Only
> two valid pointers are the #xfs on FreeNode and this mailing list. Some
> mentioned https://xfs.wiki.kernel.org/ which is bacially impossible to 
> find unless looking for it specifically, and it doesn't contain much
> info anyway. So I can't see who to mention this to, maybe you know.

yes sadly no xfs devs own xfs.org

> Anyway. xfs_db SIGSEGV, v5.0, pretty reliably, on
>> inode <n>
>> type inode
>> print 
>  [...lots of output of the extents...]
>  crash
> 
> I am not sure how it's handled: whether it's a very low level utility
> and sigsegv is a way to show "you're doing something wrong", or rather
> it is a bug and shall be fixed. If you would kindly tell me whether
> I shall report it anywhere, send metadump, or anything, I would be much
> happier (to know at least).
> 
> (At least one external tool tries to use it and it's bitten by the
> crash.)

core + binary perhaps?  Or provide a gdb backtrace, or a metadump of the
filesystem?  If you want to provide a metadump I'd suggest contacting me
off list to do so.

Thanks,
-Eric

> Thanks,
> g
> 
