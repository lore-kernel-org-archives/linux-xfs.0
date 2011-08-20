Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7K9mAxN078702 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 04:48:10 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 89E391D9FFD2
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 02:48:08 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id ShX67JVc5SQhn2kF
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 02:48:08 -0700 (PDT)
Received: by wwi18 with SMTP id 18so2731913wwi.32
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 02:48:08 -0700 (PDT)
Message-ID: <4E4F814B.5070202@gmail.com>
Date: Sat, 20 Aug 2011 11:41:31 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi,

Il 28/06/2011 17:33, Josef Bacik ha scritto:
> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
> using fiemap in things like cp cause more problems than it solves, so lets try
> and give userspace an interface that doesn't suck.  We need to match solaris
> here, and the definitions are
>
> *o* If /whence/ is SEEK_HOLE, the offset of the start of the
> next hole greater than or equal to the supplied offset
> is returned. The definition of a hole is provided near
> the end of the DESCRIPTION.
>
> *o* If /whence/ is SEEK_DATA, the file pointer is set to the
> start of the next non-hole file region greater than or
> equal to the supplied offset.
>

I'm implementing the SEEK_DATA/SEEK_HOLE management for pramfs and I've 
got some doubts about the right behavior:

1) when we use SEEK_DATA/SEEK_HOLE, the offset used in lseek means 
always the offset from the start of the file, right?

2) in case of a file with hole at the beginning and data at the end, if 
I do lseek(fd, 0, SEEK_HOLE) I should receive the end of the file 
because the idea is to search the *next* hole and we have always a 
virtual hole at the end of the file, right?

3) about the last sentence of point 2), is it always true even if we 
have a case of block allocation beyond the end of file (fallocate with 
keep size option)?

Thanks.

Regards,

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
