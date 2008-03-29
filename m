Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Mar 2008 04:16:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2TBGbh1012706
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 04:16:39 -0700
Received: from smtp-out003.kontent.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33157707781
	for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 04:17:10 -0700 (PDT)
Received: from smtp-out003.kontent.com (smtp-out003.kontent.com [81.88.40.217]) by cuda.sgi.com with ESMTP id EFpcdWQ4GxV27BKx for <xfs@oss.sgi.com>; Sat, 29 Mar 2008 04:17:10 -0700 (PDT)
Message-ID: <47EE2539.1060001@theendofthetunnel.de>
Date: Sat, 29 Mar 2008 12:17:13 +0100
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: Re: XFS performance on LVM2 mirror
References: <1206481052.4283.17.camel@dhcp-192-168-6-143>
In-Reply-To: <1206481052.4283.17.camel@dhcp-192-168-6-143>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Scott Tanner <stanner@amientertainment.net>
Cc: xfs@oss.sgi.com

Scott Tanner wrote:
> Are there any special tweaks for XFS on LVM2 mirrors?

LVM will always slow down things, it's an additional layer, there is no 
way around that.

LVM does not do well with XFS stripe alignment, it causes sequential 
writes to happen in a non-uniform, pumping way and additionally does not 
support write barriers.

> XFS mounted with -o noatime,nodiratime,nobarrier,logbufs=8

Nodiratime is redundant. You might add logbsize=256k. Lazy-counters 
require you to at least upgrade to 2.6.23.

I'm unsure if your stripe alignment is correct. Why don't you use the 
su,sw options? Why do you run with only 64MB logsize?

> Recommendations on my setup?

Drop LVM altogether. Add ram to the box. Personally I'd use Solaris/ZFS 
for that specific setup.


-- 
Best regards,
Hannes Dorbath
