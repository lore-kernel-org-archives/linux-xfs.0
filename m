Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E50Xqa232529 for <xfs@oss.sgi.com>; Sat, 14 Jul 2012 00:00:33 -0500
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	PvN5OjugjUaNffFj (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Jul 2012 22:00:32 -0700 (PDT)
Received: by wibhm6 with SMTP id hm6so973974wib.14
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 22:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-6-git-send-email-tj@kernel.org>
	<20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
	<20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 22:00:10 -0700
Message-ID: <CA+55aFyozbYJh4vRLCCkk5j86XEasngvWkKmL4WpBjiCB5050g@mail.gmail.com>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
	for_each_worker_pool()
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
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, gustavo@padovan.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

On Fri, Jul 13, 2012 at 9:44 PM, Tejun Heo <tj@kernel.org> wrote:
>
> nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
> array part, it's just returning the address of N'th element of the
> array.  ARRAY + N == &ARRAY[N].

None of this matters one whit.

You did "&(x)[0]".

That's insane. It's crazy. It doesn't even matter what "x" is in
between, it's crazy regardless.

It's just a really confused way of saying "x" (*). Except it makes the
code look like an insane monkey on crack got a-hold of your keyboard
when you weren't looking.

And to make it worse, "x" itself was the result of doing "*&y". Which
was probably written by the insane monkey's older brother, Max, who
has been chewing Quaaludes for a few years, and as a result _his_
brain really isn't doing too well either. Even for a monkey. And now
you're letting *him* at your keyboard too?

So you had two separately (but similarly) insane ways of complicating
the code so that it was really obfuscated. When it really just
computed "y" to begin with, it just added all those "x=*&y" and
"&(x)[0]" games around it to make it look complicated.

            Linus

(*) Technically, "&(x)[0]" is actually a really confused way of saying
"(x+0)" while making sure that "x" was a valid pointer. It basically
guarantees that if "x" started out as an array, it has now been
demoted to a pointer - but since arrays will be demoted to pointers by
pretty much any subsequent operation except for "sizeof()" and a
couple of other special cases anyway, you can pretty much just say
that "&(x)[0]" is "(x+0)" is "x".

And "*&y" really is exactly the same as "y", except for again some
syntactic checking (ie it is basically an odd way to verify that "y"
is an lvalue, since you cannot do an address-of of a non-lvalue).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
