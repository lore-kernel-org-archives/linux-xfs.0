Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2MDokxr022982
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 08:50:51 -0500
Received: from mx3.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0669E369742
	for <linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 06:53:35 -0700 (PDT)
Received: from mx3.twosigma.com (mx3.twosigma.com [208.77.213.34]) by
	cuda.sgi.com with SMTP id GzhtUALBKTmVyyk7 for
	<linux-xfs@oss.sgi.com>; Tue, 22 Mar 2011 06:53:35 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Tue, 22 Mar 2011 09:53:32 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B5308@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52E8@MSXAOA6.twosigma.com>
	<20110322100017.GA3532@infradead.org>
In-Reply-To: <20110322100017.GA3532@infradead.org>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, Martin Bligh <Martin.Bligh@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Stephen Degler <Stephen.Degler@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>

No, reverting this commit did not fix the issue.
We happened to have 2.6.36.1 and 2.6.37.2 available and tested against both of those.  I was not able to reproduce the bug with either version.

Sean

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, March 22, 2011 06:00
To: Sean Noonan
Cc: 'linux-xfs@oss.sgi.com'; Martin Bligh; Trammell Hudson
Subject: Re: XFS memory allocation deadlock in 2.6.38

> We started testing with 2.6.38-rc7 and have seen this bug through to the .0 release.  This does not appear to be present in 2.6.33, but we have not done testing in between.  We have tested with ext4 and do not encounter this bug.

Does reverting commit aea1b9532143218f8599ecedbbd6bfbf812385e1 fix the
issue for you?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
