Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E1hvEh065820 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 20:44:07 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C9ED3CAE37
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:44:37 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id OnwMYs8QG2X8xlc1 for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:44:37 -0700 (PDT)
Received: from [10.1.1.11] (OSH-NAT-213-122.onshore.net [66.146.213.122])
	(Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id DCACE204116
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 01:44:36 +0000 (UTC)
Message-ID: <4A84C183.2020609@jquigley.com>
Date: Thu, 13 Aug 2009 20:44:35 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: Re: XFS corruption with failover
References: <1405534054.1935051250211481446.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<4A84BF5A.8030502@sandeen.net>
In-Reply-To: <4A84BF5A.8030502@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Development <xfs@oss.sgi.com>

Eric Sandeen wrote:
>> Should barriers be enabled in XFS then?
> 
> Could try it but I bet the iscsi target doesn't claim to support them...

The target implementation, being new, is fairly naive and does not support this (or have any caching facilities, for that matter) at this time.

- John Quigley

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
