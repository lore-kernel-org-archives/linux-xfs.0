Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 097117F5F
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 01:14:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD8268F804B
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 23:14:13 -0800 (PST)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	IaFsZ0TdBCRwDpEA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 23:14:12 -0800 (PST)
Received: by widem10 with SMTP id em10so19293866wid.0
	for <xfs@oss.sgi.com>; Mon, 02 Mar 2015 23:14:10 -0800 (PST)
Message-ID: <54F55F40.6010508@gmail.com>
Date: Tue, 03 Mar 2015 08:14:08 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
	<54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org>
	<54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org>
	<54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org>
	<54F02446.2050008@gmail.com>
	<20150227175159.GC11031@birch.djwong.org>
In-Reply-To: <20150227175159.GC11031@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Theodore Ts'o <tytso@mit.edu>, linux-man@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, mtk.manpages@gmail.com, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>

On 02/27/2015 06:51 PM, Darrick J. Wong wrote:
> On Fri, Feb 27, 2015 at 09:01:10AM +0100, Michael Kerrisk (man-pages) wrote:
>> On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
>>> On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-pages) wrote:
>>>>
>>>>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
>>>>     in the case of a system crash, the atime and mtime fields
>>>>     on disk might be out of date by at most 24 hours.
>>>
>>> I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
>>> perhaps move that so it's clear it applies to any use of MS_LAZYTIME
>>> has this as a downside.
>>>
>>> Does that make sense?
>>
>> Thanks, Ted. Got it. So, now we have:
>>
>>        MS_LAZYTIME (since Linux 3.20)
> 
> "since Linux 4.0".

D'oh! Yes, thanks. Fixed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
