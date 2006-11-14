Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 22:41:37 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAE6fPaG023892
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 22:41:27 -0800
Date: Tue, 14 Nov 2006 16:42:09 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: RHEL 4 Compatible Kernel Module Code
Message-ID: <30F3263F8874E466D6206C56@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <4558B4DC.3050406@sandeen.net>
References: <1163434210.25484.14.camel@houuc8> <4558B4DC.3050406@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Stephen C. Rigler" <srigler@marathonoil.com>, xfs@oss.sgi.com

Hi Eric,

--On 13 November 2006 12:09:32 PM -0600 Eric Sandeen <sandeen@sandeen.net> wrote:

> Stephen C. Rigler wrote:
>> Greetings,
>>
>> We are using CentOS 4.4 along with the RHEL 4 compatible kernel modules
>> (downloadable here:
>> http://mirror.centos.org/centos/4.4/centosplus/x86_64/RPMS/).
>>
>> According to the CentOS mailing list, the person at SGI who had been
>> backporting the xfs code for RHEL4/CentOS4 has left the company.
>>
>> Are there any plans to continue this work?  It seems like we are getting
>> bit by this bug: http://oss.sgi.com/bugzilla/show_bug.cgi?id=410 but it
>> doesn't look like the fix has been backported to the RHEL4 kernel
>> module.
>
> Hot topic today; see my reply on the centos list and other recent
> threads on this list :)  I am planning to update the rpm package to
> include some bugfixes soon, but it may not help your problems.
>
> I had been tracking the sles9 xfs codebase as a fairly stable,
> bugfix-only xfs codebase for this era of kernels; at this point I don't
> -think- the extent changes you mentioned are in the sles9 codebase...
> sgi guys?
>

If you are referring to Mandy's incore extent changes,
I don't see them in sles9 or sles10.

Having a quick look she has about 5 Mods.

 linux-2.4/xfs_ksyms.c |    7
 linux-2.6/xfs_ksyms.c |    7
 quota/xfs_qm.c        |    9
 xfs_bmap.c            |  725 ++++++++++++----------------
 xfs_bmap.h            |   30 -
 xfs_bmap_btree.c      |   10
 xfs_bmap_btree.h      |    8
 xfs_inode.c           | 1258 ++++++++++++++++++++++++++++++++++++++++++++------
 xfs_inode.h           |   71 ++
 xfsidbg.c             |   15
 10 files changed, 1548 insertions(+), 592 deletions(-)

Quite a bit of changes there for xfs_bmap.c and xfs_inode.c.

--Tim
