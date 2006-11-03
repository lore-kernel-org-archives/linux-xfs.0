Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Nov 2006 20:41:11 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA34f3aG007783
	for <linux-xfs@oss.sgi.com>; Thu, 2 Nov 2006 20:41:05 -0800
Received: from ruth.realtime.net (mercury.realtime.net [205.238.132.86])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA791D1B7DD9
	for <linux-xfs@oss.sgi.com>; Thu,  2 Nov 2006 19:41:57 -0800 (PST)
Message-ID: <454A94A6.6040907@johngroves.net>
Date: Thu, 02 Nov 2006 19:00:22 -0600
From: John Groves <jgl@johngroves.net>
Reply-To: jgl@johngroves.net
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com>
In-Reply-To: <4547EDFD.8020407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Vlad Apostolov <vapo@sgi.com>, John Groves <John@Groves.net>, Dean Roehrich <roehrich@sgi.com>

Thanks for your replies, Vlad, although I don't find anything so far 
that helps with my problem (my paths are not long, and my calls to 
dm_path_to_handle have been running in production environments for a 
couple of years).  As far as I can see, dm_path_to_handle does not work 
on a directory (?), although it works perfectly on a file.  I will try 
to dig deeper into this over the next few days, but here is a somewhat 
clearer explanation of the behavior I am seeing.

I have updated to the latest kernel from SGI's CVS server, but the 
problem is still there.  I am tracing through kernel code, and will be 
happy to pull together some test code that demonstrates the problem, or 
to post a patch if I figure it out, but this will take a few days.

The sequence in which I find this problem is:

    1. Receive a pre-rename event
    2. Use the first handle parameter to resolve the pre-rename parent 
directory path (not via dm_handle_to_path -- I had to roll my own 
mechanisms for turning handles into paths).
    3. Concatenate the first name parameter to the first parent 
directory path, to get the relative path from mount point to actual file 
being renamed.
    4. Call dm_path_to_handle on that path, hoping to get the handle of 
the file-being-renamed.

If the renamed-thing is a file, this works.  If it's a directory, 
dm_path_to_handle fails.

With my dmapi event handler installed and running, I can reproduce it by 
doing the following in the root directory of the filesystem:

mkdir -p x/y/z
mv x/y x/w

In the pre-rename event, prior to responding to the event, my handler 
correctly determines that x/y is being renamed to x/w, but 
dm_path_to_handle does not return the handle of x/y.  My post-rename 
event handler also correctly resolves the paths, but dm_path_to_handle 
does not return the handle of x/w.

If x/y is a file (rather than a directory) it all works properly.

Let me know if you can think of anything specific I should look at, or 
of a different way of getting the handle of the renamed thingy.

Thanks,
John Groves

Vlad Apostolov wrote:
> John Groves wrote:
> 
>> I'm running up against a difficult situation because dm_path_to_handle 
>> does not return a handle, if the path is to a directory.  Is this a 
>> known issue, or perhaps fixed in a recent version?  Or is there 
>> another way get the handle of a directory by path?  When any file type 
>> is renamed, I (for various reasons) *must* know not just the old & new 
>> parent handles, but also the handle of the renamed thingy.  If the 
>> thingy is a directory, I'm stuck at the moment.
>>
>> My test system has dmapi 2.2.1-5, which I don't think is current, but 
>> I can't seem to get access to the oss.sgi.com server to check.
>>
>> Any advice or info appreciated.  I'm willing to try and submit a 
>> patch, but I'd appreciate first knowing whether there was a specific 
>> reason or problem that led to the current behavior.
>>
>> Thanks,
>> John Groves
>>
> Hi John,
> 
> If your path is longer than 2000 characters dm_path_to_handle used to fail.
> This bug was fixed in August 2006. Please update your tree from here:
> 
> http://oss.sgi.com/projects/xfs/download.html
> 
> Regards,
> Vlad
> 
> 
> 
> 
