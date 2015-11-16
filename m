Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A61D27CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:32:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 759CE8F8035
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:32:58 -0800 (PST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id zO9jNkB9heJQsPvd
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Nov 2015 07:32:56 -0800 (PST)
Received: by wmdw130 with SMTP id w130so116231514wmd.0
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:32:55 -0800 (PST)
Subject: Re: AIO read returns negative number for bytes read
References: <564883BD.8070607@scylladb.com>
	<CAB-428nQfSdBpLkANvEoWjsJhV=6KbQD2wQ7hJbXmHh-GgjyTQ@mail.gmail.com>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <5649F725.6080508@scylladb.com>
Date: Mon, 16 Nov 2015 17:32:53 +0200
MIME-Version: 1.0
In-Reply-To: <CAB-428nQfSdBpLkANvEoWjsJhV=6KbQD2wQ7hJbXmHh-GgjyTQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: linux-aio@kvack.org, xfs@oss.sgi.com



On 11/16/2015 05:19 PM, Alireza Haghdoost wrote:
> On Sun, Nov 15, 2015 at 7:08 AM, Avi Kivity <avi@scylladb.com> wrote:
>> Due to a bug in my program, I initiated a read beyond eof. Specifically, the
>> file size is 13002 bytes and the read offset is 13312 (0x3400).
>>
>> I would expect such a read to return 0 bytes read, but io_getevents returns
>> -310, which is suspiciously equal to (13002 - 13312).
>>
>> I attach a reproducer.
>>
>> 4.2.5-201.fc22.x86_64
>>
>> Are my expectations incorrect, or is this a bug in aio or xfs?
> I think it is not a bug. This post might be helpful:
> http://marc.info/?l=linux-aio&m=142315449930935&w=2

The post indicates that it is a bug.  A negative value indicates an 
error, but there is no error 310.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
