Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B61BD7F4C
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 08:17:36 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 581B18F8035
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 06:17:36 -0800 (PST)
Received: from mail-qc0-f176.google.com (mail-qc0-f176.google.com
	[209.85.216.176]) by cuda.sgi.com with ESMTP id
	ZvYQ9Kjzxz9MbqhO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Feb 2013 06:17:35 -0800 (PST)
Received: by mail-qc0-f176.google.com with SMTP id n41so2081240qco.35
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 06:17:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130217212536.GY26694@dastard>
References: <CAEUQcehy1fy5-W-TA--2emBgL3y9JskqRPCZf1ED5JDbPHqKTQ@mail.gmail.com>
	<20130217212536.GY26694@dastard>
Date: Mon, 18 Feb 2013 19:47:34 +0530
Message-ID: <CAEUQceirWSCrLZmYx1keUSYFPm0zP5CQpQtXxgVvHoheDHjEvQ@mail.gmail.com>
Subject: Re: High %user CPU in XFS
From: Subranshu Patel <spatel.ml@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> Page faults, CPU cache misses. XFS has a significantly large icache
> and dcache footprint than ext4, so those are the likely causes

I have a query. Will page fault, cache misses etc will increase the
%user CPU utilization or %system CPU utilization. I thought it will
affect the %system and not %user CPU usage?

%user - Percentage of CPU utilization that occurred while executing at
the user level (application).
%system - Percentage of CPU utilization that occurred while executing
at the system level (kernel).

On Mon, Feb 18, 2013 at 2:55 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Feb 17, 2013 at 09:20:46PM +0530, Subranshu Patel wrote:
>>  I created 2 filesystem on my system (RHEL 6.3, kernel 2.6.32) - XFS
>> and EXT4 and mounted them.
>>
>> On both the filesystem I executed a program which performed the following:
>> - Create large number of directories
>> - Removing all the directories
>>
>> During the execution of the program, I monitored the %user and %system
>> CPU usage (using sar command)
>>
>> For EXT4 the %user was 1% and %system was 21%
>> For XFS the %user was 20% and %system was 52%
>>
>> But I am not able to understand %user consumption, since %user reports
>> the CPU usage of the user level (application), shouldn't it be the
>> same for both EXT4 and XFS?
>
> Perf is your friend.
>
>> What are the factors that decide the %user component keeping in mind
>> that only the filesystem is different?
>
> Page faults, CPU cache misses. XFS has a significantly large icache
> and dcache footprint than ext4, so those are the likely causes.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
