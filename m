Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45D207CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:20:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C16CAAC003
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:20:16 -0800 (PST)
Received: from mail-yk0-f181.google.com (mail-yk0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	qjbfdaSBQSfCbZ3M (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:20:12 -0800 (PST)
Received: by ykba77 with SMTP id a77so242912572ykb.2
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:20:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564883BD.8070607@scylladb.com>
References: <564883BD.8070607@scylladb.com>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 16 Nov 2015 09:19:32 -0600
Message-ID: <CAB-428nQfSdBpLkANvEoWjsJhV=6KbQD2wQ7hJbXmHh-GgjyTQ@mail.gmail.com>
Subject: Re: AIO read returns negative number for bytes read
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
To: Avi Kivity <avi@scylladb.com>
Cc: linux-aio@kvack.org, xfs@oss.sgi.com

On Sun, Nov 15, 2015 at 7:08 AM, Avi Kivity <avi@scylladb.com> wrote:
> Due to a bug in my program, I initiated a read beyond eof. Specifically, the
> file size is 13002 bytes and the read offset is 13312 (0x3400).
>
> I would expect such a read to return 0 bytes read, but io_getevents returns
> -310, which is suspiciously equal to (13002 - 13312).
>
> I attach a reproducer.
>
> 4.2.5-201.fc22.x86_64
>
> Are my expectations incorrect, or is this a bug in aio or xfs?

I think it is not a bug. This post might be helpful:
http://marc.info/?l=linux-aio&m=142315449930935&w=2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
