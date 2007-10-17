Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 09:30:47 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9HGUfWc000945
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 09:30:43 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 2A038300E870
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 18:30:44 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wTL-qjneF5ad for <linux-xfs@oss.sgi.com>;
	Wed, 17 Oct 2007 18:30:44 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 0AD7F300EB25
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 18:30:44 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 723D7F0AF2F09
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 18:30:43 +0200 (CEST)
Date: Wed, 17 Oct 2007 18:30:43 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: Re: can't remove dir
Message-ID: <20071017163043.GA13676@apartia.fr>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr> <Pine.LNX.4.64.0710171218510.3750@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710171218510.3750@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Wed, Oct 17, 2007 at 12:18:58PM -0400, Justin Piszcz wrote:
>>
>> Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't
>> remove that file:
>>
>> sylla:/# rm /lost+found/3912672557
>> rm: cannot remove `/lost+found/3912672557': Operation not permitted
>>
>> sylla:/# ls -li /lost+found/3912672557
>> 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 
>> /lost+found/3912672557 -> unix.7.gz
>>
>
> lsattr -l /lost+found/3912672557
>
> Shows?

sylla:~# lsattr -l /lost+found/3912672557
lsattr: No such file or directory While reading flags on /lost+found/3912672557

The file is a dangling link.
