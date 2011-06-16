Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GEktXx039572 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 09:46:56 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC6A5B4126A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 07:46:54 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id Uk8YWpJk8ZHFB7P6 for <xfs@oss.sgi.com>;
	Thu, 16 Jun 2011 07:46:54 -0700 (PDT)
Message-ID: <4DFA175D.9060005@sandeen.net>
Date: Thu, 16 Jun 2011 09:46:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: auto group failing on kernel v2.6.38.5
References: <BANLkTi=pgOCvn_2tdKXM6sLx_JKhzbrcEw@mail.gmail.com>	<4DF8C9BD.6020104@sandeen.net>
	<BANLkTimmEHrxONk-bm354sPnnLyc-0eQ-w@mail.gmail.com>
In-Reply-To: <BANLkTimmEHrxONk-bm354sPnnLyc-0eQ-w@mail.gmail.com>
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
To: Manish Aggarwal <mani.iitb@gmail.com>
Cc: xfs@oss.sgi.com

On 6/16/11 12:05 AM, Manish Aggarwal wrote:
> Hi Eric,
> 
> Thanks for responding. Yes I agree most of the Test Cases are failed
> due to the umount failure.
> 
> But isn't the "quick and auto" group are supposed to run without any
> error?

Yes, but if that were guaranteed, there would be no reason to run them!  :)

> The point is in case I am running xfstest suite on some target, how
> would I know that whether the there is some error with my target (or
> kernel settings) or if there is some error in xfs test suite itself.

The test suite is not perfect; it evolves, and there are bugs in it
as with any other software.

It is your role as a developer and as a user of the test suite to
investigate failures, and discern where the problem lies.

In general, the test suite works.  Busy filesystems at unmount are
not a common result, so you need to try to find out why you are
running into that, and what the root cause may be ...

Running on a usb stick is not something the core xfs developers do,
so you may well run into unique issues.

-Eric

> Regards, Manish

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
