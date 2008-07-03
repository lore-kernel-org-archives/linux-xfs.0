Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 05:47:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m63ClMK4022226
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 05:47:22 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6690E12D8F10
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 05:48:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id fUVCY0DofqBBSrFL for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 05:48:24 -0700 (PDT)
Date: Thu, 3 Jul 2008 13:47:10 +0100
From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080703124709.GI22522@agk.fab.redhat.com>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk, dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, mtk.manpages@googlemail.com, axboe@kernel.dk

On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
> If the freezer accesses the frozen filesystem and causes a deadlock,
> the above ideas can't solve it

But you could also say that if the 'freezer' process accesses the frozen
filesystem and deadlocks then that's just a bug and that userspace code
should be fixed and there's no need to introduce the complexity of a
timeout parameter.

> >Similarly if a device-mapper device is involved, how should the following
> >sequence behave - A, B or C?
> >
> >1. dmsetup suspend (freezes)
> >2. FIFREEZE
> >3. FITHAW
> >4. dmsetup resume (thaws)
> [...]
> >C:
> > 1 succeeds, freezes
> > 2 fails, remains frozen
> > 3 fails (because device-mapper owns the freeze/thaw), remains frozen
> > 4 succeeds, thaws
> 
> I think C is appropriate and the following change makes it possible.
> How do you think?
 
The point I'm trying to make here is:
  Under what real-world circumstances might multiple concurrent freezing
  attempts occur, and which of A, B or C (or other variations) would be
  the most appropriate way of handling such situations?

A common example is people running xfs_freeze followed by an lvm command
which also attempts to freeze the filesystem.

I can see a case for B or C, but personally I prefer A:

> > 1 succeeds, freezes
> > 2 succeeds, remains frozen
> > 3 succeeds, remains frozen
> > 4 succeeds, thaws

Alasdair
-- 
agk@redhat.com
