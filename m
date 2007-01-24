Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 18:54:57 -0800 (PST)
Received: from evaldomino.Falconstor.com (mail1.falconstor.com [216.223.47.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0O2sqqw024141
	for <linux-xfs@oss.sgi.com>; Tue, 23 Jan 2007 18:54:53 -0800
Message-ID: <45B6C5C4.50005@falconstor.com>
Date: Tue, 23 Jan 2007 21:34:44 -0500
From: "Geir A. Myrestrand" <geir.myrestrand@falconstor.com>
Reply-To: geir.myrestrand@falconstor.com
MIME-Version: 1.0
Subject: Re: Will xfs_growfs succeed on a full file system?
References: <45B6277F.20506@falconstor.com> <20070124020750.GD44411608@melbourne.sgi.com>
In-Reply-To: <20070124020750.GD44411608@melbourne.sgi.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

David Chinner wrote:
> On Tue, Jan 23, 2007 at 10:19:27AM -0500, Geir A. Myrestrand wrote:
>> Does xfs_growfs depend on some space left on the file system in order to 
>> be able to grow it?
> 
> Yes, it does require some space to be left because growing the
> filesystem can require extending the original last AG to the full
> size and that means there may be btree work to be journalled
> and hence we have to reserve blocks for that to succeed in all
> cases.
> 
>> I have a colleague who ran into an issue where a file system resize 
>> failed. The file system is 100% full.
> 
> Yup, we hit that in QA recently and have an open bug for it.
> 
>> Aside from analyzing what happened in his case, should XFS be able to 
>> grow a file system that is 100% full?
> 
> Yes, it should.
> 
>> The device has already been expanded, it is the XFS file system that 
>> fails to resize. I just wonder if that is by design, or whether it is an 
>> issue.
> 
> It's a bug, really, but one you can easily work around by freeing
> up about 50k of space. If you've got a really large filesystem, then
> you might need to free more space than that.
> 
> At some point in my copious amounts of free time I'll fix it properly...

Thanks a lot for your feedback David. We look forward to a fix, but just 
knowing that it is an issue and that we easily can work around it helps 
a lot. Thanks again!


-- 

Geir A. Myrestrand
