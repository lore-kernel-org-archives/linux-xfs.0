Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Sep 2006 07:56:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8PEuaaG029014
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 07:56:37 -0700
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2453B45CA3F
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 07:55:56 -0700 (PDT)
Received: from agami.com ([192.168.168.146])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id k8PEttQ2009116
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 07:55:55 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id k8PEto3a008522
	for <xfs@oss.sgi.com>; Mon, 25 Sep 2006 07:55:50 -0700
Message-ID: <4517ED41.8090305@agami.com>
Date: Mon, 25 Sep 2006 20:22:49 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: Data type overflow in xfs_trans_unreserve_and_mod_sb
References: <55EF1E5D5804A542A6CA37E446DDC206655888@mapibe17.exchange.xchg> <45179573.3020007@agami.com> <4517E88E.4020809@sandeen.net>
In-Reply-To: <4517E88E.4020809@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, Timothy Shimmin <tes@sgi.com>



Eric Sandeen wrote:
> Hm, yep, just ASSERT(error == 0);
> 
> I suppose this is the trickiness of canceling a transaction at some 
> points...

Yes, you are right. At the point where it is being applied, all the 
things can't be reverted back as XFS does not store the "before-image". 
However, typically in most of such cases, XFS goes ahead with shutting 
down the filesystem assuming these to be catastrophic or incorrigible 
errors requiring manual intervention.

> First thoughts, "long" won't help on 32 bit machines, perhaps this 
> should be an explicitly-sized 64-bit type

> -Eric
> 
> p.s. good to see agami's recently active participation on the list!
> 
