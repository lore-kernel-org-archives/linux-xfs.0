Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6CNapgf091803 for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 18:36:51 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 59jDVn03huTVUCRK
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Jul 2012 16:36:50 -0700 (PDT)
Received: by yhp26 with SMTP id 26so3794093yhp.26
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2012 16:36:50 -0700 (PDT)
Date: Thu, 12 Jul 2012 16:36:45 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate
	worker_pool
Message-ID: <20120712233645.GG20167@google.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
	<20120712223221.GF20167@google.com>
	<CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
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
To: Tony Luck <tony.luck@gmail.com>
Cc: axboe@kernel.dk, xfs@oss.sgi.com, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, torvalds@linux-foundation.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, gustavo@padovan.org, Fengguang Wu <fengguang.wu@intel.com>, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, Tony.

On Thu, Jul 12, 2012 at 04:24:47PM -0700, Tony Luck wrote:
> On Thu, Jul 12, 2012 at 3:32 PM, Tejun Heo <tj@kernel.org> wrote:
> > Can you please try the following debug patch instead?  Yours is
> > different from Fengguang's.
> 
> New dmesg from mext-20120712 + this new patch (instead of previous one)
> 
> [Note - I see some XXX traces, but no WARN_ON stack dump this time]

The debug patch didn't do anything for the bug itself.  I suppose it's
timing dependent and doesn't always happen (it never reproduces here
for some reason).  Can you please repeat several times and see whether
the warning can be triggered?

Thank you very much!

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
