Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7AD77F47
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 23:28:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6042304032
	for <xfs@oss.sgi.com>; Mon, 31 Aug 2015 21:28:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ax6WKDfHzaVWmRII for <xfs@oss.sgi.com>;
	Mon, 31 Aug 2015 21:28:38 -0700 (PDT)
Subject: Re: Ask help on an issue 'XFS (sd*): discard failed for extent, error
	5'
References: <55E52198.7070607@unitedstack.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E52975.8020005@sandeen.net>
Date: Mon, 31 Aug 2015 23:28:37 -0500
MIME-Version: 1.0
In-Reply-To: <55E52198.7070607@unitedstack.com>
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
To: Jevon Qiao <qiaojianfeng@unitedstack.com>, xfs@oss.sgi.com

On 8/31/15 10:55 PM, Jevon Qiao wrote:
> Hi All,
> 
> Currently, I notice that there are lot's of errors written in the /var/log/messages file.
> 
>     2015-08-29T23:58:54.477236+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
>     2015-08-29T23:58:54.477255+00:00 server-68 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>     2015-08-29T23:58:54.477256+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
>     2015-08-29T23:58:54.477257+00:00 server-68 kernel: Sense Key : Illegal Request [current]
>     2015-08-29T23:58:54.477258+00:00 server-68 kernel: sd 0:0:4:0: [sdc]
>     2015-08-29T23:58:54.477259+00:00 server-68 kernel: Add. Sense: Invalid field in parameter list
>     2015-08-29T23:58:54.477260+00:00 server-68 kernel: sd 0:0:4:0: [sdc] CDB:
>     2015-08-29T23:58:54.477261+00:00 server-68 kernel: Unmap/Read sub-channel: 42 00 00 00 00 00 00 00 18 00
>     2015-08-29T23:58:54.477263+00:00 server-68 kernel: end_request: critical target error, dev sdc, sector 325046824
>     2015-08-29T23:58:54.477268+00:00 server-68 kernel: XFS (sdc2): discard failed for extent [0x64815,2021], error 5
> 
> Has anyone encountered the same issue before? How can you solve it?

Looks like xfs is simply reacting to errors from the storage; I'd try to get
to the bottom of why you're getting all those scsi errors.

But probably not on the xfs list.  :)

-Eric

> Thanks,
> Jevon
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
