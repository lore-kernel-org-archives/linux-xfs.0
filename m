Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22Cds6u059093 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 06:39:54 -0600
Received: from xwis.net (xwis.net [88.198.24.17]) by cuda.sgi.com with ESMTP
	id vkVt9Uep8CGGYZOA (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 04:39:52 -0800 (PST)
Received: from 82-136-223-88.ip.telfort.nl ([82.136.223.88]
	helo=[192.168.1.37])
	by xwis.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72) (envelope-from <olaf@xwis.net>) id 1S3Rm0-0001tH-Dx
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 13:39:48 +0100
Message-ID: <4F50BF89.7020909@xwis.net>
Date: Fri, 02 Mar 2012 13:39:37 +0100
From: Olaf van der Spek <olaf@xwis.net>
MIME-Version: 1.0
Subject: Re: fsync, rename, O_ATOMIC/O_PONIES
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi XFS devs,

I'm a bit late to the party, but I'd like to respond to some comments at 
http://lwn.net/Articles/476263/#Comments
http://lwn.net/Articles/484709/

 > Could any of the fsync advocates post real code that does the atomic 
variant of open, write, close?

 > Hint: it's not possible without tons of regressions.

 > Linux devs should really provide a proper solution (like O_ATOMIC) 
instead of blaming app devs for not doing the impossible.

I'd like to ask:
- Is there a tool to log all unsafe operations?
- What is the *right* way to update a file?

I've asked the last question multiple times, but nobody has been able to 
give me a proper answer.

Greetings,

Olaf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
