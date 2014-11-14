Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47DB87F51
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 17:40:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 355B38F8050
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 15:40:14 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id avUSTr8EHPd326Xy for <xfs@oss.sgi.com>;
	Fri, 14 Nov 2014 15:40:13 -0800 (PST)
Message-ID: <546692DA.9040105@sandeen.net>
Date: Fri, 14 Nov 2014 17:40:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Mismatch UUID
References: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
	<6AB68617-0884-486D-8B96-8FD22DBC76D1@colorremedies.com>
In-Reply-To: <6AB68617-0884-486D-8B96-8FD22DBC76D1@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>, Robert Tench <robtench@hotmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/14/14 4:31 PM, Chris Murphy wrote:

> It=92s very good to ask instead of haphazardly trying things. Trying to
> normally mount the file system should be safe; and then use dmesg to
> check for kernel messages. The xfs kernel code is responsible for log
> replay and making most kinds of repairs, anything it can=92t deal with
> will be reported as a kernel message. If mount fails, report kernel
> xfs related messages, and also the results from xfs_check -n.

xfs_repair -n

xfs_check is deprecated and has no -n option ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
