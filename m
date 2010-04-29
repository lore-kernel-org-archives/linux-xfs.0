Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T81cvR052372 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 03:01:39 -0500
Received: from hermes.mejor.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D79EC2FD30E
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 01:03:43 -0700 (PDT)
Received: from hermes.mejor.pl (hermes.mejor.pl [193.238.12.139]) by
	cuda.sgi.com with ESMTP id CVgH03Y2wNjioTtp for
	<xfs@oss.sgi.com>; Thu, 29 Apr 2010 01:03:43 -0700 (PDT)
Received: from 127-goc-33.acn.waw.pl ([94.75.108.127] helo=[192.168.138.2])
	by hermes.mejor.pl with esmtpa (Exim 4.71)
	(envelope-from <marcin@mejor.pl>) id 1O7Oik-00064h-B2
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:03:42 +0200
Message-ID: <4BD93D59.2010506@mejor.pl>
Date: Thu, 29 Apr 2010 10:03:37 +0200
From: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>
MIME-Version: 1.0
Subject: Re: Enabling lazy counters damages filesystem
References: <4BD84771.4030804@mejor.pl>
	<20100428230447.GJ9783@dastard>	<20100429014312.GA2512@dastard>
	<4BD8E622.80100@sandeen.net> <20100429020549.GC2512@dastard>
In-Reply-To: <20100429020549.GC2512@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

W dniu 29.04.2010 04:05, Dave Chinner pisze:
> Yeah, you are right. I was thinking that xfs_db did the feature bit
> modifications, then repair just fixed up the accounting. but repair
> does both in this case. I should remember code that I wrote years
> ago, but for some reason it all seems to be a little bit hazy...
> 
> Let me go look at your repair patch again ;)

Hi,
Eric, Dave, thank you for quick replay and patch. Patch solves problem
for me:)
Regards!
Marcin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
