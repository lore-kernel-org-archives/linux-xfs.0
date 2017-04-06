Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:52758 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751673AbdDFRu7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 13:50:59 -0400
Date: Thu, 6 Apr 2017 10:50:57 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Metadata corruption detected at xfs_inode_buf_verify
In-Reply-To: <20170406080802.3g6ilun5k2fmxf2t@eorzea.usersys.redhat.com>
Message-ID: <alpine.DEB.2.21.1.1704061033110.1086@trent.utfs.org>
References: <alpine.DEB.2.21.1.1704051729340.1086@trent.utfs.org> <20170406080802.3g6ilun5k2fmxf2t@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, 6 Apr 2017, Carlos Maiolino wrote:
> > I have a raspberrypi and try to use that as a small file server. After
> > trying to delete a ~1TB direcory, it locked up and was then power cycled. 
> > Now I cannot mount the XFS partition any more:
> > 
> 
> Rpi will usually power cycle when it overheat, and possibly when an NMI is

Sorry, I should have been more clear: the Rpi locked up during "rm"[0] and 
then I power-cycled the box. And then I noticed the xfs trouble.

> Removing 1TB directory, doesn't say much, you can have a 1TB file, which will be
> quite fast to delete, or you can have 1million 1MiB files, which will require
> extra processing (and maybe your Rpi couldn't handle that?)

It was a 1 TB directory with lots of small and semi-large files, and yes, 
that may have been too much for this Rpi. I spoke to Eric Sandeen on IRC 
and he suspected the same.

> See xfs_repair -L option.

Yes, that's what I did in the end :-\ After the fsck was finished, the 1 
TB directory was still there (the "rm" managed to remove ~300 GB or so) 
and I removed the rest on a larger machine, so it's all good for now.

Thanks for replying,
Christian.

[0] http://nerdbynature.de/bits/4.11.0-rc5/xfs/kern_log.txt

-- 
BOFH excuse #152:

My pony-tail hit the on/off switch on the power strip.
