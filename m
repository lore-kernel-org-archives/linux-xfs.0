Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 06:59:15 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FDx9Wt001341
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 06:59:11 -0700
Message-ID: <46729B20.309@dgreaves.com>
Date: Fri, 15 Jun 2007 14:58:56 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: [PATCH] block: always requeue !fs requests at the front
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de> <20070615094246.GN29122@htj.dyndns.org>
In-Reply-To: <20070615094246.GN29122@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linus Torvalds <torvalds@linux-foundation.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>, jens.axboe@oracle.com

> David, please test this.  Jens, does it look okay?

Phew!

Works for me.

I applied it to 2.6.22-rc4 (along with 
sata_promise_use_TF_interface_for_polling_NODATA_commands.patch) hibernate and 
resume worked.

Thanks for digging it out Tejun (and everyone else!) :)

David
