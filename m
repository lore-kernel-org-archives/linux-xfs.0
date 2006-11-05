Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Nov 2006 14:38:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA5Mc0aG007297
	for <linux-xfs@oss.sgi.com>; Sun, 5 Nov 2006 14:38:03 -0800
Message-ID: <454E6795.1040900@sgi.com>
Date: Mon, 06 Nov 2006 09:37:09 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com> <454A94A6.6040907@johngroves.net> <454AAC6B.7010406@sgi.com> <454AAF31.8050104@Groves.net> <454AB0A0.7050309@sgi.com> <454B58E4.6000802@johngroves.net>
In-Reply-To: <454B58E4.6000802@johngroves.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: jgl@johngroves.net
Cc: John Groves <John@Groves.net>, linux-xfs@oss.sgi.com, Dean Roehrich <roehrich@sgi.com>

John Groves wrote:
>
>
> Vlad Apostolov wrote:
>
>> Just a note that dm_path_to_handle works fine with relative paths on 
>> my machine.
>
> In your case, could it be applying the "current working directory" 
> from the process context to resolve a full path?  Mine is a daemon, 
> and the relative paths are not valid relative to the "cwd" in which 
> the daemon was started.
>
> ...just a thought.  Otherwise, for the moment I may have to just 
> accept it as weird...
>
> Thanks again,
> John
I am using

xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle

and the relative path passed as an argument is directly given to 
dm_path_to_handle().
The current working directory
I can't really explain why it doesn't work in your case. Here is an 
example of a directory
path to handle I get:

emu:/home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd # 
./path_to_handle /mnt/scratch1/dmapi
5d1111a90e4800000e0000006e0000008300000000000000
emu:/home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd # 
./path_to_handle ../../../../../../../../../mnt/scratch1/dmapi
5d1111a90e4800000e0000006e0000008300000000000000
emu:/home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd # cd /
emu:/ # 
/home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle 
../../../../../../../../../mnt/scratch1/dmapi
5d1111a90e4800000e0000006e0000008300000000000000

Regards,
Vlad
