Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n970ptkV147027 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 19:51:55 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B0F2121E26D
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 17:53:19 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Khwt3wjUOCcFFC75 for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 17:53:19 -0700 (PDT)
Message-ID: <4ACBE67E.8010502@sandeen.net>
Date: Tue, 06 Oct 2009 19:53:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: moving libhandle to /usr
References: <20091006154249.GA1411@infradead.org>	<200910061533.51365.vapier@gentoo.org>
	<20091006234425.GA20561@infradead.org>
In-Reply-To: <20091006234425.GA20561@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: nathans@debian.org, Mike Frysinger <vapier@gentoo.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Oct 06, 2009 at 03:33:46PM -0400, Mike Frysinger wrote:
>> On Tuesday 06 October 2009 11:42:49 Christoph Hellwig wrote:
>>> Currently we install the versioned libhandle into /lib by default,
>>> and all other libraries into /usr.  Given that no program in / actually
>>> uses libhandle this seems rather awkward to me.  From Mike's comments
>>> in the past I think Gentoo already installs it into /usr anyway.
>>>
>>> Is there anything speaking against moving all libraries to /usr and
>>> switching Debian/Fedora to that aswell?
>> xfsdump uses it and xfsdump is installed into / by default right ?  so 
>> libhandle needs to be in /lib so long as xfsdump is in /sbin.
> 
> Indeed, the makefile configuration currently builds it into /, while
> the configure default uses /usr.  Yikes..

argh I did rpm -ql xfsprogs xfsdump | grep bin ... on a box that didn't 
have xfsdump installed.  Argh.

Thanks for the catch Mike ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
