Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 565077CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 14:36:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1717A304090
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 12:36:01 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id FACOcj0yvCPKOnLB (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 12:35:59 -0700 (PDT)
Received: from tux.wizards.de (p4FF5801B.dip0.t-ipconnect.de [79.245.128.27])
	by mail02.iobjects.de (Postfix) with ESMTPSA id 469E6416014D
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 21:35:57 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id D188211C01CF
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 21:35:56 +0200 (CEST)
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage
References: <20160324122417.GB4068@bfoster.bfoster>
	<57332508.307@profihost.ag> <20160511133417.GA42410@bfoster.bfoster>
	<57333BA4.4040402@profihost.ag>
	<20160511155951.GF42410@bfoster.bfoster>
	<5738576B.4010208@profihost.ag> <20160515115017.GA6433@laptop.bfoster>
	<57386E84.3090606@profihost.ag>
	<20160516010602.GA24980@bfoster.bfoster>
	<57420A47.2000700@profihost.ag> <20160522213850.GE26977@dastard>
	<5751C4B8.2080301@profihost.ag>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5751DC1C.5010909@applied-asynchrony.com>
Date: Fri, 3 Jun 2016 21:35:56 +0200
MIME-Version: 1.0
In-Reply-To: <5751C4B8.2080301@profihost.ag>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 06/03/16 19:56, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> should i remove the complete if conditions incl. the return 0 or should
> id convert it to if without WARN_ONCE? like below?
> 
>         if (WARN_ON_ONCE(delalloc))
>                 return 0;
>         if (WARN_ON_ONCE(unwritten))
>                 return 0;
> 
> =>
> 
>   if (delalloc)
>     return 0;
>   if (unwritten)
>     return 0;

Good thing you ask, I forgot about the returns..

Until the bigger picture has been figured out with -mm I'd probably
keep the returns.

-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
