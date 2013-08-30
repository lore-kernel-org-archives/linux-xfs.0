Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 439197F56
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:24:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D1AD304039
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:24:29 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id ofuK647pVj0iNLBa
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:24:28 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: higher agcount on LVM2 thinp volumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52200F5A.9050702@sandeen.net>
Date: Thu, 29 Aug 2013 21:24:06 -0600
Message-Id: <289A5A42-9879-4A2A-9284-4B8529A1488D@colorremedies.com>
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<52200BAE.1060501@sandeen.net>
	<4393C3B8-8C46-41ED-B9F3-BC7B37C2681F@colorremedies.com>
	<52200F5A.9050702@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Aug 29, 2013, at 9:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> Argh sorry, how did I type THAT?
> 
> # blockdev --getiomin --getioopt /dev/mapper/vg1-data

conventional LV:
[root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
512
0

thinp LV:

[root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
512
262144

(Now I see two ways to get the same info.)


Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
