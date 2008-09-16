Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 22:10:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G5AV2f003774
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:10:31 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B4DF1275A64
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:12:02 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id kGWXDF7ScWNwjYbC for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 22:12:02 -0700 (PDT)
Date: Tue, 16 Sep 2008 15:11:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sanitize xlog_in_core_t definition
Message-ID: <20080916051118.GT5811@disturbed>
References: <20080915002348.GA11469@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915002348.GA11469@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 02:23:48AM +0200, Christoph Hellwig wrote:
> Move all fields from xlog_iclog_fields_t into xlog_in_core_t instead of having
> them in a substructure and the using #defines to make it look like they were
> directly in xlog_in_core_t.  Also document that xlog_in_core_2_t is grossly
> misnamed, and make all references to it typesafe.

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
