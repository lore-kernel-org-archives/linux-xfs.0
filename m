Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 17:04:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5B044UC001254
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 17:04:05 -0700
Date: Wed, 11 Jun 2008 10:04:56 +1000
Subject: Re: XFS directory entries sort order
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <200806101245.09950.dizzy@roedu.net> <87prqpp5q7.fsf@basil.nowhere.org> <op.ucj4nqkv3jf8g2@pc-bnaujok.melbourne.sgi.com> <484F1541.7010203@firstfloor.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ucj46inw3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <484F1541.7010203@firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: dizzy <dizzy@roedu.net>, xfs@oss.sgi.com

On Wed, 11 Jun 2008 09:58:57 +1000, Andi Kleen <andi@firstfloor.org> wrote:

>
>> readdir order is not dependant on the hashes. The order depends on the
>> order of files being created, unlinked and the length of the filenames
>> being unlinked/created.
>
> Thanks for the correction. It's a long time that I read that source
> so it probably got confused with some other fs.

If I read the code correctly, in node-form directories, it will try and
use the same data block that other names with the same hash are located in.

Barry.
