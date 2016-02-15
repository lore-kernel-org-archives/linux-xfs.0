Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A447B7CA2
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 11:26:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 945E5304039
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 09:26:42 -0800 (PST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id H4L9Y6rsRbKCcxTB
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Feb 2016 09:26:36 -0800 (PST)
Received: by mail-wm0-f53.google.com with SMTP id c200so123746895wme.0
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 09:26:36 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 15 Feb 2016 12:26:35 -0500
Message-ID: <CAJkH1p6LU=d5oLh3A+j_GQ70uoCYMjR=a5yS1w8p5d5ZXz6fwg@mail.gmail.com>
Subject: XFS fiemap issue with Linux 3.10.0-327.el7.x86_64 (CentOS 7)
From: Jim Wilcoxson <prirun@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I'm developing a backup program, HashBackup, and recently added sparse
"hole skipping" using fiemap.  Today I ran into a weird issue with xfs
on Linux 3.10.

A test program creates a sparse file with 10000*(4K data, 4M hole).
HB calls fiemap with start=0, length=0xFFFF...FFFF, mapped_extents=0
to get the number of extents.    Fiemap is coming back with
mapped_extents=1364 instead of 10000.

The fiemap.txt file says:

"If fm_extent_count is zero, then the fm_extents[] array is ignored
(no extents will be returned), and the fm_mapped_extents count will
hold the number of extents needed in fm_extents[] to hold the file's
current mapping."

It doesn't say the filesystem can choose to return fewer extents if it
wants, but maybe xfs interprets it this way and fiemap has to be
called in a loop until the extent_last flag is set.  If that's the
case, fiemap.txt should be updated.

Thanks,
Jim
(not on the xfs mailing list)
-- 
HashBackup: easy onsite and offsite Unix backup
http://www.hashbackup.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
