Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9BE2ih6238837 for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 09:02:44 -0500
Received: from mail-yx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 194D6DA899
	for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 07:03:50 -0700 (PDT)
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	JlBASB6znCZFMFV3 for <xfs@oss.sgi.com>;
	Mon, 11 Oct 2010 07:03:50 -0700 (PDT)
Received: by yxh35 with SMTP id 35so1288665yxh.26
	for <xfs@oss.sgi.com>; Mon, 11 Oct 2010 07:03:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101008225146.GJ4681@dastard>
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
	<20101008225146.GJ4681@dastard>
From: James Braid <jamesb@loreland.org>
Date: Mon, 11 Oct 2010 15:03:28 +0100
Message-ID: <AANLkTikLyEuSoFRVwirKLws97Vemz4ScNHOqu2Jc5sWR@mail.gmail.com>
Subject: Re: ENOSPC at 90% with plenty of inodes
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 8, 2010 at 23:51, Dave Chinner <david@fromorbit.com> wrote:
> Sounds like fragmented free space. What is the output of:
>
> # xfs_db -r -c "freesp -s" <device>

# xfs_db -r -c "freesp -s" /dev/sdb
   from      to extents  blocks    pct
      1       1 2298052 2298052  40.52
      2       3 1568338 3337017  58.84
      4       7    8432   35716   0.63
      8      15      50     423   0.01
total free extents 3874872
total free blocks 5671208
average free extent size 1.46359

Which seems to say there are a few tiny pieces of free space
available? The files that were failing to be written were a few
hundred bytes in size.

We haven't seen any errors so far today, but xfs_fsr ran over the
weekend, so perhaps I guess it's reorganized the filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
