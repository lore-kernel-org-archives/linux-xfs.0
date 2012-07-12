Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CNkEX1093001 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 18:46:14 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 2Cn3Q3N8ijv2Jwf7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 16:46:13 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so5578884pbb.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 16:46:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120712233645.GG20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
	<20120712223221.GF20167@google.com>
	<CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
	<20120712233645.GG20167@google.com>
Date: Thu, 12 Jul 2012 16:46:12 -0700
Message-ID: <CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
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

On Thu, Jul 12, 2012 at 4:36 PM, Tejun Heo <tj@kernel.org> wrote:
> The debug patch didn't do anything for the bug itself.  I suppose it's
> timing dependent and doesn't always happen (it never reproduces here
> for some reason).  Can you please repeat several times and see whether
> the warning can be triggered?

Still hasn't come back in three reboots.  I have to leave now, can continue
tomorrow.

-Tony

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
