Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751546AbdEEMZv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 08:25:51 -0400
Date: Fri, 5 May 2017 14:25:47 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
Message-ID: <20170505122547.6gvqmdoxfaqxh3mi@eorzea.usersys.redhat.com>
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
 <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Fri, May 05, 2017 at 01:52:53PM +0200, Gionatan Danti wrote:
> 
> 
> On 05/05/2017 13:32, Carlos Maiolino wrote:
> > 
> > This is not true, XFS can't identify mounts on different systems. It is not a
> > shared or clustered filesystem.
> > 
> 
> Ok, this confirm my finding.
> 
> To reiterate: there is *no* method to prevent multiple mounts in XFS, right?

As far as I know, don't, I can always be wrong, but, I re-checked xfs
superblock, and could not find anything that actually protects it.

> 
> > At the worst case, it would need to store something to disk saying the
> > filesystem is already mounted, and the mount process would need to read it
> > before actually mounting the filesystem. Nothing though would prevent a race
> > between two systems, or even make the filesystem unmountable after a crash,
> > needing something like xfs_repair to clean some "is_mounted" flag, which would
> > trash one of the reasons why we have a journal (fast recovery without needing an
> > fsck before mounting).
> > 
> 
> EXT4 uses a "keepalive" approach: enabling the "mmp" feature (which require
> kernel 3.10+), a specific on-disk structure is continuously (each 5 seconds,
> by default) updated with a timestamp by the mounting machine. If another
> machine tries to mount the filesystem, it sees the mmp structure changing
> and it refuse to mount.
> 

> It's not perfect, but better than nothing ;)

Eh, I really don't know much about EXT4, but this only works if the clocks are
properly adjusted (not really hard to achieve though), but still racy.

cheers.

-- 
Carlos
