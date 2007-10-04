Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 08:04:07 -0700 (PDT)
Received: from mailout1.imos.net (mailout1.imos.net [212.87.132.33])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94F41sG009154
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 08:04:04 -0700
Received: from homer.imos.net (homer.imos.net [212.87.132.35])
	by mailout1.imos.net (8.14.1/8.14.1) with ESMTP id l94EZ2Ya030875
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 16:35:02 +0200
Received: from lstyd.imos.net (lstyd.imos.net [212.87.130.122])
	by homer.imos.net (8.14.1/8.14.1) with ESMTP id l94EZ1G1021671
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 16:35:01 +0200
Received: from [5.15.153.128] ([5.15.153.128])
	by lstyd.imos.net (8.14.0/8.13.7) with ESMTP id l94HNfUe014409
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 19:23:41 +0200
Message-ID: <4704FA19.2080101@theendofthetunnel.de>
Date: Thu, 04 Oct 2007 16:35:05 +0200
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
References: <20071004133302.GA5058@apartia.fr>
In-Reply-To: <20071004133302.GA5058@apartia.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On 04.10.2007 15:33, vindex+lists-xfs@apartia.org wrote:
> What do you think about it ?

Another thing, is there a special reason why you use DRBD 0.7.x branch? 
AFAIK it will still deadlock with kernel 2.6.22. You are not running 
.22, but if you upgrade you might have serious problems. You should 
really go with DRBD 8.0.6 if you can.


-- 
Regards,
Hannes Dorbath
