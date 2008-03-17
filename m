Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 16:35:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2HNZ6Xc021656
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 16:35:10 -0700
Message-ID: <47DF0044.6080704@sgi.com>
Date: Tue, 18 Mar 2008 10:35:32 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net> <47DEB930.7020108@sandeen.net>
In-Reply-To: <47DEB930.7020108@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Josef 'Jeff' Sipek wrote:
> 
>> Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
>> structure member alignment :)
> 
> Very.  ;)
> 
> Tossing packed at all the ondisk stuctures bloats things badly on ia64.
> 
> cvs/linux-2.6-xfs> wc -l before.dis
> 166688 before.dis
> cvs/linux-2.6-xfs> wc -l after.dis
> 182294 after.dis
> 
> That's +15606 lines.
> 
> http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/
> 
Interesting.
So the problem there is that gcc is doing the wrong thing
on some arches (the example being ia64, sparc64).

--Tim
