Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E78157F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:44:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FB06AC002
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:44:49 -0800 (PST)
Received: from mail-ie0-f178.google.com (mail-ie0-f178.google.com
	[209.85.223.178]) by cuda.sgi.com with ESMTP id
	yXxeTHJox4V0bBbX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:44:48 -0800 (PST)
Received: by mail-ie0-f178.google.com with SMTP id lx4so1664838iec.23
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:44:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131212180144.GB19422@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-7-git-send-email-jayr@google.com>
	<20131211074657.GF19248@infradead.org>
	<20131211224229.GK10988@dastard>
	<20131212180144.GB19422@infradead.org>
Date: Thu, 12 Dec 2013 14:44:47 -0800
Message-ID: <CAFA30n_-s1uMeQ0k2EoawY4NzMSiqkH+tHze9rASej2RoM_TjA@mail.gmail.com>
Subject: Re: [PATCH 06/10] xfstests: fix generic/225 to check fiemap support
From: Junho Ryu <jayr@google.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, tytso@mit.edu, Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

>> I'd just rename if _require_fiemap, because we need both xfs_io and
>> kernel support for it, and we need xfs_io support to check for
>> kernel support....
>
> Fine with me.

There are 3 more _require_xfs_io_.* functions. I can create another
patch if you want these names to be consistent.

_require_xfs_io_falloc()
_require_xfs_io_falloc_punch()
_require_xfs_io_zero()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
