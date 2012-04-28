Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3S4DYbb246743 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 23:13:34 -0500
Received: from smtp.sauce.co.nz (smtp.sauce.co.nz [210.48.49.72]) by
	cuda.sgi.com with ESMTP id SdmHbK0vnY8lyzgH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Apr 2012 21:13:32 -0700 (PDT)
Message-ID: <4F9B6ECD.4070007@sauce.co.nz>
Date: Sat, 28 Apr 2012 16:15:09 +1200
From: Richard Scobie <richard@sauce.co.nz>
MIME-Version: 1.0
Subject: Re: A little RAID experiment
References: <4F99CD43.5070306@sauce.co.nz>
	<20120427233047.60eac0c6@galadriel.home>
In-Reply-To: <20120427233047.60eac0c6@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: stefanrin@gmail.com, xfs@oss.sgi.com

Emmanuel Florac wrote:

> Wouldn't it be preferable to use the RAID controller to host the log
> device? This way you profit from the write cache, as the log easily
> fits in.

This setup is md software RAID ;). The controller is an LSI 1068 using 
initiator-target firmware. There is no write cache I am aware of.

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
