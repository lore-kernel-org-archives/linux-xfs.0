Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6BEE7F3F
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 10:55:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E01DAC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 08:55:05 -0700 (PDT)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id pXtFEOaX3rAwrnCF for
	<xfs@oss.sgi.com>; Mon, 09 Mar 2015 08:55:03 -0700 (PDT)
Message-ID: <54FDC254.6010105@aei.mpg.de>
Date: Mon, 09 Mar 2015 16:55:00 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: xfs_repair segfault
References: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
In-Reply-To: <1145328183.409860.1425916240318.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>, xfs@oss.sgi.com
Cc: =?UTF-8?B?w5NtYXIgSGVybWFubnNzb24=?= <omar@rvx.is>

Hi Rui

On 03/09/2015 04:50 PM, Rui Gomes wrote:
> Full output and GDB Backtrace in the attachment, do you guys have any
> advice how can we get xfs_repair to do a clean run?
> 

At the very least (though I'm not sure if that will already fix it) I
think you need to change the -m flag:


/usr/sbin/xfs_repair -n -P -m 500000000000000 /dev/sdb1

according to man page:

 -m maxmem
              Specifies the approximate maximum amount of memory, in
megabytes, to use for xfs_repair.  xfs_repair has its own internal block
cache  which  will  scale
              out up to the lesser of the process's virtual address
limit or about 75% of the system's physical RAM.  This option overrides
these limits.

              NOTE: These memory limits are only approximate and may use
more than the specified limit.

and I doubt your machine has that much memory, possibly just drop it for
now.

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
