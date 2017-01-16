Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36090 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdAPABh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 Jan 2017 19:01:37 -0500
Received: by mail-pf0-f172.google.com with SMTP id 189so48548136pfu.3
        for <linux-xfs@vger.kernel.org>; Sun, 15 Jan 2017 16:01:36 -0800 (PST)
Message-ID: <1484524890.27533.16.camel@dubeyko.com>
Subject: Re: [LSF/MM TOPIC] online filesystem repair
From: Viacheslav Dubeyko <slava@dubeyko.com>
Date: Sun, 15 Jan 2017 16:01:30 -0800
In-Reply-To: <20170114075452.GJ14033@birch.djwong.org>
References: <20170114075452.GJ14033@birch.djwong.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Vyacheslav.Dubeyko@wdc.com

On Fri, 2017-01-13 at 23:54 -0800, Darrick J. Wong wrote:
> Hi,
> 
> I've been working on implementing online metadata scrubbing and
> repair
> in XFS.  Most of the code is self contained inside XFS, but there's a
> small amount of interaction with the VFS freezer code that has to
> happen
> in order to shut down the filesystem to rebuild the extent backref
> records.  It might be interesting to discuss the (fairly slight)
> requirements upon the VFS to support repairs, and/or have a BoF to
> discuss how to build an online checker if any of the other
> filesystems
> are interested in this.
> 

How do you imagine a generic way to support repairs for different file
systems? From one point of view, to have generic way of the online file
system repairing could be the really great subsystem. But, from another
point of view, every file system has own architecture, own set of
metadata and own way to do fsck check/recovering. As far as I can
judge, there are significant amount of research efforts in this
direction (Recon [1], [2], for example). But we still haven't any real
general online file system repair subsystem in the Linux kernel. Do you
have some new insight? What's difference of your vision? If we have
online file system repair subsystem then how file system driver will
need to interact with the goal to make internal repairing?

Thanks,
Vyacheslav Dubeyko.

[1] http://www.eecg.toronto.edu/~ashvin/publications/recon-fs-consistency-runtime.pdf
[2] https://www.researchgate.net/publication/269300836_Managing_the_file_system_from_the_kernel

