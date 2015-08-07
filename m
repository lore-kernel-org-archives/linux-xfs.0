Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7D8927F55
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 00:36:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B3AC304043
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 22:36:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 04917m5hOJggsxV4 for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 22:36:10 -0700 (PDT)
Message-ID: <55C443C7.3010608@sandeen.net>
Date: Thu, 06 Aug 2015 22:36:07 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: why crc req on free-inobt & file-type-indir options?
References: <55C41D75.4040504@tlinx.org>
In-Reply-To: <55C41D75.4040504@tlinx.org>
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
To: "L.A. Walsh" <xfs@tlinx.org>, xfs-oss <xfs@oss.sgi.com>

On 8/6/15 7:52 PM, L.A. Walsh wrote:
> 
> Could anyone point me at the discussion or literature as to why
> a free-inodeB-Tree and inline-types, should *REQUIRE* a -crc=1 option?

FWIW, you can enable ftype w/o crcs.  Today it's a little broken, if you
specify in the wrong order it fails.  I just sent a patch for that.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
