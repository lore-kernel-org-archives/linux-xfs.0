Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8RJH7We061571 for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 14:17:07 -0500
Message-ID: <4E822130.70004@sgi.com>
Date: Tue, 27 Sep 2011 14:17:04 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: handle dump files with checksum bug
References: <1316781902-19803-1-git-send-email-wkendall@sgi.com>
	<1316791615.2879.50.camel@doink>
In-Reply-To: <1316791615.2879.50.camel@doink>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 09/23/2011 10:26 AM, Alex Elder wrote:
> On Fri, 2011-09-23 at 07:45 -0500, Bill Kendall wrote:
>> +				mlog( MLOG_NORMAL | MLOG_WARNING, _(
>> +					"extattr header checksum "
>> +					"could not be verified\n") );
>
> Is there any way to slightly change this message so
> that someone who saw it would feel like "I got this
> warning but it's really OK"?  If I were a user and
> got this message I would be a little afraid that
> it meant something was really wrong with what got
> restored--possibly the whole thing, or just on
> some unnamed file, never to be found.
>
> Maybe "old-style extattr header checksums being
> ignored".  (I'm sure you can come up with better,
> I just like to offer *something* when I suggest
> a change.)

I more or less like what you've suggested. How about this:

    "ignoring old-style extattr header checksums"

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
