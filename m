Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBA9iFtX068165 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 03:44:15 -0600
Received: from qw-out-2122.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D3AD1949013
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 01:44:49 -0800 (PST)
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by cuda.sgi.com with ESMTP id c4CTQbhiaBkYDzN7 for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 01:44:49 -0800 (PST)
Received: by qw-out-2122.google.com with SMTP id 9so1384527qwb.63
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 01:44:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B204334.1000605@shiftmail.org>
References: <4B204334.1000605@shiftmail.org>
From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Date: Thu, 10 Dec 2009 09:44:28 +0000
Message-ID: <73e903670912100144k2675754n2ef688a944364b42@mail.gmail.com>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
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
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Dec 10, 2009 at 12:39 AM, Asdo <asdo@shiftmail.org> wrote:
> Hi all,
>
> I'm copying a bagzillion of files (14TB) from a 26disk MD-raid 6 array to a
> 16disk MD-raid 6 array.
> Filesystems are XFS for both arrays.
> Kernel is 2.6.31 ubuntu generic-14
> Performance is very disappointing, going from 150MB/sec to 22MB/sec
> depending apparently to the size of files it encounters. 150MB/sec is when
> files are 40-80MB in size, 22MB/sec is when files are 1MB in size on
> average, and I think I have seen around 10MB/sec when they are of 500KB
> (this transfer at 10MB/sec was in parallel with another faster one however).

This may not be related, but I have had some general problems
regarding transfer rates in Ubuntu. Using a vanilla kernel seemed to
help: http://kernel.ubuntu.com/~kernel-ppa/mainline/

-- Kristleifur

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
