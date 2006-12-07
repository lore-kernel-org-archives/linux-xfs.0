Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 12:53:08 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB7KqxaG023431
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 12:53:02 -0800
Message-ID: <45787ED4.5070801@falconstor.com>
Date: Thu, 07 Dec 2006 15:51:32 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: New CentOS4/RHEL4-compatible xfs module rpms
References: <4560AB84.9060200@sandeen.net> <45784E71.4080605@falconstor.com> <457854CB.5030507@sandeen.net>
In-Reply-To: <457854CB.5030507@sandeen.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

Eric Sandeen wrote:
> Geir A. Myrestrand wrote:
> 
>> However, I run into issues with xfs_freeze as it often locks up when I 
>> try to freeze a file system where there is I/O activity. Sometimes it 
>> happen on the first xfs_freeze invocation to freeze the file system, 
>> other times I have to unfreeze and then it happens on the second time I 
>> freeze. xfs_freeze never returns when this happens.
>>
> 
> Did you have this problem on the previous version?

I just tested with the old version, and I run into the same issue.

-- 

Geir A. Myrestrand
