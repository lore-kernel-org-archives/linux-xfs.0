Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2U1qDkE000999
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 20:52:13 -0500
Received: from mx5.twosigma.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 112DF38B1E5
	for <linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 18:55:23 -0700 (PDT)
Received: from mx5.twosigma.com (mx5.twosigma.com [208.77.212.35]) by
	cuda.sgi.com with SMTP id 44YofG5gGR5GbWwS for
	<linux-xfs@oss.sgi.com>; Tue, 29 Mar 2011 18:55:23 -0700 (PDT)
From: Sean Noonan <Sean.Noonan@twosigma.com>
Date: Tue, 29 Mar 2011 21:52:59 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B5365@MSXAOA6.twosigma.com>
References: <20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
	<20110329192434.GA10536@infradead.org>
	<081DDE43F61F3D43929A181B477DCA95639B535D@MSXAOA6.twosigma.com>
	<20110330000942.GI3008@dastard>
	<081DDE43F61F3D43929A181B477DCA95639B5364@MSXAOA6.twosigma.com>
	<20110330014400.GK3008@dastard>
In-Reply-To: <20110330014400.GK3008@dastard>
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: Trammell Hudson <Trammell.Hudson@twosigma.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-mm@kvack.org'" <linux-mm@kvack.org>, "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>, 'Michel Lespinasse' <walken@google.com>

> Is this repeatable or is it just a one-off result?

It was repeated three times before I sent the email, but I can't reproduce it again now.  Call it a fluke.

Sean

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
