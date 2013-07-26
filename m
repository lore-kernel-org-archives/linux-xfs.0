Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77A7D29E0E
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:37:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03978AC002
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 14:37:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QFTc0G65QaDmmcmG for <xfs@oss.sgi.com>;
	Fri, 26 Jul 2013 14:37:40 -0700 (PDT)
Message-ID: <51F2EC21.6000208@sandeen.net>
Date: Fri, 26 Jul 2013 16:37:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: how to use fstrim?
References: <51F2BD31.5060301@profihost.ag>
In-Reply-To: <51F2BD31.5060301@profihost.ag>
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
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/26/13 1:17 PM, Stefan Priebe wrote:
> Hi,
> 
> what is the right way to use fstrim on top of XFS? just doing fstrim -v -m 4194304 /
> 
> results sometimes (might depend on disk i/o) to hanging tasks and stack traces - fstrim needs > 5 min in these cases.

As always, it's better to include things like the actual stack traces you got, so we have some idea what's going on ...

How fast it goes probably depends quite a lot on the storage underneath.

So including storage information as well would also help us give you a meaningful answer...

And kernel version... etc.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
