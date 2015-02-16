Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 099B07F3F
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 08:20:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E46578F8050
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 06:20:54 -0800 (PST)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
	[209.85.215.49]) by cuda.sgi.com with ESMTP id dR9s4ENuvYsSkTRP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Feb 2015 06:20:51 -0800 (PST)
Received: by labgq15 with SMTP id gq15so29080005lab.3
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 06:20:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJAKVEFD+eGgJ1W8i-t=PkifuVtVOka1hwqKWSo_5nLQo2r88g@mail.gmail.com>
References: <CAJAKVEGb0aByGqg28anFG4SJVjP-Z3Qs_=JiDMSu_4Gd4nvAbA@mail.gmail.com>
	<20150204195555.GR6282@dastard>
	<CAJAKVEFD+eGgJ1W8i-t=PkifuVtVOka1hwqKWSo_5nLQo2r88g@mail.gmail.com>
Date: Mon, 16 Feb 2015 19:50:50 +0530
Message-ID: <CAJAKVEGk0caS0uan6LuVJN15V1zGpRSQi7ZtsKGu+fC4SiqOZA@mail.gmail.com>
Subject: Re: Mails sent to the XFS mailing list
From: Somdeep Dey <somdeepdey10@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Hi Dave,

We have sent a RFD mail on the mailing list about the current task that we
are doing: defragmenting parts of a file. (Haven't got a response yet)

http://oss.sgi.com/archives/xfs/2015-02/msg00264.html

We were actually stuck on a logical aspect, of how to go ahead performing
defragmentation without creating a temporary file, and then copy extents to it.

-----------------------------------------------------------------------------------------------------

File: fsr/xfs_fsr.c

In fsr/xfs_fsr.c code , we also had a doubt about how to modify the number of
extents for the temp file getting created.

Line 1321 onwards:
It would be of great help if u could shed some light on the ioctl's -
XFS_IOC_UNRESVSP64 and XFS_IOC_RESVSP64,

We took a test case where a file had 3 extents. The for loop at line 1321 now
had nextents value as 1 (i.e ideal extent count 1) and
outmap[extent].bmv_length was addition of all blocks, i.e. outmap[ ] array had
one index (for 1 ideal extent)

After that we tried running a defragmentation test, by making read_fd_bmap()
function return nextents value as 2, and subsequently made outmap[ ] have
two entries instead of one.

However the temp file that got created (Line 1321 onwards) still had
new_nextents
as 1 (Line 1382) instead of having 2.
Any thoughts ? :)

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
