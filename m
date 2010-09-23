Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N8lLmY117093 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:47:22 -0500
Received: from pirx.askja.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF7BA1D9182E
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 01:48:15 -0700 (PDT)
Received: from pirx.askja.de (pirx.askja.de [83.137.103.148]) by cuda.sgi.com
	with ESMTP id MYbKrsFUxhgDC37x for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 01:48:15 -0700 (PDT)
Date: Thu, 23 Sep 2010 10:48:00 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: XFS internal error xfs_da_do_buf(2)
Message-ID: <20100923084800.GD23326@pirx.askja.de>
References: <20100922083226.GF2614@dastard>
	<20100922121123.GB23326@pirx.askja.de>
	<20100922232431.GH2614@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922232431.GH2614@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner schrieb:
> > With 'stat every file regularly' you mean check the md5sum?
> 
> If you just want to read the metadata, then just doing something
> like a 'ls -R <mntpt>' will read every directory block and inode and
> run the checks that trigger the errors you are seeing. running
> md5sum on every file will check the data as well, but will take a
> lot longer.

ok, 'ls -R ...' takes 40 min. to finish. I'll let it run once a week.
The backup incrementals do not read every file, so this might detect
corruption earlier.

Would it make any sense to run xfs_check periodicially on a mounted
fs?  xfs_check man page says:

'The filesystem should normally be unmounted or read-only during the
execution of xfs_check.  Otherwise, spurious problems are reported.'

I guess you would have mentioned it...

Ralf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
