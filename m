Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58742 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751562AbdB0PrZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Feb 2017 10:47:25 -0500
Subject: Re: Why does fsck.xfs not do what xfs_repair -n does?
References: <bfb182d9-a005-2d9f-355e-0d785c87c116@gmx.net>
 <20170227081636.2evil6tpv75o5ldw@eorzea.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <26e4d035-9827-541e-3ad4-cc3a9b7f4fa0@sandeen.net>
Date: Mon, 27 Feb 2017 09:37:48 -0600
MIME-Version: 1.0
In-Reply-To: <20170227081636.2evil6tpv75o5ldw@eorzea.usersys.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marcel Partap <mpartap@gmx.net>, linux-xfs@vger.kernel.org



On 2/27/17 2:16 AM, Carlos Maiolino wrote:
> On Fri, Feb 24, 2017 at 09:49:17PM +0100, Marcel Partap wrote:
>> Dear XFS dev crew,
>>> fsck.xfs(8)
>>>         fsck.xfs - do nothing, successfully
>>>         If you wish to check the consistency of an XFS filesystem, or repair a damaged or corrupt XFS filesystem, see xfs_repair(8).
>>
>> So there's a FS check command that does not work as with all the other filesystems. Instead of checking the FS, it tells you to use xfs_repair both for - XFS repair.. and XFS check. Whereas in the man page of
>>> xfs_repair - repair an XFS filesystem
>> it doesn't tell you right at the top that xfs_repair can check XFS. Instead
>>> *       -n     No modify mode. Specifies that xfs_repair should […]  *scan  the  filesystem*
> 
> Xfs used to have two different tools for that. xfs_check and xfs_repair. This
> required one more tool, several more lines of code to be maintained, while
> xfs_repair does the check job with '-n' option, so, it was decided to deprecate
> xfs_check and keep efforts only in xfs_repair.
> 
>>
>> Is this imperative? It does not make any sense to me apart from the quirk.
>>
> I am not quite sure what you mean by "imperative" here, but most (if not all)
> repair tools, have a dry-run mode with -n, as so, xfs_repair also does. The name
> of xfs tool is also kept due historical reasons, once, AFAIK, xfs_repair is the
> name for the tool since its beginning.

Yep. TBH, fsck.xfs was added only to satisfy initscripts which expect a fsck.$FS
for every filesystem at boot time.

But as a journaling filesystem, xfs has no need for a boot-time fsck.  xfs_repair
is for exceptional circumstances, not for a normal reboot with a log replay.

So there is no reason to execute a potentially long xfs_repair -n via fsck.xfs
on every boot; that would completely defeat the purpose of the metadata
journaling.

Like Carlos, I am also confused about what change you'd actually like to see
here.

Thanks,
-Eric

> If you believe that the first description of xfs_repair's man page, should say
> something like "check and repair an XFS filesystem", feel free to send a patch
> for that, IMHO I really don't see any reason for that, giving that the main goal
> of such tools are to fix filesystem inconsistencies.
> 
> Cheers
> 
