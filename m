Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEF1C7F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 09:20:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B79A2304051
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 07:20:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yIZeVjQ6jFhQ3IhA for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 07:20:24 -0700 (PDT)
Message-ID: <5370D8AA.2010003@sandeen.net>
Date: Mon, 12 May 2014 09:20:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs spanning over ssd and hdd
References: <5370C592.6080402@web.de>
In-Reply-To: <5370C592.6080402@web.de>
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
To: Matthias Neuer <mneuer@web.de>, xfs@oss.sgi.com

On 5/12/14, 7:58 AM, Matthias Neuer wrote:
> Hi.
> 
> I have a slow and big hdd and a fast but small ssd and want to test the following setup but don't know if it's possible.
> 
> Use LVM to concatenate the ssd and the hdd linearly. Create a xfs filesystem on this device such that the sdd is filled first, i.e. data is written to the ssd as long as there is free space, otherwise the data is written to the hdd.
> 
> I have applications which may benefit from this setup but I am not sure so I need to do some benchmarks.

XFS doesn't fill from the front, so you can't configure things to fill the HDD first.

Files in new directories rotor around the allocation groups on the filesystem, so all regions of the fs are filled more or less evenly.

-Eric

> Thanks for your help
> Matthias
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
