Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Nov 2006 19:01:54 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kA331maG024120
	for <linux-xfs@oss.sgi.com>; Thu, 2 Nov 2006 19:01:50 -0800
Received: from n034.sc1.cp.net (smtpout1453.sc1.he.tucows.com [64.97.157.153])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C77FD1B2073
	for <linux-xfs@oss.sgi.com>; Thu,  2 Nov 2006 19:01:01 -0800 (PST)
Message-ID: <454AAF31.8050104@Groves.net>
Date: Thu, 02 Nov 2006 20:53:37 -0600
From: John Groves <John@Groves.net>
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com> <454A94A6.6040907@johngroves.net> <454AAC6B.7010406@sgi.com>
In-Reply-To: <454AAC6B.7010406@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: jgl@johngroves.net, linux-xfs@oss.sgi.com, Dean Roehrich <roehrich@sgi.com>

Vlad Apostolov wrote:

> Hi John,
>
> I did try this on my dmapi filesystem:
>
> emu:/mnt/scratch1/dmapi_test # mkdir -p x/y/z
> emu:/mnt/scratch1/dmapi_test # 
> /home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle x/y
> 5d1111a90e4800000e00000003000000d903400000000000
> emu:/mnt/scratch1/dmapi_test # mv x/y x/w
> emu:/mnt/scratch1/dmapi_test # 
> /home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle x/w
> 5d1111a90e4800000e00000003000000d903400000000000
> emu:/mnt/scratch1/dmapi_test #
>
> I also tried path_to_handle with relative path to a directory it 
> worked fine too. When you say
> dm_path_to_handle fails, what is the error returned?
>
> Regards,
> Vlad
>

Vlad,

This was my bad -- I need to go back to programming school ;-).

The function in question was dealing in mount-point-relative paths, not 
full paths, and I didn't notice the distinction.  Passing a full path to 
dm_path_to_handle fixed it.  As for thinking it behaved differently for 
a directory than for a file -- I've been smoking a batch of bad crack 
;-).  Calling dm_path_to_handle also failed with relative paths to files 
-- I just didn't notice because it wasn't fatal on that code path.

Thanks for responding and looking into it, though.

Regards,
John
