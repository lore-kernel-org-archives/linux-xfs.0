Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 22:58:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4U5w8sc021352
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 22:58:09 -0700
Message-ID: <483F979B.5070206@sgi.com>
Date: Fri, 30 May 2008 15:58:51 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Question for XFS (mounting and clean bit)
References: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de> <483E5462.1080604@sgi.com> (sfid-20080529_093513_291114_64DAE2F5) <200805291009.36229.Martin@lichtvoll.de>
In-Reply-To: <200805291009.36229.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Am Donnerstag 29 Mai 2008 schrieb Timothy Shimmin:
>> Hi Andre,
> 
> Hi Timothy,
> 
>> I didn't follow all of this, sorry.
>> When you ask about the "clean bit", I assume that you are referring
>> to "clean XFS mount for filesystem".
>> We effectively mark it clean if we do a successful unmount.
>> As part of unmount, we write an unmount record into the xfs log.
>> On the next mount we look for the head of the log and then for the
>> unmount record nearby. If we find the unmount record then we know
>> we have had a clean unmount previously, otherwise we replay the log.
>> So it's really a question of doing an unmount versus resetting the
>> box beforehand or forcing a shutdown beforehand.
> 
> But when is it dirtied? If the clean log entry is the actual "clean bit" I 
> guess: When the first new entry is written in the log.
> 
Yes.
As soon as the first new entry is written in the log it will effectively
change the head of the log.
The head of the log can basically be seen (simplified version) at the
change of cycle#s of the 512byte sectors of the log (each sector is encoded
with a cycle# at or near the start; the cycle# is the number of times
that we have wrapped the log).
e.g.     5 5 5 5 5 5 4 4 4 4 4
                   ^head
(we actually typically have a set of 8 log buffers that have writes issued on so
 there could easily be bumps in the example....5 5 4 4 5 4 4 etc..)
When we find the head we scan back for the start of a log record
and look for the unmount record and so we'd have
a problem if we don't find one and then we'd know it is dirty.


> Does XFS write a log entry on mounting it already or only on the first 
> real write? Or in other words if I mount a XFS filesystem without writing 
> to it and reset the machine, would it be marked clean or dirty then? 
> Hmmm, I could test this ;-).
> 
I believe it will be clean and I tried it out too :)

--Tim
