Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52359 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbeJDOx1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Oct 2018 10:53:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id 189-v6so8083088wmw.2
        for <linux-xfs@vger.kernel.org>; Thu, 04 Oct 2018 01:01:27 -0700 (PDT)
Date: Thu, 4 Oct 2018 10:01:23 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/2] xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
Message-ID: <20181004080123.n7nusezmytljtr6t@odin.usersys.redhat.com>
References: <20181003123537.30965-1-cmaiolino@redhat.com>
 <20181003123537.30965-2-cmaiolino@redhat.com>
 <46ff8aca-5053-541d-6d74-fbc7e12a9898@sandeen.net>
 <20181003133914.gikxezpadsyil7hp@odin.usersys.redhat.com>
 <a4352f35-6cd9-6b05-a914-86c33fb11b33@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4352f35-6cd9-6b05-a914-86c33fb11b33@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 03, 2018 at 08:59:52AM -0500, Eric Sandeen wrote:
> On 10/3/18 8:39 AM, Carlos Maiolino wrote:
> > On Wed, Oct 03, 2018 at 07:47:46AM -0500, Eric Sandeen wrote:
> >> On 10/3/18 7:35 AM, Carlos Maiolino wrote:
> >>> The addition of FIBT, RMAP and REFCOUNT changed the offsets into
> >>> __xfssats structure.
> >>>
> >>> Although this didn't cause any direct issue,  xqmstat_proc_show() relied
> >>> on the old offsets to display the xqm statistics.
> >>
> >> Well, it caused /proc/fs/xfs/xqmstat to display garbage data, right?
> >> That seems worth highlighting in the changelog, and not glossing over.
> > 
> > Well, I wouldn't say 'garbage' data. I'd say data from other fields in the
> > structure (at this point, specifically fino btree data) :P, but sure, I can add
> > it to the changelog.
> 
> That's kind of like saying stale data exposure or kernel memory leaks isn't
> garbage data, it's just someone /else's/ data.  ;)
> 
> Anyway, however you want to phrase it, aI think the change needs to highlight
> that there /is/ a failure and it's not an irrelevant fix.
> 

Sure, I'll resubmit the patch again with updated description  together with a
new version of patch 2, I am considering to do what Dave suggested and replace
the defines by offsetof() macros, but well, will see.

I'll add your reviewed-by flag to the patch 1, is it ok? I think that's what you
meant with your previous reply?

> >>
> >> Could maybe use Fixes: tags for:
> >>
> >> 00f4e4f9 xfs: add rmap btree stats infrastructure
> >> aafc3c24 xfs: support the XFS_BTNUM_FINOBT free inode btree type
> >> 46eeb521 xfs: introduce refcount btree definitions
> >>
> > 
> > No objection.
> > 
> >> and a stable tag as well?  Though stable is tricky because different patches
> >> would be required for different points along the stats structure evolution...
> >> maybe best to ignore it, chances of auto-applying it correctly are slim to
> >> none.
> > 
> > Indeed, this may not apply to stable trees, unless the tree itself contains all
> > three data structures (rmap finobtree and refcount).
> 
> Yeah.  It would go back to 4.10 cleanly, tho.  Just a thought.

Ok,
Cheers

> 
> -Eric

-- 
Carlos
