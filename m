Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Sep 2007 01:33:26 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8E8XL4p026589
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 01:33:22 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 4FFC53131B0E
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 10:09:47 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5JVIJaqNc0NG for <linux-xfs@oss.sgi.com>;
	Fri, 14 Sep 2007 10:09:47 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 26B903131B0D
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 10:09:47 +0200 (CEST)
Received: from trajan.apartia.fr (trajan.apartia.fr [10.0.3.121])
	by zenon.apartia.fr (Postfix) with ESMTP id 3EECFF09FE51F
	for <linux-xfs@oss.sgi.com>; Fri, 14 Sep 2007 10:09:23 +0200 (CEST)
Date: Fri, 14 Sep 2007 10:09:26 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: can't remove dir
Message-ID: <20070914080926.GA30150@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello,

While cleaning up /lost+found a directory resisted removal:

	sylla:/lost+found# rm 1879629858 -rf
	rm: cannot remove directory `1879629858': Directory not empty

The directory _is_ empty and "-rf" should remove it anyway, so this 
looks like a fs error.

This is on debian unstable with 2.6.23-rc6.
