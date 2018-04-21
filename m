Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41572 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750767AbeDUEeK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Apr 2018 00:34:10 -0400
Subject: Re: question about mkfs.xfs
References: <5ADAAE79.5020803@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b663f0ab-ab78-961f-7e24-a9794eb07d98@sandeen.net>
Date: Fri, 20 Apr 2018 23:34:08 -0500
MIME-Version: 1.0
In-Reply-To: <5ADAAE79.5020803@cn.fujitsu.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiao Yang <yangx.jy@cn.fujitsu.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 4/20/18 10:22 PM, Xiao Yang wrote:
> Hi Eric£¬
> 
> Before commit 16adcb8 in xfsprogs-dev, only "sunit=0,swidth=0" is vaild
> and will convert
> into the default stripe config as expected.

It behaved the same as the default, because it looked the same as
"not set" to all the conditionals in mkfs.

> After this commit, both
> "sunit=0,swidth=0"
> and "sunit=0,swidth=64" will be forced to convert into the default
> stripe config.

0,0 should be allowed, to force mkfs to ignore any stripe geometry
reported by the device.

> If either of sunit and swidth is not 0, should we do a forced conversion?
> I am not sure if we should reject the combination(e.g. sunit=0,swidth=64).

I am not sure what you mean by "forced conversion" - can you give specific
examples?

However, a stripe unit of 0 with a non-zero stripe width should probably
also be rejected, because it has no meaning.  I think it was rejected
before, and my commit accidentally allowed it again.

It probably needs another test added back in, to check for "both options
were specified, but (only) one was zero."

Thanks,
-Eric

> 
> Thanks,
> Xiao Yang
