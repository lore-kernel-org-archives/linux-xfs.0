Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Nov 2006 19:00:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA330SaG023868
	for <linux-xfs@oss.sgi.com>; Thu, 2 Nov 2006 19:00:33 -0800
Message-ID: <454AB0A0.7050309@sgi.com>
Date: Fri, 03 Nov 2006 13:59:44 +1100
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS dmapi: dm_path_to_handle fails if the path is a directory
References: <4547DA70.4040107@Groves.net> <4547EDFD.8020407@sgi.com> <454A94A6.6040907@johngroves.net> <454AAC6B.7010406@sgi.com> <454AAF31.8050104@Groves.net>
In-Reply-To: <454AAF31.8050104@Groves.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: John Groves <John@Groves.net>
Cc: jgl@johngroves.net, linux-xfs@oss.sgi.com, Dean Roehrich <roehrich@sgi.com>

John Groves wrote:
> Vlad Apostolov wrote:
>
>> Hi John,
>>
>> I did try this on my dmapi filesystem:
>>
>> emu:/mnt/scratch1/dmapi_test # mkdir -p x/y/z
>> emu:/mnt/scratch1/dmapi_test # 
>> /home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle 
>> x/y
>> 5d1111a90e4800000e00000003000000d903400000000000
>> emu:/mnt/scratch1/dmapi_test # mv x/y x/w
>> emu:/mnt/scratch1/dmapi_test # 
>> /home/vapo/isms/xfs-cmds/xfstests/dmapi/src/suite1/cmd/path_to_handle 
>> x/w
>> 5d1111a90e4800000e00000003000000d903400000000000
>> emu:/mnt/scratch1/dmapi_test #
>>
>> I also tried path_to_handle with relative path to a directory it 
>> worked fine too. When you say
>> dm_path_to_handle fails, what is the error returned?
>>
>> Regards,
>> Vlad
>>
>
> Vlad,
>
> This was my bad -- I need to go back to programming school ;-).
>
> The function in question was dealing in mount-point-relative paths, 
> not full paths, and I didn't notice the distinction.  Passing a full 
> path to dm_path_to_handle fixed it.  As for thinking it behaved 
> differently for a directory than for a file -- I've been smoking a 
> batch of bad crack ;-).  Calling dm_path_to_handle also failed with 
> relative paths to files -- I just didn't notice because it wasn't 
> fatal on that code path.
>
> Thanks for responding and looking into it, though.
>
> Regards,
> John
>
No problems John,

Just a note that dm_path_to_handle works fine with relative paths on my 
machine.

Regards,
Vlad
