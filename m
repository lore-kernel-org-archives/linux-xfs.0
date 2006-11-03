Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 03 Nov 2006 06:58:55 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA3EwiaG028538
	for <linux-xfs@oss.sgi.com>; Fri, 3 Nov 2006 06:58:48 -0800
Received: from ruth.realtime.net (mercury.realtime.net [205.238.132.86])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE293D1AFBEA
	for <linux-xfs@oss.sgi.com>; Fri,  3 Nov 2006 06:57:58 -0800 (PST)
Message-ID: <454B58E4.6000802@johngroves.net>
Date: Fri, 03 Nov 2006 08:57:40 -0600
From: John Groves <jgl@johngroves.net>
Reply-To: jgl@johngroves.net
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com> <454A94A6.6040907@johngroves.net> <454AAC6B.7010406@sgi.com> <454AAF31.8050104@Groves.net> <454AB0A0.7050309@sgi.com>
In-Reply-To: <454AB0A0.7050309@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: John Groves <John@Groves.net>, linux-xfs@oss.sgi.com, Dean Roehrich <roehrich@sgi.com>



Vlad Apostolov wrote:

> Just a note that dm_path_to_handle works fine with relative paths on my 
> machine.

In your case, could it be applying the "current working directory" from 
the process context to resolve a full path?  Mine is a daemon, and the 
relative paths are not valid relative to the "cwd" in which the daemon 
was started.

...just a thought.  Otherwise, for the moment I may have to just accept 
it as weird...

Thanks again,
John
