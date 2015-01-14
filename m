Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E53E27F3F
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 00:13:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D019E304039
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 22:13:00 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id 4LTvfmNQ4kINN3Ty for
	<xfs@oss.sgi.com>; Tue, 13 Jan 2015 22:12:57 -0800 (PST)
Message-ID: <54B608E7.9040702@aei.mpg.de>
Date: Wed, 14 Jan 2015 07:12:55 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de>
	<54B3CC6A.4080405@aei.mpg.de>	<20150112155206.GD25944@bfoster.bfoster>	<54B3F19D.6030307@aei.mpg.de>	<20150112163749.GE25944@bfoster.bfoster>	<54B40552.50106@aei.mpg.de>
	<20150113203332.GD29484@destitution>
In-Reply-To: <20150113203332.GD29484@destitution>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave

On 01/13/2015 09:33 PM, Dave Chinner wrote:
> 
> This pattern seems to match a filesystem that was running under
> inode32 for most of it's life, and is now using inode64 and hence
> spreading the subdirectories and hence new inodes over all AGs
> instead of just limiting them to AG 0....
> 

I fear you are right. The install logs from 2012 show, that fstab simply
contained:

UUID=dd407af5-1edc-41de-8c72-5fe1de31fb11 /srv xfs rw  0 2

And our change management is not that good to track back, when we
changed to inode64.

OK, I think I've gathered quite a lot of things we did wrong. I'll try
to summarize it in another email later today or tomorrow to invite a few
more comments before we go ahead redoing the FS. Also, it may serve as
summary for the list archive.

For now, I want to say a very, very big thank you for remarks and
suggestions!

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
