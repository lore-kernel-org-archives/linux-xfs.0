Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1N51KEM074472 for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 23:01:20 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B2B9D8F80B7
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 21:00:46 -0800 (PST)
Message-Id: <FE09F2E2-54EC-41C8-9145-7B89C6E62AC2@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <200902221539.26143.vapier@gentoo.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: xfsprogs/xfsdump release process
Date: Sun, 22 Feb 2009 23:00:45 -0600
References: <200902221348.51905.vapier@gentoo.org>
	<200902221539.26143.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: xfs-oss <xfs@oss.sgi.com>


On Feb 22, 2009, at 2:39 PM, Mike Frysinger wrote:

> On Sunday 22 February 2009 13:48:49 Mike Frysinger wrote:
>> how are release tarballs created ?  seems like there's an error in  
>> the
>> process as the dmapi-2.2.9 contains files it shouldnt.  for example,
>> autom4te.cache/, include/builddefs, etc...
>
> in a similar vain, every xfsdump/xfsprogs release has made people run
> `autoconf` first as the configure script is considered part of the  
> distclean
> target in general.  i dont think that makes any sense as the  
> configure script
> should be included with every release tarball.

Mike, you're absolutely right here. The config files got into the
dmapi tarball by mistake, sorry for this. I verified that neither
xfsprogs nor xfsdump have any extra files. New (clean) dmapi tarball
will be on the oss site shortly.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
