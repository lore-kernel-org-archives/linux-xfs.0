Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 01:41:25 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8E8fL4p028459
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 01:41:22 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 64A9F300E022
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 10:41:23 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5aV6pzcuTg2q for <linux-xfs@oss.sgi.com>;
	Fri, 14 Sep 2007 10:41:23 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 3CDB1300E343
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 10:41:23 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 7C6A4F09FE51F
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 10:41:22 +0200 (CEST)
Date: Fri, 14 Sep 2007 10:41:25 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: [UNSURE] can't remove dir
Message-ID: <20070914084125.GA31074@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <Pine.LNX.4.64.0709140438130.752@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709140438130.752@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Fri, Sep 14, 2007 at 04:38:22AM -0400, Justin Piszcz wrote:
>
> On Fri, 14 Sep 2007, Louis-David Mitterrand wrote:
>>
>> While cleaning up /lost+found a directory resisted removal:
>>
>> 	sylla:/lost+found# rm 1879629858 -rf
>> 	rm: cannot remove directory `1879629858': Directory not empty
>>
>> The directory _is_ empty and "-rf" should remove it anyway, so this
>> looks like a fs error.
>>
>> This is on debian unstable with 2.6.23-rc6.
>
> what does "ls -al 1879629858" say?
>

I knew someone would ask, and this is slightly insulting ;-)

sylla:/lost+found# ls -al 1879629858
total 24
drwxr-xr-x 2 root root   8192 2007-09-14 09:25 ./
drwxr-xr-x 3 root root 299008 2007-09-14 10:05 ../
