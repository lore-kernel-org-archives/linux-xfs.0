Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 18:26:10 -0700 (PDT)
Received: from mail.dvmed.net (srv5.dvmed.net [207.36.208.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l481Q5fB030567
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 18:26:06 -0700
Message-ID: <463FD1A2.1020505@garzik.org>
Date: Mon, 07 May 2007 21:25:54 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
References: <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org> <20070507222103.GJ8181@schatzie.adilger.int> <463FB008.3080706@garzik.org> <20070508010736.GO8181@schatzie.adilger.int>
In-Reply-To: <20070508010736.GO8181@schatzie.adilger.int>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Andreas Dilger wrote:
> My comment was just that the extent doesn't have to be explicitly zero
> filled on the disk, by virtue of the fact that the uninitialized flag
> will cause reads to return zero.


Agreed, thanks for the clarification.

	Jeff
