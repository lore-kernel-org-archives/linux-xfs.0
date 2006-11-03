Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Nov 2006 18:42:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA32gXaG021241
	for <linux-xfs@oss.sgi.com>; Thu, 2 Nov 2006 18:42:34 -0800
Message-ID: <454AAC6B.7010406@sgi.com>
Date: Fri, 03 Nov 2006 13:41:47 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com> <454A94A6.6040907@johngroves.net>
In-Reply-To: <454A94A6.6040907@johngroves.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: jgl@johngroves.net
Cc: linux-xfs@oss.sgi.com, John Groves <John@Groves.net>, Dean Roehrich <roehrich@sgi.com>

John Groves wrote:
> Thanks for your replies, Vlad, although I don't find anything so far 
> that helps with my problem (my paths are not long, and my calls to 
> dm_path_to_handle have been running in production environments for a 
> couple of years).  As far as I can see, dm_path_to_handle does not 
> work on a directory (?), although it works perfectly on a file.  I 
> will try to dig deeper into this over the next few days, but here is a 
> somewhat clearer explanation of the behavior I am seeing.
>
> I have updated to the latest kernel from SGI's CVS server, but the 
> problem is still there.  I am tracing through kernel code, and will be 
> happy to pull together some test code that demonstrates the problem, 
> or to post a patch if I figure it out, but this will take a few days.
>
> The sequence in which I find this problem is:
>
>    1. Receive a pre-rename event
>    2. Use the first handle parameter to resolve the pre-rename parent 
> directory path (not via dm_handle_to_path -- I had to roll my own 
> mechanisms for turning handles into paths).
>    3. Concatenate the first name parameter to the first parent 
> directory path, to get the relative path from mount point to actual 
> file being renamed.
>    4. Call dm_path_to_handle on that path, hoping to get the handle of 
> the file-being-renamed.
>
> If the renamed-thing is a file, this works.  If it's a directory, 
> dm_path_to_handle fails.
>
> With my dmapi event handler installed and running, I can reproduce it 
> by doing the following in the root directory of the filesystem:
>
> mkdir -p x/y/z
> mv x/y x/w
>
> In the pre-rename event, prior to responding to the event, my handler 
> correctly determines that x/y is being renamed to x/w, but 
> dm_path_to_handle does not return the handle of x/y.  My post-rename 
> event handler also correctly resolves the paths, but dm_path_to_handle 
> does not return the handle of x/w.
>
> If x/y is a file (rather than a directory) it all works properly.
>
> Let me know if you can think of anything specific I should look at, or 
> of a different way of getting the handle of the renamed thingy.
Hi John,

I did try this on my dmapi filesystem:

emu:/mnt/scratch1/dmapi_test # mkdir -p x/y/z
emu:/mnt/scratch1/dmapi_test # 
/home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle x/y
5d1111a90e4800000e00000003000000d903400000000000
emu:/mnt/scratch1/dmapi_test # mv x/y x/w
emu:/mnt/scratch1/dmapi_test # 
/home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle x/w
5d1111a90e4800000e00000003000000d903400000000000
emu:/mnt/scratch1/dmapi_test #

I also tried path_to_handle with relative path to a directory it worked 
fine too. When you say
dm_path_to_handle fails, what is the error returned?

Regards,
Vlad
