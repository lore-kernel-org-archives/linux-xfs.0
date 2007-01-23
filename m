Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 09:45:52 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0NHjgqw021570
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jan 2007 09:45:43 -0800
Message-ID: <45B64383.4030603@falconstor.com>
Date: Tue, 23 Jan 2007 12:18:59 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: Will xfs_growfs succeed on a full file system?
References: <45B6277F.20506@falconstor.com> <45B63AA1.8010504@sandeen.net>
In-Reply-To: <45B63AA1.8010504@sandeen.net>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Eric Sandeen wrote:
> Geir A. Myrestrand wrote:
>> Does xfs_growfs depend on some space left on the file system in order to 
>> be able to grow it?
>>
>> I have a colleague who ran into an issue where a file system resize 
>> failed. The file system is 100% full.
>>
>> Aside from analyzing what happened in his case, should XFS be able to 
>> grow a file system that is 100% full?
>>
>> The device has already been expanded, it is the XFS file system that 
>> fails to resize. I just wonder if that is by design, or whether it is an 
>> issue.
>>
> 
> Off the top of my head, I think it should work ok even if full, although
> I could be (and apparently I am) wrong here.  How exactly did the growfs
> fail?
> 
> I actually wasn't able to completely fill my filesystem, got stuck at
> 20k left.  :)  but growing that from 50M to 100M worked fine for me.
> 
> -Eric

The only error I saw in his output was this line:

xfs_growfs:
XFS_IOC_FSGROWFSDATA xfsctl failed: No space left on device

He claims that the file system is actually resized after it has been 
re-mounted. He verifies with df:

After expansion (with xfs_growfs):

# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/vbdi6               93504     93504         0 100% /nas/NASDisk-00006

# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/vbdi6                64       6      58   10% /nas/NASDisk-00006

After re-mount:

# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/vbdi6              200000     93516    106484  47% /nas/NASDisk-00006

# df -i
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/vbdi6            204800       6  204794    1% /nas/NASDisk-00006


-- 

Geir A. Myrestrand
