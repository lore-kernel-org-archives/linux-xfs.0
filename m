Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A0D97CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 19:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EE5A304066
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 17:47:54 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	n6Ho66XB7c53kzz0 for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 17:47:52 -0700 (PDT)
Date: Tue, 14 May 2013 10:47:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs - high CPU usage when removing files
Message-ID: <20130514004751.GQ32675@dastard>
References: <CAHBw7oSxcTYEEFzzhpZfH_EshyYXOsRBpf=S+bLEgCyQZkLFsA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHBw7oSxcTYEEFzzhpZfH_EshyYXOsRBpf=S+bLEgCyQZkLFsA@mail.gmail.com>
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
To: Radoslaw Garbacz <radoslaw.garbacz@xtremedatainc.com>
Cc: xfs@oss.sgi.com

On Mon, May 13, 2013 at 01:28:47PM -0500, Radoslaw Garbacz wrote:
> Hi,
> 
> I noticed a high CPU usage when removing files from XFS partition on Linux,
> CentOS (always close to 100%).
> Is it a known issue, or is it more likely to be attributed to my testing
> methodology ('time' command)?

If you are removing extremely fragmented files, then 100% CPU will
be seen.  If you are removing tens of thousands of small files, then
100% CPU will be seen,

IOWs, if there's enough work to be done, removing files will use all
the available CPU. There's no problem with that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
