Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2RIhdg9118644 for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 13:43:39 -0500
Received: from bifrost.lang.hm (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0F2B1470ED9
	for <xfs@oss.sgi.com>; Sat, 27 Mar 2010 11:45:21 -0700 (PDT)
Received: from bifrost.lang.hm (mail.lang.hm [64.81.33.126]) by cuda.sgi.com
	with ESMTP id BKBk0uzOfzbdMMic for <xfs@oss.sgi.com>;
	Sat, 27 Mar 2010 11:45:21 -0700 (PDT)
Date: Sat, 27 Mar 2010 11:45:19 -0700 (PDT)
From: david@lang.hm
Subject: Re: 128TB filesystem limit?
In-Reply-To: <20100327100618.71e24a0a@galadriel.home>
Message-ID: <alpine.DEB.2.00.1003271144110.27472@asgard.lang.hm>
References: <alpine.DEB.2.00.1003251609160.12435@asgard.lang.hm>
	<20100327100618.71e24a0a@galadriel.home>
MIME-Version: 1.0
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Sat, 27 Mar 2010, Emmanuel Florac wrote:

> Le Thu, 25 Mar 2010 16:15:42 -0700 (PDT) vous ?criviez:
>
>> is this just rounding error combined with the 1000=1k vs 1024=1k
>> marketing stuff, or is there some limit I am bumping into here.
>
> This isn't an xfs limit, I've set up several hundred big xfs FS for
> more than 5 years (13 to 76 TB) and never saw that. It must be a bug in
> df or elsewhere. What distribution is this? and architecture?

debian 5 on amd64.

at this point I'm fairly sure that it's just rounding error combined with 
the difference between 10^9 and 2^30 definitions of TB

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
