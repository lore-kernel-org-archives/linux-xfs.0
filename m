Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBL3eGRe211137 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 21:40:16 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id Cfr72RJV2FKGTvrK
	for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 19:40:14 -0800 (PST)
Received: by lagr15 with SMTP id r15so3473683lag.26
	for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 19:40:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111220220433.GZ23662@dastard>
References: <CADDb1s1cSM0vS3gnO369hwHwe5dJ0Afaf_6wNVDf0eT-jTvKCg@mail.gmail.com>
	<20111220220433.GZ23662@dastard>
Date: Wed, 21 Dec 2011 09:10:13 +0530
Message-ID: <CADDb1s3E7Lq_e9pS2r7sNR_qsHr5zR54F1Wtmf15XyJvDVVG1Q@mail.gmail.com>
Subject: Re: XFS: attempt to access beyond end of device
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 21, 2011 at 3:34 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Dec 20, 2011 at 07:18:15PM +0530, Amit Sahrawat wrote:
>> Hi,
>>
>> While trying to open a file with a large number of extents in append
>> mode =96 it resulted in the below error logs continually.
>> I was trying to open the file in append mode, but it showed error, so
>> I checked for the extents =96 it has around 2238 extents. Although, it
>
> The first question you have to get to the bottom of is if there are
> only 2238 extents in the file, why is the xfs_bmap output showing
> more than that?
Actually the output got mismatched, 2238 was the number when I checked
the issue, while xfs_bmap results were for the last traces observed.
Sorry for the confusion.
>
>> is not repetitive, when I try on next mount and write =96 it is working
>> fine at times.
>> Also, the system does not seem to be corrupted. Since, running
>> xfs_repair after umount does not show any errors.
>
> Which implies memory corruption. Have you turned on memory poisoning
> and the memory leak detection to see if it detects any problems?
>
> What about running with CONFIG_XFS_DEBUG=3Dy? Does that trip any
> problems sooner than the corruption is detected?
I will try with CONFIG_XFS_DEBUG.

Thanks & Regards,
Amit Sahrawat
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
