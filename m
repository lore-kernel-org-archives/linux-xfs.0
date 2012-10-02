Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92NXYqV106764 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 18:33:34 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id SuyDBP41l7hcDedq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 16:34:58 -0700 (PDT)
Message-ID: <506B7A1C.3000001@tlinx.org>
Date: Tue, 02 Oct 2012 16:34:52 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
	(+attachment)
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
	<506B5DE1.4020000@tlinx.org> <20121002215253.GT23520@dastard>
	<506B7018.7040000@tlinx.org> <20121002231359.GV23520@dastard>
In-Reply-To: <20121002231359.GV23520@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Tue, Oct 02, 2012 at 03:52:08PM -0700, Linda Walsh wrote:
>> Dave Chinner wrote:
>>> Patches welcome.
>>>
>>> Cheers,
>>>
>>> Dave.
>> ---
>> Gee, that's a hard one... (build and tested that it was included)...
> 
> Actually, it's a lot more than just changing the default. If the
> build system doesn't have libreadline/libedit/libtermcap installed,
> the build will fail.
> 
> You need to add detection of the libraries' presence on the build
> system, and then the "--enable-*" options can go away entirely.
> See, for example, the way libuuid is detected in
> m4/package_uuiddev.m4...
----
Hmmm...Oh...I thought configure did that detection.. Now I see that
was never put it and it was basically a 'manual' on/off switch
that was available.

Urk.

On top of matters, my local distrib had readline installed in a way that
it wouldn't link had libreadline.so.x.y, libreadline.so.x => libreadline.so.x.y in
/usr/lib64 but libreadline.so=>libreadline.so.x was in 
/usr/lib64/readline/libreadline.so.

???
Will have to figure out why that is and where it is supposed to be (I just
moved the soft-link from /usr/lib64/readline/libreadline.so to one dir up -- same
with libeditline...

> 
> Also, libedit is only supposed to be used as a fallback option if
> libreadline is not available.
---
Oh... thought readline did the history part and edit did the edit part...
Oi vey...

Well.. hrumph...

Will have to look this over when i get some more time.
Have a system disk upgrade to do first...

Sigh.  That I actually thought something might be simple... what an idiot!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
