Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82DviVJ072973 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 08:57:44 -0500
Message-ID: <4E60E0D4.9080601@sgi.com>
Date: Fri, 02 Sep 2011 08:57:40 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: call mlog_exit in content_stream_restore
References: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
	<1314375344.2821.47.camel@doink>
In-Reply-To: <1314375344.2821.47.camel@doink>
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

On 08/26/2011 11:15 AM, Alex Elder wrote:
> On Mon, 2011-08-15 at 13:59 -0500, Bill Kendall wrote:
>> This patch adds mlog_exit() calls to all the return paths in
>> content_stream_restore(). mlog_exit() is supposed to be called before
>> returning from content_stream_dump() and content_stream_restore(), but
>> many paths in the latter did not do so, allowing for the stream exit
>> status to be incorrect.

...

> The end of this function is a whole bunch of repetitive
> code.  It would be cleaner to assign a "ret" variable
> (or whatever name you think fits the existing code)
> and then after this last switch statement call:
>
> 	return mlog_exit(ret, rv);
>
> (If Media_end() got a flag, you might not need the
> switch statement at all...)
>
> Christoph suggested a goto which would be similar
> but would affect the whole function.  And in fact
> I think it might simplify a lot--possibly eliminating
> whole switch statements entirely--so I think that's
> an idea worth considering.

I looked at doing this, but it didn't result in any switch
statements being removed. Each switch statement is different
enough that we can't just have a single switch at the end
of the function that maps the RV_* value to the proper
EXIT_* value.

I made some other minor changes based on suggestions, and
will repost after the "xfsdump: remove unnecessary" patch
is reviewed. (This patch overlaps a bit with that one.)

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
