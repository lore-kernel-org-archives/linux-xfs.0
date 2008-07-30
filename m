Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Jul 2008 00:11:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6U7BAXT014757
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:11:10 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66A95ED4DD8
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:12:22 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id nCOofvJNYLjDayZH for <xfs@oss.sgi.com>; Wed, 30 Jul 2008 00:12:22 -0700 (PDT)
Date: Wed, 30 Jul 2008 17:12:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/21] implement =?utf-8?Q?gene?=
	=?utf-8?Q?ric_xfs=5Fbtree=5Fin=D1=95ert=2Finsrec?=
Message-ID: <20080730071219.GT13395@disturbed>
References: <20080729193148.GT19104@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729193148.GT19104@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Tue, Jul 29, 2008 at 09:31:48PM +0200, Christoph Hellwig wrote:
> Make the btree insert code generic.  Based on a patch from David Chinner
> with lots of changes to follow the original btree implementations more
> closely.  While this loses some of the generic helper routines for
> inserting/moving/removing records it also solves some of the one off
> bugs in the original code and makes it easier to verify.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine (though my eyes are starting to glaze over).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
