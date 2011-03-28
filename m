Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SL3L1Z185289
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:03:21 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9FB11D50720
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:06:31 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [216.239.44.51]) by
	cuda.sgi.com with ESMTP id KG1mvA6Ii18WNpxA for
	<linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:06:31 -0700 (PDT)
Received: from hpaq11.eem.corp.google.com (hpaq11.eem.corp.google.com
	[172.25.149.11]) by smtp-out.google.com with ESMTP id p2SL6R3A030507
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:06:28 -0700
Received: from qyk10 (qyk10.prod.google.com [10.241.83.138])
	by hpaq11.eem.corp.google.com with ESMTP id p2SL5l5g011505
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:06:26 -0700
Received: by qyk10 with SMTP id 10so3242204qyk.18
	for <linux-xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
	<AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
	<081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
Date: Mon, 28 Mar 2011 14:06:25 -0700
Message-ID: <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
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

On Mon, Mar 28, 2011 at 7:58 AM, Sean Noonan <Sean.Noonan@twosigma.com> wrote:
>> Regarding the deadlock: I am curious to see if it could be made to
>> happen before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272. Could you test
>> what happens if you remove the MAP_POPULATE flag from your mmap call,
>> and instead read all pages from userspace right after the mmap ? I
>> expect you would then be able to trigger the deadlock before
>> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272.
>
> I still see the deadlock without MAP_POPULATE

Could you test if you see the deadlock before
5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272 without MAP_POPULATE ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
