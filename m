Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3N2lg62006585 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 21:47:43 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D64AE10590F9
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 19:49:41 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id QKqLVah06EbDvODo for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 19:49:41 -0700 (PDT)
Date: Fri, 23 Apr 2010 10:48:25 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: different error messages for mkfs.xfs -ssize
Message-ID: <20100423024825.GA2949@laptop.oracle.com>
References: <20100422153636.GB3822@laptop.oracle.com>
	<F57F2AD357626644AF76410876025D751277F5@CGYEX705.encana.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F57F2AD357626644AF76410876025D751277F5@CGYEX705.encana.com>
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
To: "Kinzel, David" <David.Kinzel@encana.com>
Cc: xfs@oss.sgi.com, joe.jin@oracle.com, greg.marsden@oracle.com, Wengang Wang <wen.gang.wang@oracle.com>

On 10-04-22 10:18, Kinzel, David wrote:
> >-----Original Message-----
> >From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] 
> >On Behalf Of Wengang Wang
> >Sent: Thursday, April 22, 2010 9:37 AM
> >To: xfs@oss.sgi.com
> >Cc: greg.marsden@oracle.com; joe.jin@oracle.com
> >Subject: different error messages for mkfs.xfs -ssize
> >
> >Hi experts,
> >
> >I got different error messages when provide different value for -ssize.
> >Why the error messages are different? They are different but no one is
> >containing more info than the other.
> 
> 1639         if (sectorsize < XFS_MIN_SECTORSIZE ||
> 1640             sectorsize > XFS_MAX_SECTORSIZE || sectorsize >
> blocksize) {
> 1641                 fprintf(stderr, _("illegal sector size %d\n"),
> sectorsize);
> 1642                 usage();
> 1643         }
> 
> According to the defaults:
> 
> 62 #define XFS_MIN_SECTORSIZE_LOG  9       /* i.e. 512 bytes */
> 64 #define XFS_MIN_SECTORSIZE      (1 << XFS_MIN_SECTORSIZE_LOG)
> 
> Looks like your sectorsize is not greater than XFS_MIN_SECTORSIZE
> (illegal sector size)
> 
> For 3072,
> 
> 1561                                         if (sectorsize <= 0 ||
> 1562                                             !ispow2(sectorsize))
> 1563                                                 illegal(value, "s
> sectsize");
> 
> 3072 is not a power of two (illegal value)

Yes. That are the places where different error messges are printed.
I meant If there is no more info for a message than the other, It's
better that the messages are the same.

Thanks a lot!

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
