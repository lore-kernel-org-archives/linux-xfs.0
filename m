Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 714D97F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 15:02:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D235AC008
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 13:01:59 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	5BODOjevPKG6ZGJ1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 13:01:58 -0700 (PDT)
Received: by mail-wi0-f172.google.com with SMTP id d1so6904029wiv.17
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 13:01:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544FD577.9040605@sandeen.net>
References: <CA+tQb7GSvkgsxZT2awAkMjh9wY6JXBygLoenTrtFtmRMSVwuUA@mail.gmail.com>
	<544FD577.9040605@sandeen.net>
Date: Tue, 28 Oct 2014 21:01:56 +0100
Message-ID: <CAAxjCEyTq5UfmqzBbtXXQ=vWoHmCG5WJvLGsSwCfRL0P4qnCJw@mail.gmail.com>
Subject: Re: Kernel crashes with trace ending in XFS code on RHEL6 variant
	kernel
From: Stefan Ring <stefanrin@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kokoska <jan@glow.cz>, Linux fs XFS <xfs@oss.sgi.com>

On Tue, Oct 28, 2014 at 6:42 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 10/28/14 10:38 AM, Jan Kokoska wrote:
>> Hi,
>>
>> I'm running OpenVZ (OS container) kernel variant of RHEL6 kernel on
>
> ... for which we have no source code? ;)
>
> I don't know what's in "2.6.32-openvz-amd64" so can't help much.
>
> What is at line 86 of xfs_aops.c in that kernel?

>From my quick investigation, it would seem to be the line "bh = head =
page_buffers(page);" of xfs_count_page_state.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
