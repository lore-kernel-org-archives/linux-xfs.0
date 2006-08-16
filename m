Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 18:28:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G1RODW003384
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 18:27:35 -0700
Date: Wed, 16 Aug 2006 11:26:30 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: 2.6.18-rc3-git3 - XFS - BUG: unable to handle kernel NULL pointer dereference at virtual address 00000078
Message-ID: <20060816112630.C2756824@wobbly.melbourne.sgi.com>
References: <9a8748490608100431m244207b1v9c9c5087233fcf3a@mail.gmail.com> <20060811083546.B2596458@wobbly.melbourne.sgi.com> <9a8748490608101544n29f863e7o7584ac64f1d4c210@mail.gmail.com> <9a8748490608101552w12822fa6m415a5fb5537c744d@mail.gmail.com> <9a8748490608110133v5f973cf6w1af340f59bb229ec@mail.gmail.com> <9a8748490608110325k25c340e2yac925eb226d1fe4f@mail.gmail.com> <20060814120032.E2698880@wobbly.melbourne.sgi.com> <9a8748490608140049t492742cx7f826a9f40835d71@mail.gmail.com> <20060815190343.A2743401@wobbly.melbourne.sgi.com> <9a8748490608150442q4ad7a835r53400e9880da3175@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490608150442q4ad7a835r53400e9880da3175@mail.gmail.com>; from jesper.juhl@gmail.com on Tue, Aug 15, 2006 at 01:42:27PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 15, 2006 at 01:42:27PM +0200, Jesper Juhl wrote:
> On 15/08/06, Nathan Scott <nathans@sgi.com> wrote:
> > If you can get the source
> > and target names in the rename that'll help alot too... I can
> > explain how to use KDB to get that, but maybe you have another
> > debugger handy already?
> >
> An explanation of how exactely to do that would be greatly appreciated.

- patch in KDB
- echo 127 > /proc/sys/fs/xfs/panic_mask
[ filesystem shutdown now == panic ]
- kdb> bt
[ pick out parameters to rename from the backtrace ]
- kdb> md 0xXXX
[ gives a memory dump of the pointers to pathnames ]

cheers.

-- 
Nathan
