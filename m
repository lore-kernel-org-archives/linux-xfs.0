Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 20:01:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m673153Q022247
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 20:01:06 -0700
Received: from bby1mta03.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 031CD11DD0A5
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 20:02:09 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (bby1mta03.pmc-sierra.com [216.241.235.118]) by cuda.sgi.com with ESMTP id nOZv9jkLuVXAvpZa for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 20:02:09 -0700 (PDT)
Message-ID: <4871872B.9060107@pmc-sierra.com>
Date: Mon, 07 Jul 2008 08:32:03 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net>
In-Reply-To: <487117FC.9090109@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------080806010108010907030600"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------080806010108010907030600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Eric Sandeen wrote:
> Sagar Borikar wrote:
>   
>> Sagar Borikar wrote:
>>     
>>> Copy is of the same file to 30 different directories and it is
>>>       
>> basically
>>     
>>> overwrite.
>>>
>>> Here is the setup:
>>>
>>> It's a JBOD with Volume size 20 GB. The directories are empty and this
>>> is basically continuous copy of the file on all thirty directories.
>>>       
>> But
>>     
>>> surprisingly none of the copy succeeds. All the copy processes are in 
>>> Uninterruptible sleep state and xfs_repair log I have already attached
>>>       
>>> With the prep. As mentioned it is with 2.6.24 Fedora kernel.
>>>       
>> It would probably be best to try a 2.6.26 kernel from rawhide to be sure
>> you're closest to the bleeding edge.
>>
>> <Sagar> Sure Eric but I reran the test and I got similar errors with
>> 2.6.24 kernel on x86. I am still confused with the results that I see on
>> 2.6.24 kernel on x86 machine. I see that the used size shown by ls is
>> way too huge than the actual size. Here is the log of the system
>>
>> [root@lab00 ~/test_partition]# ls -lSah
>> total 202M
>> -rw-r--r--  1 root root 202M Jul  4 14:06 original ---> this I sthe file
>> Which I  copy.
>> drwxr-x--- 65 root root  12K Jul  6 21:57 ..
>> -rwxr-xr-x  1 root root  189 Jul  4 16:31 runall
>> -rwxr-xr-x  1 root root   50 Jul  4 16:32 copy
>> drwxr-xr-x  2 root root   45 Jul  6 22:07 .
>>     
>
> It'd be great if you provided these actual scripts so we don't have to
> guess at what you're doing or work backwards from the repair output :)
>   
Attaching the scripts with this mail.
>   
>> dmesg log doesn't give any information. Here is XFS related
>> info:
>>
>> XFS mounting filesystem loop0
>> Ending clean XFS mount for filesystem: loop0
>> Which is basically for mounting XFS cleanly. But there is no exception
>> in XFS. 
>>     
>
> and nothing else of interest either?
>   
Not really. That's why it was surprising. Even after setting the 
error_level to 11
>   
>> Filesystem has become completely sluggish and response time is increased
>> to 
>> 3-4 minutes for every command.  Not a single copy is complete and all
>> the copy processes are sleeping continuously. 
>>     
>
> And how did you recover from this; did you power-cycle the box?
>   
There was no failure. Only the processes were stalled. System was 
operative.
> -Eric
>   

--------------080806010108010907030600
Content-Type: text/plain;
 name="copy"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="copy"

#! /bin/sh

while [ 1 ]

do
cp -f $1 $2
done






--------------080806010108010907030600
Content-Type: text/plain;
 name="runall"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="runall"

#! /bin/sh

for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
	
mkdir -p testdir_$i	
./copy testfile testdir_$i &
rm -Rf testdir_$1/testfile
./copy testfile testfile_$i &
done

--------------080806010108010907030600--
