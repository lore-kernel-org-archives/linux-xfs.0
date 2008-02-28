Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 06:40:21 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1SEe3Z1011942
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 06:40:05 -0800
Message-ID: <47C6C7DB.8070706@sandeen.net>
Date: Thu, 28 Feb 2008 08:40:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after	2.6.25-rc1
 (bisected, powerpc related?)
References: <20080225112310.GA5516@soziologie.ch>	 <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de>	 <200802260113.57875.rjw@sisk.pl>  <20080226114419.GA5353@soziologie.ch> <1204049492.13162.265.camel@johannes.berg>
In-Reply-To: <1204049492.13162.265.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Gaudenz Steinlin <gaudenz@soziologie.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>, Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

Johannes Berg wrote:
>> I debuged this a bit further by testing the 4 changed functions
>> individually. The problem only occurs with the new version of
>> xfs_lowbit64. 
...

> You really need to keep xfs_lowbit64 defined as it was before, or, maybe
> even better, define ffs64 in parallel to fls64.

Yep, I agree.

-Eric
