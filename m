Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:44545 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdJLBDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:03:35 -0400
Received: by mail-qt0-f193.google.com with SMTP id 8so10702677qtv.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 18:03:35 -0700 (PDT)
Received: from lubh.lubhome ([179.34.192.80])
        by smtp.gmail.com with ESMTPSA id 36sm8986227qtr.42.2017.10.11.18.03.33
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Oct 2017 18:03:34 -0700 (PDT)
Date: Wed, 11 Oct 2017 22:03:31 -0300
From: Luciano ES <lucmove@gmail.com>
Subject: Re: Questions about backups with XFS
Message-ID: <20171011220331.4af6308c@lubh.lubhome>
In-Reply-To: <20171009105701.GL3666@dastard>
References: <20171007114343.3bd42f98@lubh.lubhome>
        <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
        <20171009105701.GL3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, 9 Oct 2017 21:57:01 +1100, Dave Chinner wrote:

> On Mon, Oct 09, 2017 at 10:44:51AM +0200, Carlos Maiolino wrote:
> > Hi.
> > 
> > 
> > On Sat, Oct 07, 2017 at 02:43:43PM +0000, Luciano ES wrote:
> > > I have a few questions and I was torn between asking them
> > > separately and putting them all in one message. I decided for the
> > > latter and I hope this is not a problem.
> > > 
> > > Once upon a time, many many years ago, I used to make backup
> > > copies of my file systems with the 'cp -aux' command, including
> > > my live root file system. Luckily, I never had to restore any
> > > live root file system from those backups. They probably would
> > > never have worked.
> > > 
> > > Later on, someone taught me to do it like this:
> > > 
> > > find /source -xdev -print0 | cpio -pa0V /target
> > > 
> > > That command is supposed to copy everything, including special
> > > files (not really sure which) that mere cp or even rsync would
> > > not copy. I actually used that approach several times, including
> > > restoration, and it always worked.
> > > 
> > > For some reason, I stopped making backups of my live root file 
> > > system, but I still backup other partitions with rsync, always
> > > with the --delete-before parameter, so the target is always an
> > > exact copy of the source.
> > > 
> > > I have been using XFS for a few years and thought that maybe it's 
> > > time I enjoyed all the benefits of the XFS management tools.
> > > However, I am uncertain about things I haven't been able to find
> > > in the documentation or even on the Web:
> > > 
> > > Question #1:
> > > Does xfsdump really copy EVERYTHING? Can I backup a full live
> > > root file system with it and expect a restored copy to boot and
> > > run uneventfully? Or should I rather do a 'hard' image with
> > > xfs_copy? 
> > 
> > xfs_copy must only be used an unmounted filesystem (or read-only,
> > frozen, etc), so, unless you want to freeze/unmount your FS
> > everytime you do a xfs_copy, then xfs_copy is not what you are
> > looking for
> 
> I'll just say this: xfs_copy is not a backup tool. It's a filesystem
> image replication tool designed for fast, efficient 1-to-many
> duplication of a golden filesystem image to multiple drives, such as
> is done in manufacturing lines....


So xfs_copy is not a backup tool, and what does that mean in the 
context of my backup plan? Why can't I or should I not use it as a 
backup tool? If it is a replication tool, well, it replicates, it 
creates a copy that can be used to recreate a file system in a very 
specific state. Is there any technical impediment to the use I plan 
to make of it?


-- 
Luciano ES
>>
