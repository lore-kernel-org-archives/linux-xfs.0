Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45EC57F51
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:42:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 316FA304053
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:42:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HdK8FcUWaGQHlS4T for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 11:42:39 -0700 (PDT)
Message-ID: <520D2117.5030400@sandeen.net>
Date: Thu, 15 Aug 2013 13:42:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <20130814062041.GB12779@dastard>
	<520BAE48.1020605@allmail.net> <520D0D5D.4000309@sandeen.net>
	<520D162B.5060901@allmail.net> <520D1A82.1000709@sandeen.net>
	<520D1F8A.3060707@allmail.net>
In-Reply-To: <520D1F8A.3060707@allmail.net>
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
To: Michael Maier <m1278468@allmail.net>
Cc: xfs@oss.sgi.com

On 8/15/13 1:35 PM, Michael Maier wrote:
>> but a check prior wouldn't have helped you, because repair didn't detect
>> > the problem that growfs choked on.
> The old xfs_repair! Your patched one would have detected the problem if
> I got it right.
> 
> But globally speaking: you're right - it's impossible to get 100%
> security. But couldn't xfs_repair -n find other problems which therefore
> could be repaired before growing the FS?

yep, sure.

extN keeps track of the last fsck instance, and sometimes enforces it
prior to resize.  XFS doesn't do that, but it's probably not bad
practice.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
