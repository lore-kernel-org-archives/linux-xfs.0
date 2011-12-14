Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBEMgjSE234406 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 16:42:45 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 090FB2C32B7
	for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 14:42:43 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id E1evCNpSDJCrJg2Q for <xfs@oss.sgi.com>;
	Wed, 14 Dec 2011 14:42:43 -0800 (PST)
Message-ID: <4EE9265F.7030801@suse.com>
Date: Wed, 14 Dec 2011 17:42:39 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: xfs-trace-ilock-more
References: <20111214024040.GA17780@infradead.org>
	<20111214182750.GH11114@wotan.suse.de>
	<4EE8F7F0.7070207@suse.com> <20111214203243.GN3179@dastard>
In-Reply-To: <20111214203243.GN3179@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/14/2011 03:32 PM, Dave Chinner wrote:
> On Wed, Dec 14, 2011 at 02:24:32PM -0500, Jeff Mahoney wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 12/14/2011 01:27 PM, Mark Fasheh wrote:
>>> Hey Christoph,
>>> 
>>> On Tue, Dec 13, 2011 at 09:40:40PM -0500, Christoph Hellwig
>>> wrote:
>>>> Can you explain the story behid this patch in SLES11SP1?
>>> 
>>> We were looking at some performance issues and needed a bit
>>> more information on the amount of time spent in ilock. I can
>>> give you more specifics if you want, I just have to dig up the
>>> e-mails (it's been a while).
>> 
>> That's pretty much the explanation. With heavy reader load,
>> buffered writes were stalling for 80 ms and sometimes longer. I
>> suspected it was contention on the ilock and the tracing with
>> that patch demonstrated a delay there. Since we were chasing a
>> similar issue at another site, it seemed worthwhile to just keep
>> it around. We're still tracking down the cause. I'm not sure if
>> more recent kernels have the same issue as there's been quite a
>> lot of churn.
> 
> I'm not surprised - there's nothing really guaranteeing bound
> shared vs exclusive access to the ilock. It's all down to the
> read/write bias of the rwsem - readers will hold off the writer for
> some time. Still, it would be nice to see a trace from such a
> holdoff to confirm this is actually the case...

Sure, let me dig it up. We do actually have real results from this
workload with the trace running.

> FWIW, if you have an app that requires concurrent, low latency
> reads and writes to the same file, that's what the XFS Direct IO
> was designed for - in most cases the iolock is taken in shared mode
> for both read and write, and so such hold-offs don't generally
> happen...

You don't need to convince me. I agree with you. :)

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO6SZeAAoJEB57S2MheeWyzfgP/3gbX++mlm3pY8iRlWkqEcy4
77OBJyMn0jxUqQkLw3nmrCcIMVJxKREJhtBoNl93mBdN8HZvx1X7nTUst769Ksf/
NsjQd3NMyv/pymjuJBB81APnyc2diM/fz/t5f1gh4xHljKG9rUJS8ogRQ65QBbMG
kDbwtgaXYMZpUpf/GAF7Q0jxefNZbs82BfSsGqDH6e+fdymqD9/GWewyIFCl3tVR
yOk80v4izDwlgtwtm/anq18nqePZl8M3ktwtucpAR/cxZ79nOryGxuqaD5r7GOam
bo/29A5x0UKptsxHKnEvf6JIlznVWR6RzheyV/A6d3gPFkMa8550NBFMmWObjh7h
DA/fcsZFhzD1LZI9BXU58ib6nT3kmtQMHmdsuwPsX5XPLzdymMNFD/yUDP7vhMWC
OR1kkLPBSGeCFK7m0IeScO+jCnVsadhzkeS3rMjbUYCSw3+4OGf21sAJnfsMasPb
Z2ZbbSZdUGItb8bK1lx7WEwST8KC5UYe2n3LIoH8CJ8qH+FrzX0pQKx+Gm2SVoMK
nZZKDbtwN9+ZWRs2p3tEuT34sb/XGFV1XnEBPAv272XAjZKvjwBD8JZF92fQxl8a
e2yjy7+EsqmZXNguTcs+KhLJ69QkKkg6J0rozPgUNHmA+KGhSDCgRI2kMCPDL3MO
uKZ2umow6YYTofS6mBp8
=zmC1
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
