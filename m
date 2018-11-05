Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:56684 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387672AbeKFHOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Nov 2018 02:14:45 -0500
Date: Tue, 6 Nov 2018 08:52:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Message-ID: <20181105215253.GK19305@dastard>
References: <20181101110130.19489-1-jtulak@redhat.com>
 <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
 <20181102223435.GE19305@dastard>
 <CACj3i73fMu64uxrhrGTyP0k4a7Q4c1veUbJnviT7NddSzueLvQ@mail.gmail.com>
 <20181105114831.GJ19305@dastard>
 <CACj3i73WO-GFdgKhyk6GBcQ2Ebfs+hiojY+O1+JfYyBTPAvjXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i73WO-GFdgKhyk6GBcQ2Ebfs+hiojY+O1+JfYyBTPAvjXQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 05, 2018 at 01:25:45PM +0100, Jan Tulak wrote:
> On Mon, Nov 5, 2018 at 12:48 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Mon, Nov 05, 2018 at 11:15:34AM +0100, Jan Tulak wrote:
> > > On Fri, Nov 2, 2018 at 11:34 PM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > On Fri, Nov 02, 2018 at 12:43:18PM +0100, Jan Tulak wrote:
> > > > > On Fri, Nov 2, 2018 at 2:36 AM Dave Chinner <david@fromorbit.com> wrote:
> > > > > > On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> > > > > > However, it's is the same change as what you originally posted to a
> > > > >
> > > > > Yes, it is the same thing, with changes where I found something
> > > > > misaligned on top.
> > > > >
> > > > > > git tree, then it needs revision. basically, most of the change was
> > > > > > converting vertically aligned function call parameters to use tabs,
> > > > > > and that broke the vertical alignment.
> > > > >
> > > > > It is "s/    /\t/" limited to the beginning of the line.
> > > >
> > > > You mean 's/^    /\t/'?
> > >
> > > Yes, but in multiple iterations to get \t, \t\t, \t\t\t, ...
> >
> > Which is handled by this regex: 's/^\(\t*\)*    /\1\t/'
> >
> > In this case, I'm using "*", which means "match zero or more of the
> > preceding expression" - which in this case is \t. That regex is
> > enclosed in \(...\) to group the result, which is then back
> > referenced in the output expression by \1 (first group backref).
> >
> > Regexes are extremely and flexible once you've learnt how the
> > multiple object matching rules work.
> 
> I know. But I don't see how your regex would take the number of
> four-space groups and inserted the same number of \t,

I thought you were asking about having multiple tabs preceding
the "4 space group". If you simply want to change all 4 space
groups, it's 's/\(    \)/\t/g':

$ echo "                " |sed -e 's/\(    \)/T/g'
TTTT
$

The positional match selector suffix is the key here. 'g' means
"global match" and replaces every occurrence on the line. If you use
a number, it replaces the N'th occurrence:

$ echo "                " |sed -e 's/\(    \)/T/1'
T            
$ echo "                " |sed -e 's/\(    \)/T/2'
    T        
$ echo "                " |sed -e 's/\(    \)/T/3'
        T    
$ echo "                " |sed -e 's/\(    \)/T/4'
            T
> which is what I
> was trying to do and AFAIK there is no way to do it with sed. I know
> it could be done with awk,

awk is still regex based, it just allows you to get away with simple
regexes by adding complex code :P

> but writing it would take more time for me
> than re-running s/^        /\t\t/ with a manually changed number of
> occurrences, from one to say 5 levels (or until I stop getting any
> changes).

Grouping and positional selection is the answer here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
