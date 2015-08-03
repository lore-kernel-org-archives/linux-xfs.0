Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ABFDC7F56
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 15:23:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86CB2304053
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 13:23:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BnVWMQTLZSkARmRF for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 13:23:05 -0700 (PDT)
Received: from Liberator.local (unknown [64.146.202.138])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 49E6561C2D89
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 15:23:04 -0500 (CDT)
Message-ID: <55BFCDA7.1060904@sandeen.net>
Date: Mon, 03 Aug 2015 13:23:03 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Question about ftype
References: <20150803200958.GA14819@teal.hq.k1024.org>
In-Reply-To: <20150803200958.GA14819@teal.hq.k1024.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 8/3/15 1:09 PM, Iustin Pop wrote:
> Hi all,
> 
> I recently saw that a newly created filesystem has ftype=1. Reading the
> man pages of mkfs.xfs and xfs_admin/xfs_db and not finding anything
> about changing ftype (xfsprogs 3.2.4) leads me to believe that this
> feature can only be set at mkfs time, but could someone confirm if it is
> indeed so?

That is correct - it is an on-disk format change, and can only be set
at mkfs time.

It was enabled by default (along with metadata CRCs) in xfsprogs v3.2.3

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
