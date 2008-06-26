Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 14:18:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QLIhlG020146
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:18:43 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA1F728BD8E
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:19:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id fx9y4UcVGKMMbWPr for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 14:19:44 -0700 (PDT)
Message-ID: <486407EB.70703@sandeen.net>
Date: Thu, 26 Jun 2008 16:19:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: is the flush-on-close-after-truncate still needed?
References: <4859415B.3000009@sandeen.net> <200806181049.07812.dchinner@agami.com> <20080626210904.GA15920@bob.dscon.sk>
In-Reply-To: <20080626210904.GA15920@bob.dscon.sk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: DS <xfs@bob.dscon.sk>
Cc: xfs@oss.sgi.com

DS wrote:
> Hmm, but file overwrite in perl/php is slow, very slow.

If you have control over your perl/php, perhaps you can change it to do
unlink/create/write instead of truncate/write?

-Eric

> Which FS is best for me?
> XFS - perl/php overwrite problem
> EXT3 - 32000 subdirs limit
> REISER - no future
> JFS - ?
> 
> DS
> 
> On Wed, Jun 18, 2008 at 10:49:07AM -0700, Dave Chinner wrote:
>> On Wednesday 18 June 2008 10:09 am, Eric Sandeen wrote:
>>> After Lachlan's fix to separate on-disk and in-memory sizes, and only
>>> update on-disk when data is on-disk
>>> (http://www.linux.sgi.com/archives/xfs/2007-05/msg00020.html) is the
>>> XFS_ITRUNCATED flag / flush-on-close-after-truncate still needed?
>> Yes, because waiting 30s before writing back /etc/fstab after it
>> has been modified will result in lots of bug reports of /etc/fstab
>> being zero length after a crash instead of being full of NULLs.
>> We have had very few reports of zero length files or files with
>> NULLs since this change was made (regardless of the file size 
>> update ordering changes). i.e. if we remove this code then the
>> common case where NULL files occurred will return - only this
>> time as zero length files.
>>
>> Cheers,
>>
>> Dave.
>>
>>
> 
> 
