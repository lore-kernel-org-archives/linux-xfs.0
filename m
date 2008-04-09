Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 06:10:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39DAbdV013188
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 06:10:38 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5213876AB55
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2008 06:11:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 8a5YcZdmRB2AkJGI for <xfs@oss.sgi.com>; Wed, 09 Apr 2008 06:11:15 -0700 (PDT)
Message-ID: <47FCC071.40201@sandeen.net>
Date: Wed, 09 Apr 2008 08:11:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Lost+found
References: <1207632033.11530.10.camel@localhost.localdomain> <op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com> <alpine.DEB.1.10.0804090628080.322@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0804090628080.322@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Barry Naujok <bnaujok@sgi.com>, Jeffrey Sandel <webmaster@javainbaja.com>, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Wed, 9 Apr 2008, Barry Naujok wrote:
> 
>> On Tue, 08 Apr 2008 15:20:33 +1000, Jeffrey Sandel <webmaster@javainbaja.com> 
>> wrote:
>>
>>> Recently I ran xfs_repair due to a firmware upgrade on an unmounted
>>> disk. The repair recovered the data but moved it to the lost+found
>>> directory.
>>>
>>> How do I recover file names and ownership?
>> The only real options you have AFAIK is the file command to try and identify
>> what type of file it is and just manually inspecting the files.
>>
>> Then, you might be able to derive its filename and where it came from.
>>
>> Regards,
>> Barry.
>>
> 
> Is there any chance this process could ever be improved so that the files 
> are restored back to their original locations or there is something that 
> keeps track of where they were located?

The whole reason they're in lost+found is because they are "orphaned" -
allocated & in use but not referenced by any directory... so the best
xfs_repair can do is rename to lost+found with the inode number.

Crosses my mind that one could probably write a generic tool which could
work with a package manager db to check file md5sums in /lost+found, if
the files happen to be system files installed via a package.... but if
they're files from your homedir or whatnot, it's tougher.

-Eric
