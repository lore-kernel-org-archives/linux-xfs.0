Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6AF3B29E03
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 19:58:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B14D304053
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 17:58:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 3FNR39JNlJO4b35O
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 17:58:05 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id EF6046C02E
	for <xfs@oss.sgi.com>; Sun, 21 Apr 2013 19:58:04 -0500 (CDT)
Message-ID: <51748B18.6040309@hardwarefreak.com>
Date: Sun, 21 Apr 2013 19:58:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: noop or deadline on an SSD?
References: <CAEDdjHcoZc2eS=hgb7K7BVf=2z28uh3CMuEU8+qFPp5UFvj-iQ@mail.gmail.com>
In-Reply-To: <CAEDdjHcoZc2eS=hgb7K7BVf=2z28uh3CMuEU8+qFPp5UFvj-iQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 4/21/2013 5:38 PM, Pedro Ribeiro wrote:

> Ok, I also read that with an SSD I should be using noop or deadline. And
> which one of these would perform better with XFS with an SSD? And while I'm
> at it, which one would be best for a  mechanical drive?

$ echo [noop|deadline] > /sys/block/sdX/queue/scheduler

Given the ease with which one can switch between the two, it's far
better to test each yourself with your hardware and workloads, than to
rely on any generic advice.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
