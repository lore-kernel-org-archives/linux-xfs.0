Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E1A1C7F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 04:49:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CEBE68F8040
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 02:49:23 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id N7c3WwZzxpPu9DWf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 02:49:22 -0700 (PDT)
Message-ID: <540D7BA0.6090107@profihost.ag>
Date: Mon, 08 Sep 2014 11:49:20 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag> <20140905230528.GO20473@dastard>
	<540AB933.4030707@profihost.ag>
	<20140906150412.GB23506@bfoster.bfoster>
	<20140906225654.GB9955@dastard> <540D6A6C.9090801@profihost.ag>
	<20140908094659.GC30012@dastard>
In-Reply-To: <20140908094659.GC30012@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Am 08.09.2014 um 11:46 schrieb Dave Chinner:
> On Mon, Sep 08, 2014 at 10:35:56AM +0200, Stefan Priebe - Profihost AG wrote:
>> Thanks,
>>
>> upgraded to 3.16.2 and xfsprogs 3.2.1. Let's see how it behaves with finobt.
> 
> You need to mkfs the filesystem to use finobt - it's not something
> that an upgrade will just switch on. i.e.
> 
> # mkfs.xfs -m crc=1,finobt=1 <dev>

Sure i also did a reformat using "-m crc=1,finobt=1".

Stefan

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
