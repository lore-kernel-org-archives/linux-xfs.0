Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S947943AbdDZBpd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 21:45:33 -0400
Date: Wed, 26 Apr 2017 03:45:31 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 04/12] mkfs: merge tables for opts parsing into one table
Message-ID: <20170426014531.GU28800@wotan.suse.de>
References: <20170423185503.31415-1-jtulak@redhat.com>
 <20170423185503.31415-5-jtulak@redhat.com>
 <20170425030421.GH28800@wotan.suse.de>
 <CACj3i71jEx7aKBp4_bTk3KbHo1ne_Zj1r6y-=8iGLOkM2PujEQ@mail.gmail.com>
 <175c1e19-12df-2993-811d-b5de631ac00f@sandeen.net>
 <20170426013815.GS28800@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170426013815.GS28800@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 03:38:15AM +0200, Luis R. Rodriguez wrote:
> On Tue, Apr 25, 2017 at 08:28:23AM -0500, Eric Sandeen wrote:
> > On 4/25/17 2:45 AM, Jan Tulak wrote:
> > > On Tue, Apr 25, 2017 at 5:04 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > >> On Sun, Apr 23, 2017 at 08:54:55PM +0200, Jan Tulak wrote:
> > >>> Merge separate instances of opt_params into one indexable table. Git
> > >>> makes this patch looks a bit more complicated, but it does not change
> > >>> values or structure of anything else. It only moves all the "struct
> > >>> opt_params dopts = {...}", changes indentation for these substructures
> > >>> and replaces their usage (dopts -> opts[OPT_D]).
> > >>>
> > >>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > >>> ---
> > >>>  mkfs/xfs_mkfs.c | 1316 +++++++++++++++++++++++++++++--------------------------
> > >>>  1 file changed, 683 insertions(+), 633 deletions(-)
> > >>>
> > >>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > >>> index 7a72b11..513e106 100644
> > >>> --- a/mkfs/xfs_mkfs.c
> > >>> +++ b/mkfs/xfs_mkfs.c
> > >>> @@ -42,6 +42,7 @@ static int  ispow2(unsigned int i);
> > >>>  uint64_t             blocksize;
> > >>>  uint64_t             sectorsize;
> > >>>
> > >>> +#define MAX_OPTS     16
> > >>
> > >> This is fragile, every time a new opt is added this needs to be updated
> > 
> > <pedantic>There are only 8 now, so there are still 8 free slots</pedantic>
> > 
> > >> and so is the index, and we should be pedantic over not going out of bounds.
> > >> We could instead use a flexible array and compute the max opts at run time
> > >> as a global. This way the max opts is always updated automatically.
> > 
> > I don't think it's all that fragile;
> 
> We can avoid such compilation warnings.

Oh and save memory by 8 struct opt_params. Why not.

  Luis
