Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 14:52:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NLqHcn027335
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:52:18 -0700
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 658C1E8F51B
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:53:27 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202]) by cuda.sgi.com with ESMTP id 5HB7qpFH23dlHSNa for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:53:27 -0700 (PDT)
Message-ID: <4887A84D.90701@thebarn.com>
Date: Wed, 23 Jul 2008 16:53:17 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] kill bhv_vnode_t
References: <20080723214737.GA10655@lst.de>
In-Reply-To: <20080723214737.GA10655@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Dave complained today that the fate of bhv_vnode_t isn't entirely clear
> yet, so I've prepared these two patches to kill it in a minimally
> invasive way.  While it causes churn in a lot of areas it does not
> affect the generated code at all.
>
>   
I know a bunch of stuff has gone in that is not very portable, which is 
fine since
they can be dealt with individually since they are not that intrusive.

Changing bhv_vnode_t to struct inode throughout the code is a pretty big
change and would be a major pain to work around.


-Russell
