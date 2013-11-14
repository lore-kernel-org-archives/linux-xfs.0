Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C6177F50
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 04:11:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0921D8F804B
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 02:11:24 -0800 (PST)
Received: from smtprelay06.ispgateway.de (smtprelay06.ispgateway.de
	[80.67.31.95]) by cuda.sgi.com with ESMTP id RDJQHGOFYziCCAD1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Nov 2013 02:11:23 -0800 (PST)
Received: from [62.224.102.21] (helo=r008.localnet)
	by smtprelay06.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <guido@ambient-entertainment.de>)
	id 1VgttR-00062a-Hg
	for xfs@oss.sgi.com; Thu, 14 Nov 2013 11:11:21 +0100
From: Guido Winkelmann <guido@ambient-entertainment.de>
Subject: Re: Files not touched in weeks got truncated after a crash
Date: Thu, 14 Nov 2013 11:11:12 +0100
Message-ID: <6414439.XpxSIk2GZ9@r008>
In-Reply-To: <CAAxjCEz5ncQGfpZTfeps1r+U0q8E26P5_t6Mk_QP4FekvbRivA@mail.gmail.com>
References: <2662179.4mj0dgORXu@r008> <5283E387.70704@gmail.com>
	<CAAxjCEz5ncQGfpZTfeps1r+U0q8E26P5_t6Mk_QP4FekvbRivA@mail.gmail.com>
MIME-Version: 1.0
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

On Wednesday 13 November 2013 22:43:23 Stefan Ring wrote:
>On Wed, Nov 13, 2013 at 9:39 PM, Ric Wheeler <ricwheeler@gmail.com> wrote:
>> You should update your kernel - this sounds like an issue that Dave fixed
>> quite a few months back (and got shipped in RHEL and other distros, I don't
>> know about when Centos would pick it up)
>
>It's in the CentOS 6.4 kernel, according to the release notes:
>https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6
>/html/6.4_Technical_Notes/kernel.html (BZ#855139)

Hm, this could be it, but it still sounds a bit unlikely.
The bug description implies that the filesystem would have to have been idling 
from the point where the affected files were written until the point of the 
system crash (or unclean unmount), such that the old, and by that time 
incorrect, metadata updates would still linger in the journal, but that was 
not really the case here. The filesystem was quite busy during those weeks....

Also, the bug report speaks only of zero-length files, while many of our files 
had been truncated to lengths other than zero.

	Guido

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
