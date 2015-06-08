Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 170D37F60
	for <xfs@oss.sgi.com>; Mon,  8 Jun 2015 08:04:44 -0500 (CDT)
Message-ID: <557592E7.2010805@sgi.com>
Date: Mon, 08 Jun 2015 08:04:39 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix in the setting of logbsize
References: <1433510925-11438-1-git-send-email-alnovak@suse.cz>
	<20150605222257.GY24666@dastard>
	<alpine.LSU.2.03.1506071054580.20732@suse.cz>
In-Reply-To: <alpine.LSU.2.03.1506071054580.20732@suse.cz>
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
To: Ales Novak <alnovak@suse.cz>
Cc: xfs@oss.sgi.com

On 06/07/15 04:16, Ales Novak wrote:
>
> On 2015-6-6 00:22, Dave Chinner wrote:
>
>> Can you give more information about the crashes? From this
>> description, I do not know whether this is a work around or a fix
>> because I don't know what code is actually causing the problem or
>> the circumstances in which the crash occurs. Hence I cannot
>> determine if your change is the right change to make or whether the
>> documetnation is simply wrong and we have a real bug we shoul dbe
>> fixing.
>
> The crashes occurred with logsunit=192k and logbsize=256k. xlog_sync()
> is calculating in logsunit units:
>
> count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
>
> With count_init=256k, the calculated roundoff will try to cover that in
> two 192k units. This roundoff is passed to the xlog_pack_data() which
> walks the buffer and (hopefully) fails when it hits its 256k border.
>

Talked about this once before:

  http://oss.sgi.com/archives/xfs/2013-03/msg00039.html

Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
