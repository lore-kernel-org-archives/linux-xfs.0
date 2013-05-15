Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2053D7F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 02:33:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EC1AC304066
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 00:33:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NCADVekEmigjAkiO for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 00:33:06 -0700 (PDT)
Date: Wed, 15 May 2013 17:33:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Why xfs can not mount use barrier option?
Message-ID: <20130515073304.GR29466@dastard>
References: <CACeqxwRdq-wuz9xpa9p=kQvYgjJQYRMP2JLsyv7SChqx8b-ujw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACeqxwRdq-wuz9xpa9p=kQvYgjJQYRMP2JLsyv7SChqx8b-ujw@mail.gmail.com>
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
To: ch huang <justlooks@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, May 15, 2013 at 03:08:56PM +0800, ch huang wrote:
> i use lvm on raid 1,/dev/CHVG01/conxfs is a logical volume,if i  mount with
> barrier,the /proc/mounts still show nobarrier option ,why?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> #  mount -t xfs -o barrier,attr2,noikeep,inode64 /dev/CHVG01/conxfs /opt/contest/
> # cat /proc/mounts
> /dev/CHVG01/conxfs /opt/contest xfs rw,attr2,nobarrier,inode64,noquota 0 0

Check dmesg - most likely something in your storage stack doesn't
support barriers so they got turned off....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
