Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2AMV5SP125600 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 16:31:11 -0600
Subject: Re: [PATCH] xfstests: rework "dmapi" subtree build mechanism
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110310172943.GD13390@infradead.org>
References: <201103041937.p24Jbk5W004828@stout.americas.sgi.com>
	<20110310172943.GD13390@infradead.org>
Date: Thu, 10 Mar 2011 16:33:56 -0600
Message-ID: <1299796436.10040.0.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2011-03-10 at 12:29 -0500, Christoph Hellwig wrote:
> >  LIB_SUBDIRS = include lib
> >  TOOL_SUBDIRS = ltp src m4
> > +ifeq ($(HAVE_DMAPI), true)
> > +TOOL_SUBDIRS += dmapi
> > +endif
> 
> Does this work with the way we generate source tarballs on make dist?
> In xfsprogs we have special variables for source files that don't get
> build.
> 
> > @@ -0,0 +1,30 @@
> > +#
> > +# Copyright (c) 2011 SGI  All Rights Reserved.
> > +#
> 
> I think a license would be more useful than all rights reserved here.
> 
> Except for that the patch looks sane to me, and having a consistent
> build system is a good thing.

Here's the text I'm using, FYI.

#
# Copyright (C) 2011 SGI  All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
