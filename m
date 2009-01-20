Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KEON3H018739 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 08:24:24 -0600
Received: from mail-bw0-f13.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 506B91BDC54F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:24:21 -0800 (PST)
Received: from mail-bw0-f13.google.com (mail-bw0-f13.google.com
	[209.85.218.13]) by cuda.sgi.com with ESMTP id DyB2z8j4meblYaTA
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:24:21 -0800 (PST)
Received: by bwz6 with SMTP id 6so238902bwz.20
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:24:20 -0800 (PST)
Message-ID: <4975D88B.7020906@gmail.com>
Date: Tue, 20 Jan 2009 14:58:35 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
MIME-Version: 1.0
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
	<20090120121335.GA19182@infradead.org>
	<20090120124515.GA31838@infradead.org>
In-Reply-To: <20090120124515.GA31838@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig pisze:
> On Tue, Jan 20, 2009 at 07:13:35AM -0500, Christoph Hellwig wrote:
>> On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
>>>>> Just curious:  do you have CONFIG_LBD set?
>>>>>
>>>> Hi Christoph,
>>>>
>>>> the answer is:
>>>> $ grep LBD .config
>>>> # CONFIG_LBD is not set
>>> Ok, let me reproduce it without that set..
>> Ok, on 32-bit x86 without CONFIG_LBD I can reliably reproduce the issue
>> with the following script:
> 
> Bisected down to:
> 
> commit 91cca5df9bc85efdabfa645f51d54259ed09f4bf
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Thu Oct 30 16:58:01 2008 +1100
> 
>     [XFS] implement generic xfs_btree_delete/delrec
> 
>     Make the btree delete code generic. Based on a patch from David Chinner
>     with lots of changes to follow the original btree implementations more
>     closely. While this loses some of the generic helper routines for
>     inserting/moving/removing records it also solves some of the one off bugs
>     in the original code and makes it easier to verify.
> 

Good job! Is there some ,,quick'' fix?

-Jacek

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
