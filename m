Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6DHpY7x176845 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 12:51:35 -0500
Received: from mail-gg0-f181.google.com (mail-gg0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	X0T567rG09yM0hxJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Jul 2012 10:51:33 -0700 (PDT)
Received: by ggnv5 with SMTP id v5so4789488ggn.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 10:51:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
	<20120712223221.GF20167@google.com>
	<CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
	<20120712233645.GG20167@google.com>
	<CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
Date: Fri, 13 Jul 2012 10:51:32 -0700
Message-ID: <CA+8MBbLWxf4=95BHoVC4h-TM5S393Hhttx2BgdD-vUtHxpiYnA@mail.gmail.com>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
From: Tony Luck <tony.luck@gmail.com>
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
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, Fengguang Wu <fengguang.wu@intel.com>, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

On Thu, Jul 12, 2012 at 4:46 PM, Tony Luck <tony.luck@gmail.com> wrote:
> Still hasn't come back in three reboots.  I have to leave now, can continue
> tomorrow.

Tired of rebooting ... seems that it is very hard to hit this with
this patch :-(

-Tony

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
