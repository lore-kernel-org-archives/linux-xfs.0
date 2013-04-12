Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51AC57F3F
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 02:40:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3CF4D30404E
	for <xfs@oss.sgi.com>; Fri, 12 Apr 2013 00:40:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kGBo7s8g6nHKBrKi for <xfs@oss.sgi.com>;
	Fri, 12 Apr 2013 00:40:36 -0700 (PDT)
Date: Fri, 12 Apr 2013 17:40:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: make install support common/ and tests/ dirs
Message-ID: <20130412074034.GC30622@dastard>
References: <51678D0D.1070002@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51678D0D.1070002@gmail.com>
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
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: xfstests <xfs@oss.sgi.com>, Rich Johnston <rjohnston@sgi.com>, Dave Chinner <dchinner@redhat.com>

On Fri, Apr 12, 2013 at 12:26:53PM +0800, Wang Sheng-Hui wrote:
> +#
> +
> +TOPDIR = ..
> +include $(TOPDIR)/include/builddefs
> +
> +TESTS_SUBDIRS = $(shell find . -maxdepth 1 -type d | sed -n -e 's/\.\///gp')

This is much neater:

TESTS_SUBDIRS = $(sort $(dir $(wildcard  $(PWD)/*/)))

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
