Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 09:00:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VG0Aqn019266
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 09:00:10 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B1A314BE2E4
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 09:00:10 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id vlAUrTAhxHmptohJ for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 09:00:10 -0700 (PDT)
Message-ID: <490B2B83.7050009@sandeen.net>
Date: Fri, 31 Oct 2008 11:00:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.25.18 in memory corruption?
References: <200810310858.07632.arekm@maven.pl> <490B1DA1.4030107@sandeen.net> <200810311647.33629.arekm@maven.pl>
In-Reply-To: <200810311647.33629.arekm@maven.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

Arkadiusz Miskiewicz wrote:
> On Friday 31 of October 2008, Eric Sandeen wrote:
>> Arkadiusz Miskiewicz wrote:
> 
>>> Any ideas what that could be?
>>>
>>> /**
>>> * A class for reading Microsoft Excel Spreadsheets.
>>> *
>>> * Originally
>>> d4040\134040\134040\134040//"#,##0.00",^M\134012\134040\134040\134040\134
>>> 040\134040\134040\134040\1340400x5\134040=>\134040"%1.0f",\134040\134040\1
>>> 34040\134040\134040/*"$#,##0;
>> Ow, my eyes ;)
>>
>> try:
>>
>> # hexdump -C $FILENAME
>>
>> to see if it's obvious where the corruption boundaries are, or any
>> patterns that might be more readable than
>> "\134012\134040\134040\134040\134040\"  :)
> 
> These backslashes are regular backslashes...

And how does that compare to the good backup? I assume that the
corruption starts...

> 00000fa0  76 65 6c 20 64 6f 63 62  6c 6f 63 6b 2e 0d 0a 2a  |vel docblock...*|
> 00000fb0  2f 0d 0a 0d 0a 2f 2a 2a  0d 0a 2a 20 41 20 63 6c  |/..../**..* A cl|
> 00000fc0  61 73 73 20 66 6f 72 20  72 65 61 64 69 6e 67 20  |ass for reading |
> 00000fd0  4d 69 63 72 6f 73 6f 66  74 20 45 78 63 65 6c 20  |Microsoft Excel |
> 00000fe0  53 70 72 65 61 64 73 68  65 65 74 73 2e 0d 0a 2a  |Spreadsheets...*|
> 00000ff0  0d 0a 2a 20 4f 72 69 67  69 6e 61 6c 6c 79 20 64  |..* Originally d|

here?  well, that's right on a 4k block boundary...

> 00001000  34 30 34 30 5c 31 33 34  30 34 30 5c 31 33 34 30  |4040\134040\1340|
> 00001010  34 30 5c 31 33 34 30 34  30 2f 2f 22 23 2c 23 23  |40\134040//"#,##|
> 00001020  30 2e 30 30 22 2c 0d 5c  31 33 34 30 31 32 5c 31  |0.00",.\134012\1|
<snip>

But it's hard to tell for sure since I don't know what the good data
looks like.  (was this reader.php?)

If you have a good copy, try hexdump -C on both and diff them to see
more clearly where the corruption is.

strange.  Is this pretty repeatable?

-Eric
