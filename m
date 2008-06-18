Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 10:48:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IHmEXN012932
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:48:16 -0700
Received: from ext.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 768A5CE57A6
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:49:12 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177]) by cuda.sgi.com with ESMTP id bOHfjipoYCbWRA41 for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:49:12 -0700 (PDT)
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id m5IHmnmb011345
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:48:49 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id m5IHmjuG017143
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 10:48:49 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: is the flush-on-close-after-truncate still needed?
Date: Wed, 18 Jun 2008 10:49:07 -0700
References: <4859415B.3000009@sandeen.net>
In-Reply-To: <4859415B.3000009@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181049.07812.dchinner@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wednesday 18 June 2008 10:09 am, Eric Sandeen wrote:
> After Lachlan's fix to separate on-disk and in-memory sizes, and only
> update on-disk when data is on-disk
> (http://www.linux.sgi.com/archives/xfs/2007-05/msg00020.html) is the
> XFS_ITRUNCATED flag / flush-on-close-after-truncate still needed?

Yes, because waiting 30s before writing back /etc/fstab after it
has been modified will result in lots of bug reports of /etc/fstab
being zero length after a crash instead of being full of NULLs.
We have had very few reports of zero length files or files with
NULLs since this change was made (regardless of the file size 
update ordering changes). i.e. if we remove this code then the
common case where NULL files occurred will return - only this
time as zero length files.

Cheers,

Dave.
