Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F11297F60
	for <xfs@oss.sgi.com>; Sun,  7 Jun 2015 04:16:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73119AC003
	for <xfs@oss.sgi.com>; Sun,  7 Jun 2015 02:16:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2KydpxrTAvfFNsJl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 07 Jun 2015 02:16:30 -0700 (PDT)
Date: Sun, 7 Jun 2015 11:16:28 +0200 (CEST)
From: Ales Novak <alnovak@suse.cz>
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
In-Reply-To: <20150605222257.GY24666@dastard>
Message-ID: <alpine.LSU.2.03.1506071054580.20732@suse.cz>
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
	<20150605222257.GY24666@dastard>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On 2015-6-6 00:22, Dave Chinner wrote:

> Can you give more information about the crashes? From this
> description, I do not know whether this is a work around or a fix
> because I don't know  what code is actually causing the problem or
> the circumstances in which the crash occurs. Hence I cannot
> determine if your change is the right change to make or whether the
> documetnation is simply wrong and we have a real bug we shoul dbe
> fixing.

The crashes occurred with logsunit=192k and logbsize=256k. xlog_sync() is 
calculating in logsunit units:

  count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));

With count_init=256k, the calculated roundoff will try to cover that in 
two 192k units. This roundoff is passed to the xlog_pack_data() which 
walks the buffer and (hopefully) fails when it hits its 256k border.

-- 
Ales Novak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
