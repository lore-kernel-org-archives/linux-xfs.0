Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UJ0pdQ066512 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 14:00:51 -0500
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id lBaIxXWRip6cJf5J for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 12:02:40 -0700 (PDT)
Message-ID: <5090244F.7060900@sandeen.net>
Date: Tue, 30 Oct 2012 14:02:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Daily crash in xfs_cmn_err
References: <CADLDEKtkwaitKCsU21JnsesM70H5AwkEFQFcdmOHE0JU9Oa8nw@mail.gmail.com>
	<20121029125330.GS29378@dastard>
	<CADLDEKv8Y0Z+4gfJYhxi=-CejkkdaGBjtx1og6n8G6z1o9xpSA@mail.gmail.com>
In-Reply-To: <CADLDEKv8Y0Z+4gfJYhxi=-CejkkdaGBjtx1og6n8G6z1o9xpSA@mail.gmail.com>
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
To: Juerg Haefliger <juergh@gmail.com>
Cc: xfs@oss.sgi.com

On 10/30/12 3:58 AM, Juerg Haefliger wrote:
> On Mon, Oct 29, 2012 at 1:53 PM, Dave Chinner <david@fromorbit.com> wrote:
>> On Mon, Oct 29, 2012 at 11:55:15AM +0100, Juerg Haefliger wrote:
>>> Hi,
>>>
>>> I have a node that used to crash every day at 6:25am in xfs_cmn_err
>>> (Null pointer dereference).
>>
>> Stack trace, please.
> 
> 
> [128185.204521] BUG: unable to handle kernel NULL pointer dereference
> at 00000000000000f8

...

> 
> mp passed to xfs_cmn_err was a Null pointer  and mp->m_fsname in the
> printk line caused the crash (offset of m_fsname is 0xf8).
> 
> Error message extracted from the dump:
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1449 of file
> fs/xfs/xfs_alloc.c.
> 
> And the comments in the source:
> 1444 /*
> 1445 * If this failure happens the request to free this
> 1446 * space was invalid, it's (partly) already free.
> 1447 * Very bad.
> 1448 */
> 1449 XFS_WANT_CORRUPTED_GOTO(gtbno >= bno + len, error0);

and:

#define XFS_WANT_CORRUPTED_GOTO(x,l)    \
 ...
                        XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_GOTO", \
                                         XFS_ERRLEVEL_LOW, NULL); \

so it explicitly passes a NULL to XFS_ERROR_REPORT(), which sends
it down the xfs_error_report->xfs_cmn_err path and boom.

So you have a persistent on-disk corruption, but it's causing
this to blow up due to an old bug.

I think it got fixed in 2.6.39, there it finds its way to
__xfs_printk() which does:

        if (mp && mp->m_fsname) {
                printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
                return;
        }

and so handles the null mp situation.

Anyway; I'd repair the fs; if you are paranoid, do:

xfs_metadump -o /dev/blah metadumpfile
xfs_mdrestore metadumpfile filesystem.img
xfs_repair filesystem.img
mount -o loop filesystem.img /some/place

first, and you can see for sure what xfs_repair will do to the real
device, and what the fs looks like when it's done (no data will be
present in the metadumped image, just metadata)

-Eric

> 
>>> 1) I was under the impression that during the mounting of an XFS
>>> volume some sort of check/repair is performed.  How does that differ
>>> from running xfs_check and/or xfs_repair?
>>
>> Journal recovery is performed at mount time, not a consistency
>> check.
>>
>> http://en.wikipedia.org/wiki/Filesystem_journaling
> 
> Ah OK. Thanks for the clarification.
> 
> 
>>> 2) Any ideas how the filesystem might have gotten into this state? I
>>> don't have the history of that node but it's possible that it crashed
>>> previously due to an unrelated problem. Could this have left the
>>> filesystem is this state?
>>
>> <shrug>
>>
>> How long is a piece of string?
>>
>>> 3) What exactly does the ouput of the xfs_check mean? How serious is
>>> it? Are those warning or errors? Will some of them get cleanup up
>>> during the mounting of the filesystem?
>>
>> xfs_check is deprecated.  The output of xfs_repair indicates
>> cross-linked extent indexes. Will only get properly detected and
>> fixed by xfs_repair. And "fixed" may mean corrupt files are removed
>> from the filesystem - repair does nto guarantee that your data is
>> preserved or consistent after it runs, just that the filesystem is
>> consistent and error free.
>>
>>> 4) We have a whole bunch of production nodes running the same kernel.
>>> I'm more than a little concerned that we might have a ticking timebomb
>>> with some filesystems being in a state that might trigger a crash
>>> eventually. Is there any way to perform a live check on a mounted
>>> filesystem so that I can get an idea of how big of a problem we have
>>> (if any)?
>>
>> Read the xfs_repair man page?
>>
>> -n     No modify mode. Specifies that xfs_repair should not
>>        modify the filesystem but should only scan the  filesystem
>>        and indicate what repairs would have been made.
>> .....
>>
>> -d     Repair dangerously. Allow xfs_repair to repair an XFS
>>        filesystem mounted read only. This is typically done on a
>>        root fileystem from single user mode, immediately followed by
>>        a reboot.
>>
>> So, remount read only, run xfs_repair -d -n will check the
>> filesystem as best as can be done online. If there are any problems,
>> then you can repair them and immediately reboot.
>>
>>> i don't claim to know exactly what I'm doing but I picked a
>>> node, froze the filesystem and then ran a modified xfs_check (which
>>> bypasses the is_mounted check and ignores non-committed metadata) and
>>> it did report some issues. At this point I believe those are false
>>> positive. Do you have any suggestions short of rebooting the nodes and
>>> running xfs_check on the unmounted filesystem?
>>
>> Don't bother with xfs_check. xfs_repair will detect all the same
>> errors (and more) and can fix them at the same time.
> 
> Thanks for the hints.
> 
> ...Juerg
> 
> 
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
