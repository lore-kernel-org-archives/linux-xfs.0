Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2T0MIaJ193879
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 19:22:19 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1E2A1142E99
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:25:27 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.67]) by
	cuda.sgi.com with ESMTP id rDJFsvZqe2ysnOD2 for
	<linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:25:27 -0700 (PDT)
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com
	[172.24.198.77]) by smtp-out.google.com with ESMTP id p2T0PP8S031467
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:25:26 -0700
Received: from ywo32 (ywo32.prod.google.com [10.192.15.32])
	by wpaz13.hot.corp.google.com with ESMTP id p2T0PGZT016275
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:25:24 -0700
Received: by ywo32 with SMTP id 32so1779935ywo.35
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 17:25:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
	<BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
Date: Mon, 28 Mar 2011 17:25:24 -0700
Message-ID: <BANLkTikzpC9DdaoWaUTvO98jnjFdJOomwQ@mail.gmail.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
From: Michel Lespinasse <walken@google.com>
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
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>, Christos Zoulas <Christos.Zoulas@twosigma.com>, Trammell Hudson <Trammell.Hudson@twosigma.com>, Martin Bligh <Martin.Bligh@twosigma.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Degler <Stephen.Degler@twosigma.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On Mon, Mar 28, 2011 at 2:34 PM, Sean Noonan <Sean.Noonan@twosigma.com> wrote:
>> Could you test if you see the deadlock before
>> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?
>
> Built and tested 72ddc8f72270758951ccefb7d190f364d20215ab.
> Confirmed that the original bug does not present in this version.
> Confirmed that removing MAP_POPULATE does cause the deadlock to occur.

It seems that the test (without MAP_POPULATE) reveals that the root
cause is an xfs bug, which had been hidden up to now by MAP_POPULATE
preallocating disk blocks (but could always be triggered by the same
test without the MAP_POPULATE flag). I'm not sure how to go about
debugging the xfs deadlock; it would probably be best if an xfs person
could have a look ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
