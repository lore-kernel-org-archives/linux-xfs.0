Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 14:24:51 -0800 (PST)
Received: from page.mel.office.aconex.com (eth2333.vic.adsl.internode.on.net [150.101.159.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kATMOgaG025573
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 14:24:43 -0800
Subject: Re: [PATCH 1/2]segmentation fault in xfs_io mread/mwrite command
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <200611290026.AA04738@TNESG9305.tnes.nec.co.jp>
References: <200611290026.AA04738@TNESG9305.tnes.nec.co.jp>
Content-Type: text/plain
Date: Thu, 30 Nov 2006 09:22:41 +1100
Message-Id: <1164838961.4992.29.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

On Wed, 2006-11-29 at 09:26 +0900, Utako Kusaka wrote:
> Hi,
> 
> I found the following issues in xfs_io.
>  mread command:
>   a) Causes a segmentation fault.
>      Because "length"+1 bytes data is copied to buffer in read_mapping(),
>      but buffer size is "length".
>   b) Reads from wrong offset.
>   c) The first byte of dump data is incorrect when length > page size.
>  mwrite command:
>   d) Data placement is incorrect when -r option is specified
>      because of wrong for-loop counter.
> 
> This patch fixes them.
> 

Looks OK - could you send explicit test cases that demonstrate each
problem please?  (i.e. actual xfs_io invocations).  Particularly the
segfault should be easy to show, something like:
xfs_io -f -c 'mmap ...' -c 'mread ...' /tmp/foo)

That way they can be added to the regression test suite to ensure these
things don't spontaneously break themselves in the future.

thanks!

-- 
Nathan
