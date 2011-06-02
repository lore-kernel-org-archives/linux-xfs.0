Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52NxUvm231770 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 18:59:31 -0500
Received: from mail-pw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CD4614E28BD
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 16:59:29 -0700 (PDT)
Received: from mail-pw0-f53.google.com (mail-pw0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id EILo2olvbVNcrBa5
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 16:59:29 -0700 (PDT)
Received: by pwj5 with SMTP id 5so792418pwj.26
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 16:59:29 -0700 (PDT)
Message-ID: <4DE823DD.7060600@philkarn.net>
Date: Thu, 02 Jun 2011 16:59:25 -0700
From: Phil Karn <karn@philkarn.net>
MIME-Version: 1.0
Subject: Re: I/O hang, possibly XFS, possibly general
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
In-Reply-To: <BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 6/2/11 2:24 PM, Paul Anderson wrote:

> The data itself has very odd lifecycle behavior, as well - since it is
> research, the different stages are still being sorted out, but some
> stages are essentially write once, read once, maybe keep, maybe
> discard, depending on the research scenario.
...
> The bulk of the work is not small-file - almost all is large files.

Out of curiosity, do your writers use the fallocate() call? If not, how
fragmented do your filesystems get?

Even if most of your data isn't read very often, it seems like a good
idea to minimize its fragmentation because that also reduces
fragmentation of the free list, which makes it easier to keep contiguous
other files that *are* heavily read. Also, fewer extents per file means
less metadata per file, ergo less metadata and log I/O, etc.

When a writer knows in advance how big a file will be, I can't see any
downside to having it call fallocate() to let the file system know. Soon
after I switched to XFS six months ago I've been running locally patched
versions of rsync/tar/cp and so on, and they really do minimize
fragmentation with very little effort.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
