Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1774A7F37
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 05:45:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6254AC005
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 03:45:08 -0700 (PDT)
Received: from smtp-tls.univ-nantes.fr (smtptls2-lmb.cpub.univ-nantes.fr
	[193.52.103.111]) by cuda.sgi.com with ESMTP id
	MIfJzReAoeBG0f6S for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 03:45:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 1AF9240171C
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 12:45:06 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls2-lmb.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id W-LdVlmiaFyg for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 12:45:06 +0200 (CEST)
Received: from [172.20.13.174] (unknown [172.20.13.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id F0057401715
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 12:45:05 +0200 (CEST)
Subject: Re: xfstests, bad generic tests 009 and 308
References: <55FC3E0E.9060506@nomovok.com> <20150918224412.GE26895@dastard>
	<55FFE665.7040004@nomovok.com> <20150921225244.GD19114@dastard>
From: Yann Dupont - Veille Techno <veilletechno-irts@univ-nantes.fr>
Message-ID: <56028249.7040103@univ-nantes.fr>
Date: Wed, 23 Sep 2015 12:43:21 +0200
MIME-Version: 1.0
In-Reply-To: <20150921225244.GD19114@dastard>
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
To: xfs@oss.sgi.com

Le 22/09/2015 00:52, Dave Chinner a =E9crit :
> As it is, I highly recommend that you try a current 4.3 kernel, as =

> there are several code fixes in the XFS kernel code that work around =

> compiler issues we know about. AFAIA, the do_div() asm bug that trips =

> recent gcc optimisations isn't in the upstream kernel yet, but that =

> can be worked around by setting CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy in your =

> build. =


Hi dave,

I can confirm that CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy is (was ?) the only way =

for me to have reliable XFS kernel code on different arm platforms =

(Marvell kirkwood, Allwinner A20, Amlogic S805), no matter what recent =

gcc version I've been using.

I must admit I was cross-compiling from X86-64 too, but I think (not =

sure) that it was also the case with native gcc.

I must also admit that I didn't tried since some months, because =

CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy was the silver bullet for arm xfs kernel =

crashes. This crash was difficult to understand because it occurs quite =

randomly (I.e it can take several hours to trigger)

If there's a patch floating around for gcc (or kernel), I'm interested =

to test.

Cheers,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
