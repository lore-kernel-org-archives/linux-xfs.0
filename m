Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B0DD7F81
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 15:11:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02A7B30407F
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 13:11:36 -0700 (PDT)
Received: from albireo.enyo.de (albireo.enyo.de [46.237.207.196]) by
	cuda.sgi.com with ESMTP id VnrTex9cWMXR1iCL (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 13:11:32 -0700 (PDT)
From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [FAQ] XFS speculative preallocation
References: <20140321162920.GA3087@laptop.bfoster>
Date: Fri, 21 Mar 2014 21:11:29 +0100
In-Reply-To: <20140321162920.GA3087@laptop.bfoster> (Brian Foster's message of
	"Fri, 21 Mar 2014 12:29:20 -0400")
Message-ID: <87eh1vuxam.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

* Brian Foster:

> Although speculative preallocation can lead to reports of excess space
> usage, the preallocated space is not permanent unless explicitly made so
> via fallocate or a similar interface.

How does an explicit allocation with posix_fallocate interact with
speculative preallocation?  Does it disable it?

I see rather dramatic fragmentation of the systemd journal when it is
stored on XFS, and it calls posix_fallocate before writing data to the
file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
