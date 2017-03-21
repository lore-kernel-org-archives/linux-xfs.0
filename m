Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64067 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756686AbdCUPzO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 11:55:14 -0400
Date: Tue, 21 Mar 2017 23:55:12 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests: xfs/191 update
Message-ID: <20170321155512.GZ14226@eguan.usersys.redhat.com>
References: <20170315163347.29743-1-jtulak@redhat.com>
 <20170316074941.GS14226@eguan.usersys.redhat.com>
 <20170321152253.GB59313@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170321152253.GB59313@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Jan Tulak <jtulak@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Mar 21, 2017 at 11:22:54AM -0400, Brian Foster wrote:
> On Thu, Mar 16, 2017 at 03:49:41PM +0800, Eryu Guan wrote:
> > On Wed, Mar 15, 2017 at 05:33:47PM +0100, Jan Tulak wrote:
> > > The removed 'do_mkfs_pass -l size=4096b' was against man page
> > > (-b section). Other entries are things that weren't covered before.
> > > 
> > > Specifically, a standalone "-l size=4096b" should fail, because:
> > > To  specify any options on the command line in units of filesys‐
> > > tem blocks, this option must be  specified  first  so  that  the
> > > filesystem block size is applied consistently to all options.
> > > 
> > > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > 
> > This looks fine to me. But I'd like some reviews from xfs developers
> > too. (cc'd linux-xfs@vger.kernel.org).
> > 
> 
> So has mkfs been fixed to cause '-l size=4096b' to fail? I'm not sure we
> should cause the test to fail until/unless the mkfs behavior is fixed
> up.

I agreed, we don't want to update existing test and introduce false
regressions. This is one of the reasons I want more reviews on this
patch :)

Thanks,
Eryu
