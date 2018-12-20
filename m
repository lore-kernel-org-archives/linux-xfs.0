Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f174.google.com ([209.85.160.174]:36417 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732431AbeLTQze (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 11:55:34 -0500
Received: by mail-qt1-f174.google.com with SMTP id t13so2562353qtn.3
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 08:55:33 -0800 (PST)
Received: from lud1.home ([189.115.213.104])
        by smtp.gmail.com with ESMTPSA id c17sm5490738qtb.14.2018.12.20.08.55.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Dec 2018 08:55:31 -0800 (PST)
Date: Thu, 20 Dec 2018 14:55:29 -0200
From: Luciano ES <lucmove@gmail.com>
Subject: Re: Same size drive has less usable space
Message-ID: <20181220145529.1292ec61@lud1.home>
In-Reply-To: <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
References: <20181220131305.2a84b717@lud1.home>
        <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Thu, 20 Dec 2018 10:10:42 -0600, Eric Sandeen wrote:

> Well, you have larger inodes on xxbkp for starters.

I can't make smaller inodes on this disk.

"specified blocksize 2048 is less than device physical sector size 4096
switching to logical sector size 512"

another attempt:

"specified blocksize 2048 is less than device physical sector size 4096
switching to logical sector size 512
Minimum inode size for CRCs is 512 bytes"

So yes, it's the CRC feature.


On Thu, 20 Dec 2018 10:10:42 -0600, Eric Sandeen wrote:

> # mkfs.xfs -m crc=0,finobt=1 -i sparse=0 -n ftype=0

Your command line doesn't work. It says:

finobt not supported without CRC support

I have confirmed that disabling CRC allows me to have smaller inodes, 
but I wish I could keep that feature. It sounds like something I want 
to have, to improve reliability.

Is there another way?


On Thu, 20 Dec 2018 08:26:41 -0800, Darrick J. Wong wrote:

> Why not xfs_copy?

Good question. But then the copy would not have CRC enabled either 
because the original doesn't. 

Looks like I an going to have to commit to having CRC always on 
from now on. And I am going to lose about 7GB of space for that.

Is it worth it?


-- 
Luciano ES
>>
