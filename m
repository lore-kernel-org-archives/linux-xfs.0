Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9945F7F37
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:25:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 89F278F8039
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 10:25:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0zq3bFPjXPTGyLJw for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 10:25:34 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 0762363C5A9F
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 12:25:34 -0600 (CST)
Subject: Re: xfs within one hour after power-on reset , nginx performance is
	poor and do not have this phenomenon on ext4
References: <11FA37A582DFC847A21131D4B69D8B495AA49849@szxema505-mbs.china.huawei.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5678441D.5090103@sandeen.net>
Date: Mon, 21 Dec 2015 12:25:33 -0600
MIME-Version: 1.0
In-Reply-To: <11FA37A582DFC847A21131D4B69D8B495AA49849@szxema505-mbs.china.huawei.com>
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
To: xfs@oss.sgi.com

There is not enough information here to begin considering your
problem report.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

I'm not even sure I understand what you have stated so far; you see
the RPS (requests per second) increase after the system has been up
for one hour, is that correct?

In any case, we aren't nginx experts here; you will need to do more
investigation to find out what is actually happening at the filesystem
level before we can be of much help, I think.

-Eric

On 12/21/15 1:09 AM, Linpeimin wrote:
> Hello , we use xfs file system to test nginx , I found the power-on
> reset , within the first one hour nginx relatively poor performance,
> and after one hour , re- test , performance result( RPS) of dynamic
> pages has improved.If we change the file system into ext4, you do not
> have this phenomenon , after the start,RPS performance has remained
> stable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
