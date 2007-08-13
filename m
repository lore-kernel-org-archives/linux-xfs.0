Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Aug 2007 10:25:39 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7DHPWbm031654
	for <linux-xfs@oss.sgi.com>; Mon, 13 Aug 2007 10:25:35 -0700
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_fsr and null byte areas in files
Date: Mon, 13 Aug 2007 19:25:35 +0200
References: <200707092313.48876.Martin@lichtvoll.de> <200707262309.24012.Martin@lichtvoll.de> <200708122229.40400.Martin@lichtvoll.de> (sfid-20070812_231250_500144_C3F8EC69)
In-Reply-To: <200708122229.40400.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131925.35824.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: ck@vds.kolivas.org

Am Sonntag 12 August 2007 schrieb Martin Steigerwald:

> > Hi!
> >
> > I ran test 42 and it completes successfully.
>
> Hello,
>
> I now read a post from someone who faced null byte areas in files after
> xfs_fsr as well[1]. And he writes that this problem is related to the
> ck patchset:
>
> http://bhhdoa.org.au/pipermail/ck/2007-August/008433.html
>
> It may well be that it is related to the ck patchset in my case as
> well. I did not know the exact kernel version anymore when I was using
> xfs_fsr, since it took me 2 weeks to actually find about this
> corruption. Well and when I ran xfsqa test I had a slighly newer kernel
> was using the CFS scheduler instead of the ck patchset. Actually I
> thought the other was using the CFS scheduler as well  I didn't think
> of it as having any relevance so I didn't look into that direction.
>
> But now it seems that the problem actually is related ck patchset and
> that I was using a kernel with ck patchset as well. I try to find the
> time to run xfsqa test 42 for my latest ck patchset kernel to know for
> sure.

I ran test 42 on my last kernel with ck patchset - 
2.6.21.3-tp42-ck2-sws2-2.2.10 -   about 20 times, but it did not show any 
problem. Maybe I have to run it about a 1000 times, since about 0,1-0.5% 
of my files were affected when it failed and as it seems to me the tests 
only generates one fragmented file. Could it generate and check more 
fragmented files in one ago without to much work?

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
