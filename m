Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Jun 2008 13:48:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m53KmAJY022638
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 13:48:11 -0700
Received: from hrndva-omtalb.mail.rr.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FA781E3A69
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2008 13:49:04 -0700 (PDT)
Received: from hrndva-omtalb.mail.rr.com (hrndva-omtalb.mail.rr.com [71.74.56.124]) by cuda.sgi.com with ESMTP id TGikzCV7qZVEFSWc for <xfs@oss.sgi.com>; Tue, 03 Jun 2008 13:49:04 -0700 (PDT)
Received: from tomslinux.homelinux.org ([24.28.24.180])
          by hrndva-omta06.mail.rr.com with ESMTP
          id <20080603204900.FOKT9231.hrndva-omta06.mail.rr.com@tomslinux.homelinux.org>
          for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 20:49:00 +0000
Received: from tomslinux.homelinux.org (localhost [127.0.0.1])
	by tomslinux.homelinux.org (8.13.7/8.13.7) with ESMTP id m53Kmnem029499
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2008 15:48:50 -0500
From: Thomas King <kingttx@tomslinux.homelinux.org>
Message-ID: <13033.143.166.226.57.1212526129.squirrel@tomslinux.homelinux.org>
Date: Tue, 3 Jun 2008 15:48:49 -0500 (CDT)
Subject: Re: Questions for article
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

>
>
> On Tue, 3 Jun 2008, Thomas King wrote:
>
>> I am writing an article to answer Henry Newman's at
>> http://www.enterprisestorageforum.com/sans/features/article.php/3749926. I've
>> already been bugging folks on the ext4 mailing list and one of them mentioned
>> I
>> should also send some of the same questions to this list. Please let me know
>> if
>> I may do so.
>>
>> Thanks!
>> Tom King
>>
>>
>
> What are the questions?
>
> Justin.

For the most part, XFS is used for massive filesystems (hundreds of petabytes)
successfully in Linux (among other OS's). However, Mr. Newman still believes
there are details that he believes XFS doesn't include or Linux limits (such as
page sizes in x86 limiting block sizes).

With that preface, here are some questions:
-Is XFS fully RAID aware inthat it aligns metadata with RAID stripes? Some of
the information I see states XFS can get geometry information from LVM and MD,
but what about hardware RAID?
-Does XFS take advantage of T10 DIF (block protection?)?
-Does/Will XFS support NFS v4.1?
-Concerning the block-size limit, will this eventually be a thing of the past?
Mr. Newman's contention is massive filesystems should have much larger block
sizes, but he also contends that OSD is the eventual answer instead of using
block allocation.
-Is there anything else y'all would like folks to understand about XFS and
massive implementations?

Thanks!
Tom King
