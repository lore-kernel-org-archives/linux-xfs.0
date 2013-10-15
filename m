Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8514A7F5A
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 14:07:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 609658F804B
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 12:07:32 -0700 (PDT)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id mV60xyp27rPKEpPI
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Oct 2013 12:07:22 -0700 (PDT)
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:62343
	helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1) (envelope-from <lists@colorremedies.com>)
	id 1VW9xg-004HPo-2S
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 13:07:20 -0600
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: xfs corrupted
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <525D8D67.2090301@keptprivate.com>
Date: Tue, 15 Oct 2013 13:07:22 -0600
Message-Id: <F0730252-EF33-4452-957A-FA33DAD43913@colorremedies.com>
References: <1381826507281-35009.post@n7.nabble.com>
	<20131015203434.2f336fd8@galadriel.home>
	<525D8D67.2090301@keptprivate.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On Oct 15, 2013, at 12:45 PM, Stefanita Rares Dumitrescu <katmai@keptprivate.com> wrote:
> 
> What worries me is that i see 100 % cpu usage, some 74 % memory usage (i have 4 gb ram) but there is no disk activity at all. I was thinking that it would be at least some reads if the xfs_repair is doing something.

That is very low RAM for a system with two big arrays attached. So if repair finds it needs to repair something it's going to take a long time. 
http://xfs.org/index.php/XFS_FAQ#Q:_Which_factors_influence_the_memory_usage_of_xfs_repair.3F


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
