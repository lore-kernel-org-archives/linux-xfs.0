Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A89927F47
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 03:27:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48649AC005
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 01:27:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Zoqt2RtaJuQgZZO6 for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 01:27:52 -0700 (PDT)
Date: Mon, 12 May 2014 18:27:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: processes are stuck at xlog_grant_head_wait()
Message-ID: <20140512082748.GX5421@dastard>
References: <53708354.2060103@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53708354.2060103@jp.fujitsu.com>
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
To: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, esandeen@redhat.com, xfs@oss.sgi.com

On Mon, May 12, 2014 at 05:16:20PM +0900, Masayoshi Mizuma wrote:
> Hi all,
> 
> Processes are stuck at xlog_grant_head_wait() when I ran a heavy stress
> test (xfstests, ltpstress and fsstress concurrently) on linux-next
> (3.15.0-rc4-next-20140506) kernel.
> I got the crash dump, then I think this problem is similar as a problem
> fixed by the following commit. 

Already fixed in the for-next branch.

49abc3a xfs: truncate_setsize should be outside transactions

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
