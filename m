Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0P5K5tl168187 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 23:20:05 -0600
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id sop77SxwdXlcHDCn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jan 2012 21:20:00 -0800 (PST)
Received: by werb10 with SMTP id b10so4098134wer.26
	for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 21:19:59 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 25 Jan 2012 10:49:59 +0530
Message-ID: <CADDb1s2w9ZwMXn38n8TcxhFNrUsXN1Gnxq-suAP2-M+R7YhFsg@mail.gmail.com>
Subject: Does Ext4 support parallel write similar to XFS?
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

In XFS we can write parallel (i.,e we can make use of allocation
groups for writing process). If the files are kept in individual
directories, there is a possibility that first the blocks for that
files be used from individual allocation groups. If I start =914=92
writing process(cp 100MB_file /<dirnum>/) =96 after writing is finished
=96 if I check the bmap =96 it does shows that initial allocation was from
individual allocation groups.
Even though in Ext4 also we do have groups =96 but I am not able to get
behavior similar to XFS.
If I check the file extents =96 the extents are in mixed form, the
allocation pattern is also very fragmented.

Please share more on this. Also, if there is a possible exact test
case to check for parallel writes support.

Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
