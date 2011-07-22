Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PDAK45002548 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 08:10:20 -0500
Subject: Re: [PATCH XFSPROGS 2/3] Build without enabling DEBUG by default
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722183830.GA21744@infradead.org>
References: <1311292237-4155-1-git-send-email-tytso@mit.edu>
	<1311292237-4155-2-git-send-email-tytso@mit.edu>
	<20110722141753.GA19681@infradead.org>
	<20110722183048.GC25092@thunk.org>
	<20110722183830.GA21744@infradead.org>
Date: Fri, 22 Jul 2011 17:30:48 -0500
Message-ID: <1311373848.2771.164.camel@doink>
MIME-Version: 1.0
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On Fri, 2011-07-22 at 14:38 -0400, Christoph Hellwig wrote:
> On Fri, Jul 22, 2011 at 02:30:48PM -0400, Ted Ts'o wrote:

. . .

> A typical V=1 compile line looks like:
> 
> /bin/bash ../libtool --quiet --tag=CC --mode=compile gcc -I. -g -O2
> -DNDEBUG -DVERSION=\"3.1.5\" -DLOCALEDIR=\"/usr/share/locale\"
> -DPACKAGE=\"xfsprogs\" -I../include -DENABLE_GETTEXT -D_GNU_SOURCE
> -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 -funsigned-char
> -fno-strict-aliasing -Wall    -c xfs_dir2_sf.c

FWIW, I get a compile line for xfs_dir2_sf.c identical to
what Christoph supplied.

> for me.  The biggest thing is that you have another directory in your
> include path.  How did you add that one? Did you add anything else
> special to the ./configure or make command lines?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
