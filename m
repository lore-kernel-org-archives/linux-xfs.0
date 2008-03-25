Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 21:58:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P4w4LH031997
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 21:58:09 -0700
Message-ID: <47E88676.7080006@sgi.com>
Date: Tue, 25 Mar 2008 15:58:30 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: call _notrun in common.dump if dump utils not
 found
References: <47E5CFBA.7060405@sandeen.net> <47E8703C.30603@sgi.com> <op.t8jyw8i63jf8g2@pc-bnaujok.melbourne.sgi.com> <47E87D97.9050900@sandeen.net>
In-Reply-To: <47E87D97.9050900@sandeen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Barry Naujok <bnaujok@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Barry Naujok wrote:
>> On Tue, 25 Mar 2008 14:23:40 +1100, Timothy Shimmin <tes@sgi.com> wrote:
>>
>>> Thanks, Eric.
>>>
>>> On IRIX:
>>>  > where xfsdump xfsrestore xfsinvutil
>>> /sbin/xfsdump
>>> /usr/sbin/xfsdump
>>> /sbin/xfsrestore
>>> /usr/sbin/xfsinvutil
>>>  > ls -l /sbin/xfsdump
>>> lrwxr-xr-x    ... /sbin/xfsdump -> ../usr/sbin/xfsdump*
>>>
>>> I'll add the IRIX xfsrestore path and wait for Russell or
>>> whoever to complain about BSD :)
>> common.config sets up environment variables for the various
>> tools used and can handle these paths. It has them for the
>> xfsprogs tools (XFS_REPAIR_PROG, XFS_DB_PROG, etc) but
>> nothing for the xfsdump tools.
> 
> yeah, that may be better...
> 
Okay. Fair point.
I'll change common.dump to use the XFSDUMP_PROG etc....
and common.config to set the PROG vars.

--Tim
