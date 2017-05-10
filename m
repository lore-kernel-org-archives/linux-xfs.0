Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751741AbdEJIMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 04:12:40 -0400
Date: Wed, 10 May 2017 10:12:35 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
  mounts)
Message-ID: <20170510081235.qjez42rvpdkzspf5@eorzea.usersys.redhat.com>
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
 <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
 <20170505122547.6gvqmdoxfaqxh3mi@eorzea.usersys.redhat.com>
 <c5e42df06ff981bfd6a72cbc12f10d43@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5e42df06ff981bfd6a72cbc12f10d43@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Fri, May 05, 2017 at 03:19:45PM +0200, Gionatan Danti wrote:
> Il 05-05-2017 14:25 Carlos Maiolino ha scritto:
> > 
> > As far as I know, don't, I can always be wrong, but, I re-checked xfs
> > superblock, and could not find anything that actually protects it.
> > 
> 
> So, how do you protect iSCSI targets from erroneous multiple mount? Do you
> protect them only at the target/lun level (eg: access list on the
> target/lun)?

Well, having a planned infra-structure is a way, and using UUIDs for mounting
the filesystems are two good ways to avoid mistakes with multiple mounts. UUIDs
are unique for each filesystem, so even if the device name changes between
boots, you can still be sure to mount the correct filesystem on the correct
system by using their UUIDs

Cheers

-- 
Carlos
