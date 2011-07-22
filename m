Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MIcYOJ099657 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:38:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D5AF1D8AA5C
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:38:33 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YetAJJ8fDaPJHTWd for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 11:38:33 -0700 (PDT)
Date: Fri, 22 Jul 2011 14:38:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Message-ID: <20110722183830.GA21744@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
	<20110722141753.GA19681@infradead.org>
	<20110722183048.GC25092@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722183048.GC25092@thunk.org>
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
To: Ted Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 02:30:48PM -0400, Ted Ts'o wrote:
> I added some debugging statements in libxfs/Makefile, and found this
> (see below).

You can get most of this by simply using make V=1, not just in xfsprogs,
but in most projects using silent make output (including those using
automake)

> It looks like the problem is that GNU make 3.81 is doing an immediate
> expansion of this line in builddefs:

I'm having GNU make 3.81 on most of my test systems as well, so that
alone can't be the whole issue.

> CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)
> 

> LTCOMPILE is /bin/sh ../libtool --quiet --tag=CC --mode=compile gcc -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall

A typical V=1 compile line looks like:

/bin/bash ../libtool --quiet --tag=CC --mode=compile gcc -I. -g -O2 -DNDEBUG -DVERSION=\"3.1.5\" -DLOCALEDIR=\"/usr/share/locale\" -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall    -c xfs_dir2_sf.c

for me.  The biggest thing is that you have another directory in your
include path.  How did you add that one? Did you add anything else
special to the ./configure or make command lines?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
