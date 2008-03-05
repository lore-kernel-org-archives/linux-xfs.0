Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 19:52:48 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m253qdam014414
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 19:52:40 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63821652FA2
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2008 19:53:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id KUyUB1mFC4DTOQNg for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 19:53:08 -0800 (PST)
Message-ID: <47CE1921.9000708@sandeen.net>
Date: Tue, 04 Mar 2008 21:53:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corruption in xfs_end_bio_unwritten
References: <629727.55106.qm@web32504.mail.mud.yahoo.com> <47CDCA12.5060107@sandeen.net>
In-Reply-To: <47CDCA12.5060107@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ravi Wijayaratne <ravi_wija@yahoo.com>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Ravi Wijayaratne wrote:
>> Hi all,
>>
>> I am seeing data corruption in xfs_end_bio_unwritten. Possibly the corruption is happening before.
>> Here is what I see.
> 
> what kernel, for starters?

2.6.16 + XFS from SLES10 I hear...  :)

So for starters, I'd bug SuSE....

otherwise I'd see if it persists upstream.

Is AIO+DIO in the mix?  perhaps it is related to
https://bugzilla.redhat.com/show_bug.cgi?id=217098

-Eric
