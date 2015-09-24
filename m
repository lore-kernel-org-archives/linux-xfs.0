Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38B897F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 03:22:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 187488F804B
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 01:22:05 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls2-lmb.cpub.univ-nantes.fr
	[193.52.103.111]) by cuda.sgi.com with ESMTP id
	pJGDEl2StYcIB61m for <xfs@oss.sgi.com>;
	Thu, 24 Sep 2015 01:21:57 -0700 (PDT)
Subject: Re: xfstests, bad generic tests 009 and 308
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com> <20150921225244.GD19114@dastard>
	<56028249.7040103@univ-nantes.fr> <20150923220444.GP19114@dastard>
From: Yann Dupont - Veille Techno <veilletechno-irts@univ-nantes.fr>
Message-ID: <5603B240.4030609@univ-nantes.fr>
Date: Thu, 24 Sep 2015 10:20:16 +0200
MIME-Version: 1.0
In-Reply-To: <20150923220444.GP19114@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Le 24/09/2015 00:04, Dave Chinner a =E9crit :
> On Wed, Sep 23, 2015 at 12:43:21PM +0200, Yann Dupont - Veille Techno wro=
te:
>> Le 22/09/2015 00:52, Dave Chinner a =E9crit :
>>> As it is, I highly recommend that you try a current 4.3 kernel, as
>>> there are several code fixes in the XFS kernel code that work
>>> around compiler issues we know about. AFAIA, the do_div() asm bug
>>> that trips recent gcc optimisations isn't in the upstream kernel
>>> yet, but that can be worked around by setting
>>> CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy in your build.
>> Hi dave,
>>
>> I can confirm that CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy is (was ?) the only
>> way for me to have reliable XFS kernel code on different arm
>> platforms (Marvell kirkwood, Allwinner A20, Amlogic S805), no matter
>> what recent gcc version I've been using.
>>
>> I must admit I was cross-compiling from X86-64 too, but I think (not
>> sure) that it was also the case with native gcc.
>>
>> I must also admit that I didn't tried since some months, because
>> CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy was the silver bullet for arm xfs
>> kernel crashes. This crash was difficult to understand because it
>> occurs quite randomly (I.e it can take several hours to trigger)
>>
>> If there's a patch floating around for gcc (or kernel), I'm
>> interested to test.
> See this subthread from august:
>
> http://oss.sgi.com/archives/xfs/2015-08/msg00234.html

Oh, missed this thread.

Thanks a lot for the pointer, will try this patch !
Cheers,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
