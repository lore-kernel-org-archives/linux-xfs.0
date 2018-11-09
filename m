Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:61814 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727137AbeKIKuy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Nov 2018 05:50:54 -0500
Date: Fri, 9 Nov 2018 12:04:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Message-ID: <20181109010401.GH19305@dastard>
References: <20181101110130.19489-1-jtulak@redhat.com>
 <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
 <20181102223435.GE19305@dastard>
 <CACj3i73fMu64uxrhrGTyP0k4a7Q4c1veUbJnviT7NddSzueLvQ@mail.gmail.com>
 <20181105114831.GJ19305@dastard>
 <CACj3i73WO-GFdgKhyk6GBcQ2Ebfs+hiojY+O1+JfYyBTPAvjXQ@mail.gmail.com>
 <20181105215253.GK19305@dastard>
 <CACj3i73YfktMZbdicfS5gcgoYpsunZnnzcvMxEhuEHanYs4Xgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73YfktMZbdicfS5gcgoYpsunZnnzcvMxEhuEHanYs4Xgg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Nov 08, 2018 at 06:39:21PM +0100, Jan Tulak wrote:
> On Mon, Nov 5, 2018 at 10:53 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Nov 05, 2018 at 01:25:45PM +0100, Jan Tulak wrote:
> > > On Mon, Nov 5, 2018 at 12:48 PM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Mon, Nov 05, 2018 at 11:15:34AM +0100, Jan Tulak wrote:
> > > > > On Fri, Nov 2, 2018 at 11:34 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > >
> > > > > > On Fri, Nov 02, 2018 at 12:43:18PM +0100, Jan Tulak wrote:
> > > > > > > On Fri, Nov 2, 2018 at 2:36 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > > > > > On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> > > > > > > > However, it's is the same change as what you originally posted to a
> > > > > > >
> > > > > > > Yes, it is the same thing, with changes where I found something
> > > > > > > misaligned on top.
> > > > > > >
> > > > > > > > git tree, then it needs revision. basically, most of the change was
> > > > > > > > converting vertically aligned function call parameters to use tabs,
> > > > > > > > and that broke the vertical alignment.
> > > > > > >
> > > > > > > It is "s/    /\t/" limited to the beginning of the line.
> > > > > >
> > > > > > You mean 's/^    /\t/'?
> > > > >
> > > > > Yes, but in multiple iterations to get \t, \t\t, \t\t\t, ...
> > > >
> > > > Which is handled by this regex: 's/^\(\t*\)*    /\1\t/'
> > > >
> > > > In this case, I'm using "*", which means "match zero or more of the
> > > > preceding expression" - which in this case is \t. That regex is
> > > > enclosed in \(...\) to group the result, which is then back
> > > > referenced in the output expression by \1 (first group backref).
> > > >
> > > > Regexes are extremely and flexible once you've learnt how the
> > > > multiple object matching rules work.
> > >
> > > I know. But I don't see how your regex would take the number of
> > > four-space groups and inserted the same number of \t,
> >
> > I thought you were asking about having multiple tabs preceding
> > the "4 space group". If you simply want to change all 4 space
> > groups, it's 's/\(    \)/\t/g':
> >
> 
> [snip]
> 
> Thanks, but I know regular expressions, even if I usually don't get a
> nontrivial expression on a first try. :-D
> 
> Anyway, how about this? I pushed it into a new branch (style-nov-8th)
> https://github.com/jtulak/xfsdump/tree/style-nov-8th
> (git clone --single-branch -b style-nov-8th
> https://github.com/jtulak/xfsdump.git)
> 
> It is now in 16 patches, split usually one change at a time. Three of
> them are over 500k in size, so I will need to cut them somehow into
> more parts before sending them into the mailing list.

Split them by dump/restore/inventory/common directories.

> But I ended up
> with a small script set that does it all, including the creation of
> commits, so I don't have to deal with conflicts if I will need to
> change anything.
> 
> Btw, I wonder if these formatting scripts could be useful if I push
> them somewhere publicly... About 2/3 are sed replacements, the last
> third are gradually stricter configurations for Uncrustify
> (http://uncrustify.sourceforge.net/, available in distro repos).

The scripts used for the transfomation should be documented in the
the commit messages. e.g:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=37b3b4d6c38aaf501dd7714d9670bff4ac282923

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
