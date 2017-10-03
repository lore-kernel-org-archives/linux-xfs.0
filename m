Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44887 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751084AbdJCUji (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Oct 2017 16:39:38 -0400
Date: Tue, 3 Oct 2017 22:39:36 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC 2/5] fs: freeze on suspend and thaw on resume
Message-ID: <20171003203936.GH2294@wotan.suse.de>
References: <20171003185313.1017-1-mcgrof@kernel.org>
 <20171003185313.1017-3-mcgrof@kernel.org>
 <1507060941.2567.6.camel@wdc.com>
 <20171003202335.GF2294@wotan.suse.de>
 <1507062758.2567.22.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1507062758.2567.22.camel@wdc.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mcgrof@kernel.org" <mcgrof@kernel.org>, "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "ONeukum@suse.com" <ONeukum@suse.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nborisov@suse.com" <nborisov@suse.com>, "oleg.b.antonyan@gmail.com" <oleg.b.antonyan@gmail.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "jgross@suse.com" <jgross@suse.com>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>, "todd.e.brandt@linux.intel.com" <todd.e.brandt@linux.intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "jikos@kernel.org" <jikos@kernel.org>, "len.brown@intel.com" <len.brown@intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>

On Tue, Oct 03, 2017 at 08:32:39PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-03 at 22:23 +0200, Luis R. Rodriguez wrote:
> > On Tue, Oct 03, 2017 at 08:02:22PM +0000, Bart Van Assche wrote:
> > > On Tue, 2017-10-03 at 11:53 -0700, Luis R. Rodriguez wrote:
> > > > +static bool super_allows_freeze(struct super_block *sb)
> > > > +{
> > > > +	return !!(sb->s_type->fs_flags & FS_FREEZE_ON_SUSPEND);
> > > > +}
> > > 
> > > A minor comment: if "!!" would be left out the compiler will perform the
> > > conversion from int to bool implicitly
> > 
> > For all compilers?
> 
> Let's have a look at the output of the following commands:
> 
> $ PAGER= git grep 'typedef.*[[:blank:]]bool;' include
> include/linux/types.h:typedef _Bool                     bool;
> $ PAGER= git grep std= Makefile
> Makefile:               -fomit-frame-pointer -std=gnu89 $(HOST_LFS_CFLAGS)
> Makefile:                  -std=gnu89 $(call cc-option,-fno-PIE)
> 
> From https://gcc.gnu.org/onlinedocs/gcc-7.2.0/gcc/C-Dialect-Options.html#C-Dialect-Options:
> ‘gnu89’
> GNU dialect of ISO C90 (including some C99 features).
> 
> I think this means that the Linux kernel tree can only be compiled correctly
> by compilers that support the C11 type _Bool.

:*) beautiful, thanks.

> > > Anyway, I agree with the approach of this patch and I think
> > > that freezing filesystems before processes are frozen would be a big step
> > > forward.
> > 
> > Great! But please note, the current implementation calls fs_suspend_freeze()
> > *after* try_to_freeze_tasks(), ie: this implementation freezes userspace and
> > only after then filesystems.
> 
> What will the impact be of that choice on filesystems implemented in userspace?

Depends on what kernel hooks those use? Also now is a good time for those working
on userspace filesystems to chime in :) Its why I am stating -- I am not saying
I have found the right order, I have find the right order that works for me, and
we need consensus on what the right order should be.

  Luis
