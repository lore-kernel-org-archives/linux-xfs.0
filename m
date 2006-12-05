Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 04:00:31 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.171])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB5C0NaG020519
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 04:00:24 -0800
Message-ID: <45755C26.2080505@gmx.net>
Date: Tue, 05 Dec 2006 12:46:46 +0100
From: Klaus Strebel <klaus.strebel@gmx.net>
MIME-Version: 1.0
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com> <457080EA.1010807@sgi.com> <20061203234928.GA37654165@melbourne.sgi.com>
In-Reply-To: <20061203234928.GA37654165@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> On Fri, Dec 01, 2006 at 07:22:18PM +0000, Lachlan McIlroy wrote:
>> David Chinner wrote:
>>> On Thu, Nov 30, 2006 at 06:03:40PM +0000, Lachlan McIlroy wrote:
>>> I think the slow path code is somewhat clearer with a separate
>>> mutex - it clearly documents the serialisation barrier that
>>> the slow path uses and allows us to do slow path checks on the
>>> per-cpu counters without needing the SB_LOCK.
>> It's certainly an improvement over the original code.
>>
>>> It also means that in future, we can slowly remove the need for
>>> holding the SB_LOCK across the entire rebalance operation and only
>>> use it when referencing the global superblock fields during
>>> the rebalance.
>> Sounds good.
>>
>>> If the need arises, it also means we can move to a mutex per counter
>>> so we can independently rebalance different types of counters at the
>>> same time (which we can't do right now).
>> That seems so obvious - I'm surprised we can't do it now.
> 
> Well, the reason I didn't go down this path in the first place
> was that typically only one type of counter would need rebalancing
> at a time (e.g. free blocks or free inodes, but not both at the
> same time). I tested this out on revenue2 with simultaneous creates
> and deletes of small files but could not cause contention on the
> single global lock under these loads. i also tried parallel
> writes of large files with creates and deletes, but hte create/delete
> was slowed sufficiently by the parallel writes that it once again
> didn't cause an issue.
> 
> Hence it didn't seem to be an issue and a single lock simplified
> the initial implementation. What I'm thinking now is that it may
> become an issue with MDFS as acheivable create and delete rates
> should be much higher on one of these filesystems and then it may
> prove to be an issue.
> 
> Cheers,
> 
> Dave.

Hi guys,

just updated my CVS copy from oss.sgi.com ( the linux-2.6-xfs ) and 
tried to compile ... but your patch failes to compile if HAVE_PERCPU_SB 
is #ifndef'd :-(, the m_icsb_mutex is not in the struct see xfs_mount.h. 
Make oldconfig didn't show HAVE_PERCPU_SB as option for .config, looks 
like nobody tested on a single processor config ??

Ciao
Klaus

-- 
Mit freundlichen Grüssen / best regards

Klaus Strebel, Dipl.-Inform. (FH), mailto:klaus.strebel@gmx.net

/"\
\ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
/ \
