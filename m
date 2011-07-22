Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MIUrQZ099342 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:30:53 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9A078ECC4
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:30:52 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 9mt9RKa5qlYFAcKi for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 11:30:52 -0700 (PDT)
Date: Fri, 22 Jul 2011 14:30:48 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
Message-ID: <20110722183048.GC25092@thunk.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
	<20110722141753.GA19681@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722141753.GA19681@infradead.org>
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 10:17:53AM -0400, Christoph Hellwig wrote:
> On Thu, Jul 21, 2011 at 07:50:36PM -0400, Theodore Ts'o wrote:
> > The tree currently will blow out with a build failure if -DDEBUG is
> > specified.
> 
> This still doesn't make sense to me.  libxfs explicily overrides
> DEBUG in the makefile:
> 
> # don't try linking xfs_repair with a debug libxfs.
> DEBUG = -DNDEBUG

I added some debugging statements in libxfs/Makefile, and found this
(see below).

It looks like the problem is that GNU make 3.81 is doing an immediate
expansion of this line in builddefs:

CFLAGS += $(FCFLAGS) $(GCFLAGS) $(PCFLAGS) $(LCFLAGS)

							- Ted

LTCOMPILE is /bin/sh ../libtool --quiet --tag=CC --mode=compile gcc -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
FCFLAGS is -I.
GCFLAGS is -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT
PCFLAGS is -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
CFLAGS is -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall
CCF is gcc -I/kbuild/xfstests/bld/include -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -g -O2 -DDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I./include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall -I. -g -O2 -DNDEBUG -DVERSION="3.1.5" -DLOCALEDIR="//share/locale" -DPACKAGE="xfsprogs" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
