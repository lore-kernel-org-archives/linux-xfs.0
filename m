Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0B6D57F4E
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 08:10:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECC6C30408E
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 06:10:55 -0700 (PDT)
Received: from mail-oa0-f42.google.com (mail-oa0-f42.google.com
	[209.85.219.42]) by cuda.sgi.com with ESMTP id yHAwtGHlfn2tdFna
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Oct 2013 06:10:54 -0700 (PDT)
Received: by mail-oa0-f42.google.com with SMTP id k14so6527500oag.1
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 06:10:53 -0700 (PDT)
In-Reply-To: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
References: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
MIME-Version: 1.0
Subject: Re: 128 bits extent bmap for file format 2
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Tue, 22 Oct 2013 09:11:06 -0400
Message-ID: <a3208864-e046-4034-ac3b-1ce6f7ae352b@email.android.com>
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
To: Pradeep Kumar <praks411@gmail.com>, xfs@oss.sgi.com



Pradeep Kumar <praks411@gmail.com> wrote:
>Hi,
>
>I'm writing a small utility to parse XFS fs image on windows.
>I'm able to fetch the files in the first AG (0).
>However when it comes to the files which are in different AG I'm facing
>some problem in parsing extent bmap 128bits data of file inode (format
>==
>2).
>
>Here is the sample 128bits data
>1. 00 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)
>
>After unpacking the bits are per doc and source code
>In the above case I'm getting following
>Num Of blocks = 1 (correct) (0 to 20 bits)
>absolute block number = 9420 (0x24CC) (wrong) (21 to 72)
>file offset = 0 (72 to 126)
>
>I'm always getting wrong absolute block number . Actual data is in
>block
>7628 (0x1DCC).
>No matter what I try I'm always getting the same result. I've even
>verified
>this
>by using the code from xfs_bmbt_get_all function from xfs source which
>too
>gives me same result (9420).
>Please someone help me with this. I'm stuck on this from 3 days.
>
>Thanks and Regards,
>Pradeep

Pradeep,

It would be cool if your utility could be incorporated into sleuthkit.  Sleuthkit has fat and NTFS parsers for sure already.  I think ext2 and ext3.  Adding a xfs parser would be a cool addition.

 http://www.sleuthkit.org/sleuthkit/docs/api-docs/index.html#users_guide

Fyi: sleuthkit has been around for a long time, but it is still actively maintained and heavily used.  It is in several linux distros, but is also available for windows.

Greg
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
