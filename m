Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53322 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbeLTRcf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 12:32:35 -0500
Subject: Re: Same size drive has less usable space
References: <20181220131305.2a84b717@lud1.home>
 <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
 <20181220145529.1292ec61@lud1.home>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <710b005e-0738-b793-3014-2234fcee84ad@sandeen.net>
Date: Thu, 20 Dec 2018 11:32:33 -0600
MIME-Version: 1.0
In-Reply-To: <20181220145529.1292ec61@lud1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>, linux-xfs@vger.kernel.org

On 12/20/18 10:55 AM, Luciano ES wrote:
> On Thu, 20 Dec 2018 10:10:42 -0600, Eric Sandeen wrote:
> 
>> Well, you have larger inodes on xxbkp for starters.
> 
> I can't make smaller inodes on this disk.
> 
> "specified blocksize 2048 is less than device physical sector size 4096
> switching to logical sector size 512"

1) that's a warning not an error
2) that's blocksize not inode size

but ok, I missed that you had 2k blocks on your backup disk.... I don't
really know what you're trying to do here, TBH.

> another attempt:
> 
> "specified blocksize 2048 is less than device physical sector size 4096
> switching to logical sector size 512
> Minimum inode size for CRCs is 512 bytes"

So, I don't think you turned off crcs here.

> So yes, it's the CRC feature.

So turn it off.

> 
> On Thu, 20 Dec 2018 10:10:42 -0600, Eric Sandeen wrote:
> 
>> # mkfs.xfs -m crc=0,finobt=1 -i sparse=0 -n ftype=0
> 
> Your command line doesn't work. It says:
> 
> finobt not supported without CRC support

yeah I fat-fingered that, make it finobt=0 of course.

> I have confirmed that disabling CRC allows me to have smaller inodes, 
> but I wish I could keep that feature. It sounds like something I want 
> to have, to improve reliability.
> 
> Is there another way?

You're over-constraining yourself here; crcs require larger inodes which
requires more space, by definition.  Sorry, but you can't get something
for nothing.

If you are trying to consume identical space you're going to need to use
an identical format.

-Eric
