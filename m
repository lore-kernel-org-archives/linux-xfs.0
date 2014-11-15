Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DE7F7F55
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 18:03:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C433304043
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 16:03:55 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id XCxwNlXFzqV7hBqS
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Nov 2014 16:03:53 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Mismatch UUID
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <546692DA.9040105@sandeen.net>
Date: Fri, 14 Nov 2014 17:03:51 -0700
Message-Id: <22EDE821-F431-4EA2-9CAD-BA7F3A4729DB@colorremedies.com>
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
	<6AB68617-0884-486D-8B96-8FD22DBC76D1@colorremedies.com>
	<546692DA.9040105@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Robert Tench <robtench@hotmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Nov 14, 2014, at 4:40 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 11/14/14 4:31 PM, Chris Murphy wrote:
> =

>> It=92s very good to ask instead of haphazardly trying things. Trying to
>> normally mount the file system should be safe; and then use dmesg to
>> check for kernel messages. The xfs kernel code is responsible for log
>> replay and making most kinds of repairs, anything it can=92t deal with
>> will be reported as a kernel message. If mount fails, report kernel
>> xfs related messages, and also the results from xfs_check -n.
> =

> xfs_repair -n
> =

> xfs_check is deprecated and has no -n option ;)

Yep, brain flatulence.

Chris
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
