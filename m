Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59104 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbeJGEZi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Oct 2018 00:25:38 -0400
Subject: Re: Which fragmentation factor is allowable for xfs (not impact on
 performance)?
References: <CABXGCsOxH-gfLL4Mo+RxNk4OoWgAdJzW2Sv2w2He7VkgKxqUug@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57e256e5-bcf7-c6ce-601a-64263606d707@sandeen.net>
Date: Sat, 6 Oct 2018 16:20:48 -0500
MIME-Version: 1.0
In-Reply-To: <CABXGCsOxH-gfLL4Mo+RxNk4OoWgAdJzW2Sv2w2He7VkgKxqUug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-xfs@vger.kernel.org

On 10/6/18 12:34 PM, Mikhail Gavrilov wrote:
> Which fragmentation factor is allowable for xfs (not impact on performance)?
> 
> # xfs_db -c frag -r /dev/sda
> actual 4908781, ideal 2801391, fragmentation factor 42.93%

Ignore the fragmentation factor, because:

> Note, this number is largely meaningless.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

> Files on this filesystem average 1.75 extents per file
The majority of your files have only 1 extent.

> # mount | grep sda
> /dev/sda on /home type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
> 
> # df -h | grep sda
> /dev/sda         11T  5.3T  5.7T  49% /home
> 
> I think it too much for partition which are half free.

Why do you think that?

> It would also be interesting to see the fragmentation in the context
> of files, but I have not found anywhere how to look at it.

xfs_bmap will show you extent layout for individual files.

-Eric
