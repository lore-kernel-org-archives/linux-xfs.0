Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1ADIcwk251721 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 07:18:39 -0600
Received: from mexforward.lss.emc.com (mexforward.lss.emc.com [128.222.32.20])
	by cuda.sgi.com with ESMTP id wHLUZCqH50i6xo8A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Feb 2012 05:18:37 -0800 (PST)
From: <shane.dempsey@emc.com>
Date: Fri, 10 Feb 2012 08:17:24 -0500
Subject: RE: Red Hat bug 643571
Message-ID: <B3A97B1555F0234DB864AA012D2BAF833DE7D3AE@MX27A.corp.emc.com>
References: <B3A97B1555F0234DB864AA012D2BAF833DE7D360@MX27A.corp.emc.com>
	<4F341365.3010400@sandeen.net>
In-Reply-To: <4F341365.3010400@sandeen.net>
Content-Language: en-US
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

Hi Eric,

Thanks a lot for your reply.

Regards,

Shane.

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: 09 February 2012 18:42
To: Dempsey, Shane
Cc: xfs@oss.sgi.com
Subject: Re: Red Hat bug 643571

On 2/9/12 10:45 AM, shane.dempsey@emc.com wrote:
> Hello,
> 
> I believe Eric Sandee was working on this bug -
> https://bugzilla.redhat.com/show_bug.cgi?id=643571 to resolve a
> fragmentation issue with XFS on RHEL 5.5.


> 
> Do you know if this fix is in RHEL 6.1, kernel 2.6.32-131.0.15?

RH support is the better avenue for these questions, FWIW.

But from the comments in the bug:

linux-2.6-fs-xfs-fix-speculative-allocation-beyond-eof.patch

is what went in;

[sandeen@sandeen linux-2.6]$ git log --pretty=oneline fs/xfs | grep "speculative allocation"
9f6c92b9cc2fd41d6c7b493be5637cc5b5659880 [XFS] Fix speculative allocation beyond eof
[sandeen@sandeen linux-2.6]$ git describe --contains 9f6c92b9cc2fd41d6c7b493be5637cc5b5659880
v2.6.30-rc8~5^2~56

so it went into 2.6.30, so should be present in all later kernels.

-Eric Sandeen-with-an-N ;)

> 
> 
> 
> Regards,
> 
> 
> 
> Shane.
> 
> 
> 
> 
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
