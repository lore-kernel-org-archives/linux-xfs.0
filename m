Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n51HwgVC027097 for <xfs@oss.sgi.com>; Mon, 1 Jun 2009 12:58:42 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A88C88F80AC
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2009 10:58:56 -0700 (PDT)
Message-Id: <D7FB8214-6C2B-4D13-9B50-C53CB74885C2@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <a4423d670906011038qd809ebay22aebca5aaf271a4@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: 2.6.30-rc6: BUG at fs/xfs/support/debug.c:109!
Date: Mon, 1 Jun 2009 12:58:56 -0500
References: <a4423d670906010822l6e8e112dl3d6f7de9e2179850@mail.gmail.com>
	<B5660F1A-7940-4E4A-92E8-8C0F93C274BD@sgi.com>
	<a4423d670906011038qd809ebay22aebca5aaf271a4@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, xfs@oss.sgi.com


On Jun 1, 2009, at 12:38 PM, Alexander Beregalov wrote:

> It was Gentoo's `emerge --metadata`. It reads many small files  
> (ebuilds).
> I am sure it cannot be easily reproduced.

Right. Otherwise many more people would've reported it.

> It runs fine everyday. I do not have a testcase.
> I can try to run it forever in loop if you need.

Yes, that will be good.
The problem is that the traces are confusing. From one
side readdir stack makes sense based on your description
of the load, but OTOH the panic is from xfs_bmapi(), which
doesn't fit in that backtrace at all. It seems like
backtrace is from the concurrently running different thread.
Don't have good idea for this bug atm.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
