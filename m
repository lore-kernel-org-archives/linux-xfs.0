Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2CLsNav144955 for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 16:54:23 -0500
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	24f1ubEuUMqd3VbT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 12 Mar 2012 14:54:22 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so4188623ghb.26
	for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 14:54:21 -0700 (PDT)
Received: by yenq2 with SMTP id q2so4215669yen.26
	for <xfs@oss.sgi.com>; Mon, 12 Mar 2012 14:54:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120312005632.GY5091@dastard>
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
	<20120312005632.GY5091@dastard>
Date: Mon, 12 Mar 2012 14:54:20 -0700
Message-ID: <CAEm1Pvm4+K3dBm+CQad3O2LLYBi76trYx9nBazwv5MNC24sZBg@mail.gmail.com>
Subject: Re: 1B files, slow file creation, only AG0 used
From: Michael Spiegle <mike@nauticaltech.com>
Reply-To: mike@nauticaltech.com
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

I believe we figured out what was going wrong:
1) You definitely need inode64 as a mount option
2) It seems that the AG metadata was being cached.  We had to unmount
the system and remount it to get updated counts on per-AG usage.

For the moment, I've written a script to copy/rename/delete our files
so that they are gradually migrated to new AGs.  FWIW, I noticed that
this operation is significantly faster on an EL6.2-based kernel
(2.6.32) compared to EL5 (2.6.18).  I'm also using the 'delaylog'
mount option which probably helps a bit.  I still have a few other
curiosities about this particular issue though:

On Sun, Mar 11, 2012 at 5:56 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Entirely normal. some operations require Io to complete (e.g.
> reading directory blocks to find where to insert the new entry),
> while adding the first file to a directory generally requires zero
> IO. You're seeing the difference between cold cache and hot cache
> performance.
>

In this situation, any files written to the same directory exhibited
this issue regardless of cache state.  For example:

Takes 300ms to complete:
touch tmp/0

Takes 600ms to complete:
touch tmp/0 tmp/1

Takes 1200ms to complete:
touch tmp/0 tmp/1 tmp/2 tmp/3

I would expect the directory to be cached after the first file is
created.  I don't understand why all subsequent writes were affected
as well.

>
> Go look up what the inode32 and inode64 mount options do. The
> default is inode32....
>

So now that we're mounting inode64, I wonder if we'll see degraded
performance in the future due to a sub-optimal on-disk layout of our
data.  Even though I am migrating data to other AGs, will there be any
permanent "damage" to AG0 since it had to allocate 1B inodes?  What
happens to all of that metadata when the files are removed?

Regards,
Mike

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
