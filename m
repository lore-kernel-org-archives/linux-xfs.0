Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 48C657FAF
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 21:39:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38F768F804B
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 19:39:50 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id IYd6RYAyteUdBeZy
	for <xfs@oss.sgi.com>; Mon, 09 Dec 2013 19:39:49 -0800 (PST)
Message-ID: <52A68D08.8020505@hardwarefreak.com>
Date: Mon, 09 Dec 2013 21:39:52 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Sudden File System Corruption
References: <CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>	<52A191BA.20800@hardwarefreak.com>	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>	<52A302A9.9050509@hardwarefreak.com>	<CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>	<52A401FF.9050506@hardwarefreak.com>	<20131208160339.5c45ab91@galadriel.home>	<52A5159F.2060309@hardwarefreak.com>	<20131209014002.GP31386@dastard>	<52A61F3A.7040504@hardwarefreak.com>	<20131209222131.GX10988@dastard>
	<20131209233028.27ee7154@galadriel.home>
In-Reply-To: <20131209233028.27ee7154@galadriel.home>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>, Dave Chinner <david@fromorbit.com>
Cc: Mike Dacre <mike.dacre@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/9/2013 4:30 PM, Emmanuel Florac wrote:
> Le Tue, 10 Dec 2013 09:21:31 +1100 vous =E9criviez:
> Dave Chinner wrote:
>>
>> So, while the tech might be great, the benchmarks sucked at
>> demonstrating that.

It's pretty difficult to find comprehensive benchmark results,
especially for niche products such as CacheCade.

> And now that we have enhance-io, bcache and friends, I'm actually more
> confident of using these than some sort of hidden pseudo-hardware magic.

Enhance-IO is $295 per Linux server per year.  Last I saw, Cleancache
isn't fully supported by XFS yet in a stable vanilla release.  AFAIK
bcache isn't fully baked yet.  Coupled with the fact that Mike seems to
be limited to the CentOS ecosystem, I figured CacheCade was his best
option at this time.  It's been around a couple of years, works,
verified decent performance, and no additional kernel software is
required.  And it's relatively easy to configure.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
